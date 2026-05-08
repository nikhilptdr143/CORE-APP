<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String sessionUser = (String) session.getAttribute("username");
    if (sessionUser == null || sessionUser.trim().isEmpty()) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CORE App</title>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { background-color: #f4f7f6; height: 100vh; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { background: #fff; padding: 10px 20px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; }
        .content-area { flex: 1; overflow-y: auto; padding-bottom: 70px; }
        .tab-section { display: none; height: 100%; flex-direction: column; }
        .tab-section.active { display: flex; }
        #home-tab { align-items: center; justify-content: center; text-align: center; }
        .qr-box { width: 250px; height: 250px; background: #fff; margin: 20px auto; display: flex; align-items: center; justify-content: center; border: 3px dashed #007bff; border-radius: 10px; }
        .qr-box img { width: 90%; height: 90%; border-radius: 8px; }
        #scanner-tab { background: #111; color: white; align-items: center; padding-top: 30px; }
        #reader { width: 100%; max-width: 350px; background: white; border-radius: 10px; overflow: hidden; }
        #chat-tab { background: #e5ddd5; } 
        .chat-header { background: #007bff; color: white; padding: 15px; font-weight: bold; display: flex; align-items: center; }
        #chat-list-view, #chat-room-view { display: flex; flex-direction: column; height: 100%; background: #fff; }
        .contact-item { padding: 15px; border-bottom: 1px solid #eee; cursor: pointer; }
        .chat-messages { flex: 1; padding: 15px; overflow-y: auto; display: flex; flex-direction: column; }
        .message { padding: 10px 15px; border-radius: 8px; margin-bottom: 10px; max-width: 75%; word-wrap: break-word; }
        .msg-sent { background: #dcf8c6; align-self: flex-end; border-bottom-right-radius: 0; }
        .msg-received { background: #fff; align-self: flex-start; border-bottom-left-radius: 0; }
        .chat-input { display: flex; padding: 10px; background: #f0f0f0; }
        .chat-input input { flex: 1; padding: 12px; border: none; border-radius: 20px; outline: none; }
        .chat-input button { margin-left: 10px; padding: 0 15px; border-radius: 20px; border: none; background: #007bff; color: white; cursor: pointer; }
        .bottom-nav { position: fixed; bottom: 0; left: 0; width: 100%; background: #fff; display: flex; justify-content: space-around; padding: 10px 0; border-top: 1px solid #ddd; }
        .nav-item { background: none; border: none; cursor: pointer; color: #777; display: flex; flex-direction: column; align-items: center; font-size: 14px; width: 33%; }
        .nav-item.active { color: #007bff; font-weight: bold; }
        .modal { display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); }
        .modal-content { background: white; margin: 20% auto; padding: 25px; border-radius: 12px; width: 300px; text-align: center; }
    </style>
</head>
<body>

    <div class="top-header">
        <div class="user-profile">Hi, <%= sessionUser %>!</div>
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:red; text-decoration:none;">Logout 🚪</a>
    </div>

    <div class="content-area">
        <div id="home-tab" class="tab-section active">
            <h2><%= sessionUser %>'s QR Code</h2>
            <div class="qr-box">
                <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=<%= sessionUser %>">
            </div>
            <p>Scan to connect!</p>
        </div>

        <div id="scanner-tab" class="tab-section">
            <h3>Scan QR Code</h3>
            <div id="reader"></div>
        </div>

        <div id="chat-tab" class="tab-section">
            <div id="chat-list-view">
                <div class="chat-header">Chats</div>
                <div id="contacts-container"></div>
            </div>
            <div id="chat-room-view" style="display:none;">
                <div class="chat-header">
                    <button onclick="backToList()" style="background:none; border:white 1px solid; color:white; padding:5px; cursor:pointer;">Back</button>
                    <span id="chat-header-name" style="margin-left: 15px;"></span>
                </div>
                <div class="chat-messages" id="chat-box"></div>
                <div class="chat-input">
                    <input type="text" id="msg-input" placeholder="Type message..." onkeypress="if(event.key==='Enter') sendMessage()">
                    <button onclick="sendMessage()">Send</button>
                </div>
            </div>
        </div>
    </div>

    <div id="scanModal" class="modal">
        <div class="modal-content">
            <h3 id="foundUserName">User Found!</h3>
            <button style="background:#28a745; color:white; padding:10px; border:none; border-radius:5px; margin-top:10px; cursor:pointer;" onclick="sendConnectionRequest()">Add Friend</button>
            <button style="background:#ccc; padding:10px; border:none; border-radius:5px; margin-left:10px; cursor:pointer;" onclick="closeModal()">Cancel</button>
        </div>
    </div>

    <div class="bottom-nav">
        <button class="nav-item active" id="btn-home" onclick="switchTab('home')">Home</button>
        <button class="nav-item" id="btn-scanner" onclick="switchTab('scanner')">Scan</button>
        <button class="nav-item" id="btn-chat" onclick="switchTab('chat')">Chat</button>
    </div>

    <script>
        let myName = "<%= sessionUser %>";
        let ws;
        let chatWith = "";
        let chatHistory = {};
        let tempScannedUser = "";
        let html5QrcodeScanner;

        let contextPath = "<%= request.getContextPath() %>";
        ws = new WebSocket("ws://" + window.location.host + contextPath + "/chatserver/" + myName);

        ws.onmessage = function(event) {
            let incoming = event.data;
            console.log("DEBUG: Received -> " + incoming);
            
            if (incoming.startsWith("REQ:")) {
                let parts = incoming.split(":");
                let sender = parts[2].trim();
                if (confirm(sender + " wants to connect. Add?")) {
                    addContact(sender);
                    ws.send("ACC:" + sender + ":" + myName);
                }
            } 
            else if (incoming.startsWith("ACC:")) {
                let parts = incoming.split(":");
                let accepter = parts[2].trim();
                addContact(accepter);
                alert("Connection established with " + accepter);
            } 
            else {
                let parts = incoming.split(":", 2);
                if (parts.length === 2) {
                    let senderName = parts[0].trim();
                    let messageText = parts[1];

                    if (!chatHistory[senderName]) chatHistory[senderName] = [];
                    chatHistory[senderName].push({ type: "received", text: messageText });

                    if (chatWith === senderName) {
                        renderMessage("received", messageText);
                    } else {
                        renderContactList();
                    }
                }
            }
        };

        function addContact(name) {
            if (!chatHistory[name]) chatHistory[name] = [];
            renderContactList();
        }

        function onScanSuccess(text) {
            stopScanner();
            tempScannedUser = text;
            document.getElementById("foundUserName").innerText = "Found: " + text;
            document.getElementById("scanModal").style.display = "block";
        }

        function sendConnectionRequest() {
            if(tempScannedUser === myName) {
                alert("You cannot add yourself!");
                closeModal();
                return;
            }
            ws.send("REQ:" + tempScannedUser + ":" + myName);
            closeModal();
            alert("Request sent to " + tempScannedUser);
        }

        function closeModal() { document.getElementById("scanModal").style.display = "none"; }

       function renderContactList() {
    let container = document.getElementById("contacts-container");
    container.innerHTML = "";
    
    for (let user in chatHistory) {
        // Hum yahan 'user' ko 'onclick' mein bhej rahe hain
        let contactDiv = document.createElement("div");
        contactDiv.className = "contact-item";
        contactDiv.innerHTML = "👤 " + user;
        
        // Direct click event attach kar rahe hain bypass karne ke liye
        contactDiv.onclick = function() {
            openChatRoom(user);
        };
        
        container.appendChild(contactDiv);
    }
}

        function openChatRoom(userName) {
    // Ye line sabse important hai, isse "Select a user first" wala error jayega
    chatWith = userName; 
    
    // Header mein user ka naam dikhane ke liye
    document.getElementById("chat-header-name").innerText = userName;
    
    // UI ko Chat List se hata kar Chat Room par lane ke liye
    document.getElementById("chat-list-view").style.display = "none";
    document.getElementById("chat-room-view").style.display = "flex";
    
    // Purane messages clear karke naye dikhane ke liye
    let chatBox = document.getElementById("chat-box");
    chatBox.innerHTML = "";
    
    if (!chatHistory[userName]) {
        chatHistory[userName] = [];
    }
    
    chatHistory[userName].forEach(msg => {
        renderMessage(msg.type, msg.text);
    });
}

        function backToList() {
            chatWith = "";
            document.getElementById("chat-room-view").style.display = "none";
            document.getElementById("chat-list-view").style.display = "flex";
            renderContactList();
        }

       function sendMessage() {
    let inputField = document.getElementById("msg-input");
    let text = inputField.value.trim();
    
    if (text !== "" && chatWith !== "") {
        // Use trim on chatWith just in case
        ws.send(chatWith.trim() + ":" + text);
        
        if (!chatHistory[chatWith]) chatHistory[chatWith] = [];
        chatHistory[chatWith].push({ type: "sent", text: text });
        
        renderMessage("sent", text);
        inputField.value = "";
    } else {
        alert("Select a user first!");
    }
}
        function renderMessage(type, text) {
            let box = document.getElementById("chat-box");
            let div = document.createElement("div");
            div.className = "message " + (type === "sent" ? "msg-sent" : "msg-received");
            div.innerText = text;
            box.appendChild(div);
            box.scrollTop = box.scrollHeight;
        }

        function switchTab(t) {
            document.querySelectorAll('.tab-section').forEach(s => s.classList.remove('active'));
            document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
            document.getElementById(t + '-tab').classList.add('active');
            document.getElementById('btn-' + t).classList.add('active');
            if (t === 'scanner') startScanner(); else stopScanner();
        }

        function startScanner() {
            if (!html5QrcodeScanner) {
                html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: 250 }, false);
                html5QrcodeScanner.render(onScanSuccess);
            }
        }
        function stopScanner() { if (html5QrcodeScanner) { html5QrcodeScanner.clear(); html5QrcodeScanner = null; } }
    </script>
</body>
</html>