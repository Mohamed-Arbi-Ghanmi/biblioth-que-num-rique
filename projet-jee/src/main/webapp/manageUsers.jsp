<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users</title>
    <link rel="stylesheet" href="manageUsersStyle.css"> <!-- Admin specific CSS -->
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
        <h2>Manage Users</h2>
        <p>Here you can view, add, edit, or delete users.</p>

        <!-- Add User Button -->
        <a href="addUser.jsp" class="btn">Add New User</a>

        <!-- Users Table -->
        <table class="user-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <!-- Loop through users and display their data -->
                <% 
                    // Fetch users from the database and display them here
                    Connection conn = DBConnection.getConnection();
                    String query = "SELECT * FROM utilisateurs";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nom") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("role") %></td>
					<td>
					    <a href="editUser.jsp?id=<%= rs.getInt("ID") %>">Edit</a> |
					    <a href="DeleteUserServlet?id=<%= rs.getInt("ID") %>" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
					</td>
					
                </tr>
                <% } %>
            </tbody>
        </table>
        <% 
		    String error = request.getParameter("error");
		    if ("onlyAdminDelete".equals(error)) {
		%>
		    <div id="errorNotification" class="notification error">
		        Only 'mohamedghanmi011@gmail.com' can delete another admin.
		    </div>
		<% 
		    } 
		%>
		<script>
		    document.addEventListener("DOMContentLoaded", function () {
		        var notification = document.getElementById("errorNotification");
		        if (notification) {
		            setTimeout(function () {
		                notification.style.display = "none";
		            }, 5000); // 5 seconds
		        }
		    });
		</script>
        
    </div>
</body>
</html>
