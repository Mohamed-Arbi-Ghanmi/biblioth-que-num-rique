<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="loginStyle.css"> <!-- Add appropriate styling -->
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form action="LoginServlet" method="POST">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">Login</button>
        </form>

        <!-- Signup Link -->
        <div class="signup-link">
            <p>Don't have an account? <a href="Signup.jsp">Sign up here</a>.</p>
        </div>

        <!-- Notification Box -->
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
        <div id="errorMessage" class="notification error">
            <%= errorMessage %>
        </div>
        <% } %>
    </div>

    <script>
        // Hide the error message after 5 seconds
        window.onload = function() {
            const errorMessage = document.getElementById("errorMessage");
            if (errorMessage) {
                setTimeout(() => {
                    errorMessage.style.display = "none";
                }, 5000); // 5 seconds
            }
        };
    </script>
</body>
</html>
