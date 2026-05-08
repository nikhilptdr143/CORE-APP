<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - CORE App</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: #f4f7f6; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0; 
        }
        .form-box { 
            background: white; 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); 
            width: 350px; 
        }
        h2 { 
            text-align: center; 
            color: #28a745; 
            margin-bottom: 25px; 
            font-size: 24px;
        }
        input { 
            width: 100%; 
            padding: 12px; 
            margin: 12px 0; 
            border: 1px solid #ddd; 
            border-radius: 6px; 
            box-sizing: border-box; 
            outline: none; 
            transition: 0.3s;
        }
        input:focus {
            border-color: #28a745;
            box-shadow: 0 0 5px rgba(40, 167, 69, 0.2);
        }
        button { 
            width: 100%; 
            padding: 12px; 
            background: #28a745; 
            color: white; 
            border: none; 
            border-radius: 6px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: bold; 
            margin-top: 10px;
            transition: 0.3s;
        }
        button:hover { 
            background: #218838; 
        }
        .switch-link { 
            text-align: center; 
            margin-top: 20px; 
            font-size: 14px; 
            color: #666; 
        }
        .switch-link a { 
            color: #007bff; 
            text-decoration: none; 
            font-weight: bold; 
        }
        .switch-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="form-box">
        <h2>Create Account</h2>
        <!-- Action MainServlet hi rahega, hidden field se register handle hoga -->
        <form action="MainServlet" method="POST">
            <input type="hidden" name="action" value="register">
            
            <input type="text" name="name" placeholder="Choose Username" required>
            
            <input type="email" name="email" placeholder="Enter Email ID" required>
            
            <input type="password" name="password" placeholder="Choose Password" required>
            
            <button type="submit">Register Now</button>
        </form>
        
        <div class="switch-link">
            Already have an account? <a href="index.html">Login here</a>
        </div>
    </div>

</body>
</html>