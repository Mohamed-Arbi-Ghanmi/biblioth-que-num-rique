<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Author</title>
    <link rel="stylesheet" href="manageAuthorsStyle.css">
</head>
<body>
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

    <div class="main-content">
        <h2>Edit Author</h2>
        <% 
            String authorId = request.getParameter("id");
            Connection conn = null;

            try {
                conn = DBConnection.getConnection(); // Get the DB connection
                String query = "SELECT * FROM auteurs WHERE ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(authorId));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
        %>
        <form action="EditAuthorServlet" method="POST">
            <input type="hidden" name="id" value="<%= rs.getInt("ID") %>">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" value="<%= rs.getString("nom") %>" required><br>

            <label for="dob">Date of Birth</label>
            <input type="date" id="dob" name="dob" value="<%= rs.getDate("date_de_naissance") %>" required><br>

            <button type="submit">Save Changes</button>
        </form>
        <% 
            }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("Error: " + e.getMessage());
            } finally {
                try {
                    if (conn != null) conn.close(); // Close the connection if opened
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
