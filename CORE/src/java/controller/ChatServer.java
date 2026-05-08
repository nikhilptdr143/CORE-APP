package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/chatserver/{username}")
public class ChatServer {
    
    private static Map<String, Session> onlineUsers = new HashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("username") String username) {
        onlineUsers.put(username, session);
        System.out.println("User connected: " + username);
    }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("username") String sender) throws IOException {
        System.out.println("DEBUG: Raw from " + sender + " -> " + message);

        if (message.startsWith("REQ:")) {
            // Format: REQ:Target:Sender
            String[] parts = message.split(":");
            if (parts.length >= 3) {
                String targetUser = parts[1].trim(); 
                Session targetSession = onlineUsers.get(targetUser);
                if (targetSession != null && targetSession.isOpen()) {
                    targetSession.getBasicRemote().sendText(message);
                }
            }
        } 
        else if (message.startsWith("ACC:")) {
            String[] parts = message.split(":");
            if (parts.length >= 3) {
                String originalRequester = parts[1].trim();
                Session targetSession = onlineUsers.get(originalRequester);
                if (targetSession != null && targetSession.isOpen()) {
                    targetSession.getBasicRemote().sendText(message);
                }
            }
        } 
        else {
           String[] parts = message.split(":", 2);
            if (parts.length == 2) {
                String receiverName = parts[0].trim();
                String actualMessage = parts[1];

                Session receiverSession = onlineUsers.get(receiverName);
                if (receiverSession != null && receiverSession.isOpen()) {
                    // Send to receiver as "Sender:Message"
                    receiverSession.getBasicRemote().sendText(sender + ":" + actualMessage);
                } else {
                    session.getBasicRemote().sendText("System:User " + receiverName + " is offline.");
                }
            }
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("username") String username) {
        onlineUsers.remove(username);
        System.out.println("User disconnected: " + username);
    }

    @OnError
    public void onError(Throwable t) {
        t.printStackTrace();
    }
}