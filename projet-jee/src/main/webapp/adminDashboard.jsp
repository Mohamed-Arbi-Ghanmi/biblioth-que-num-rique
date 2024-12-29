<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="adminStyle.css"> <!-- Admin-specific CSS -->
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
                <li><a href="viewReports.jsp">View Reports</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <%
            // Retrieve the admin ID from the session
            Integer adminId = (Integer) session.getAttribute("userId");
            String adminName = "Admin";

            if (adminId != null) {
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT nom FROM utilisateurs WHERE ID = ?";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, adminId);
                    ResultSet rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        adminName = rs.getString("nom");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                // Redirect to login if the session is invalid
                response.sendRedirect("login.jsp");
            }
        %>
        <h2>Welcome, <%= adminName %>!</h2>
        <p>Manage the library resources from here.</p>

        <!-- Admin Dashboard Options Section -->
        <div class="dashboard-options">
            <div class="card">
                <h3>Manage Users</h3>
                <p>View, add, or edit users' roles and details.</p>
                <a href="manageUsers.jsp" class="btn">Go to Manage Users</a>
            </div>

            <div class="card">
                <h3>Manage Books</h3>
                <p>Add, update, or delete books in the library.</p>
                <a href="manageBooks.jsp" class="btn">Go to Manage Books</a>
            </div>

            <div class="card">
                <h3>Manage Categories</h3>
                <p>Add, update, or delete different categories.</p>
                <a href="manageCategories.jsp" class="btn">Go to Manage Categories</a>
            </div>

            <div class="card">
                <h3>Manage Authors</h3>
                <p>Add, edit, or delete authors in the library and view their books.</p>
                <a href="manageAuthors.jsp" class="btn">Go to Manage Authors</a>
            </div>

            <div class="card">
                <h3>Manage Loans</h3> <!-- New Manage Loans Card -->
                <p>View and manage active book loans.</p>
                <a href="manageLoans.jsp" class="btn">Go to Manage Loans</a>
            </div>

            <div class="card">
                <h3>View Reports</h3>
                <p>See library statistics and user activity.</p>
                <a href="viewReports.jsp" class="btn">View Reports</a>
            </div>
        </div>
    </div>
</body>
</html>
