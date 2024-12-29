<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Books by Author</title>
    <link rel="stylesheet" href="manageBooksStyle.css">
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
        <h2>Books Written by Author</h2>
        
        <% 
            String authorId = request.getParameter("authorId");
            Connection conn = null;

            try {
                conn = DBConnection.getConnection(); // Get DB connection
                // Fetch books by the selected author
                String query = "SELECT l.ID, l.titre, l.annee, l.format, l.resume FROM livres l " +
                               "JOIN livres_auteurs la ON l.ID = la.livre_ID " +
                               "WHERE la.auteur_ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(authorId));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
        %>
        <table class="books-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Year</th>
                    <th>Format</th>
                    <th>Summary</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Loop through the result set and display books
                    do {
                %>
                <tr>
                    <td><%= rs.getString("titre") %></td>
                    <td><%= rs.getInt("annee") %></td>
                    <td><%= rs.getString("format") %></td>
                    <td><%= rs.getString("resume") %></td>
                </tr>
                <% 
                    } while (rs.next());
                %>
            </tbody>
        </table>
        <% 
                } else {
                    out.println("<p>No books found for this author.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (conn != null) conn.close(); // Close connection
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
