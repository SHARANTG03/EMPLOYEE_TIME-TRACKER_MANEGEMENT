<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
         .login-options {
            display: flex;
            justify-content: center;
            margin-top: 50px;
        }
        .login-options div {
            margin: 0 20px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            text-align: center;
        }
        .login-options div:hover {
            background-color: green;
            cursor: pointer;
            color:white;
        }
        .login-form {
            width: 300px;
            margin: 100px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
        }
        .login-form h2 {
            text-align: center;
        }
        .login-form input[type="text"], .login-form input[type="password"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .login-form input[type="submit"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            background-color: #28a745;
            color: white;
        }
    </style>
    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            var toggleIcon = document.getElementById("togglePasswordIcon");
            if (passwordField.type === "password") {
                passwordField.type = "text";
                toggleIcon.textContent = "Hide";
            } else {
                passwordField.type = "password";
                toggleIcon.textContent = "Show";
            }
        }
    </script>
</head>
<body>
<center>
    <h1>Welcome</h1>
    </center>
    <div class="login-options">
        <div onclick="location.href='login.jsp?role=employee'">
            <h2>Employee</h2>
        </div>
        <div onclick="location.href='login.jsp?role=admin'">
            <h2>Admin</h2>
        </div>
    </div>
    <div class="login-form">
        <h2>Login</h2>
        <form action="login" method="post">
            <input type="hidden" name="role" value="${param.role}">
            <input type="text" name="username" placeholder="${param.role} ID" required>
            <input type="password" id="password" name="password" placeholder="Password" required>
            <span onclick="togglePassword()" style="cursor: pointer;">Show</span>
            <input type="submit" value="Login">
        </form>
        <div style="color: red;">
            ${errorMessage}
        </div>
    </div>
</body>
</html>
