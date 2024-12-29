<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link rel="stylesheet" href="manageUsersStyle.css">
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
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Edit User</h2>
        <%
            // Fetch user details by ID
            String userId = request.getParameter("id");
            Connection conn = DBConnection.getConnection();
            String query = "SELECT * FROM utilisateurs WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(userId));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
        %>
        <form action="EditUserServlet" method="POST">
            <input type="hidden" name="id" value="<%= userId %>">

            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= rs.getString("nom") %>" required><br>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required><br>

            <label for="role">Role</label>
            <select id="role" name="role" required>
                <option value="Client" <%= rs.getString("role").equals("Client") ? "selected" : "" %>>Client</option>
                <option value="Admin" <%= rs.getString("role").equals("Admin") ? "selected" : "" %>>Admin</option>
            </select><br><br>

            <button type="submit">Save Changes</button>
        </form>
        <% 
            } else { 
        %>
        <p>User not found.</p>
        <% } %>
    </div>
</body>
</html>
