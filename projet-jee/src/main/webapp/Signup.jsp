<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
    <link rel="stylesheet" href="loginStyle.css"> <!-- Shared login/signup styling -->
</head>
<body>
	 <div class="signup-container">
	    <h2>Sign Up</h2>
	    <form action="SignupServlet" method="post">
	        <input type="text" name="name" placeholder="Name" required><br>
	        <input type="email" name="email" placeholder="Email" required><br>
	        <input type="password" name="password" placeholder="Password" required><br>
	        <button type="submit">Sign Up</button>
	    </form>
	    <p class="login-link">Already have an account? <a href="Login.jsp">Log in here</a></p>
	
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
