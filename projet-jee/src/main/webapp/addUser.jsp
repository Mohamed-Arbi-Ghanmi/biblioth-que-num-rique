<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add User</title>
    <link rel="stylesheet" href="manageUsersStyle.css"> <!-- Specific CSS for Manage Books -->
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-container">
            <a href="adminDashboard.jsp" class="navbar-brand">Admin Dashboard</a>
            <ul class="navbar-links">
                <li><a href="manageUsers.jsp">Manage Users</a></li>
                <li><a href="manageBooks.jsp">Manage Books</a></li>
                <li><a href="manageCategories.jsp">Manage Categories</a></li>
                <li><a href="manageAuthors.jsp">Manage Authors</a></li>
                <li><a href="manageLoans.jsp">Manage Loans</a></li>
                <li><a href="viewReports.jsp" class="active">View Reports</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
    </nav>>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Add User</h2>
        <form action="AddUserServlet" method="POST">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" required><br>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" required><br>

            <label for="password">Password</label>
            <input type="password" id="password" name="password" required><br>

            <label for="role">Role</label>
            <select id="role" name="role" required>
                <option value="Client">Client</option>
                <option value="Admin">Admin</option>
            </select><br><br>

            <button type="submit">Add User</button>
        </form>
    </div>
</body>
</html>
