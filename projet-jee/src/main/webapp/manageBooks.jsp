<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Books</title>
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
        <h2>Manage Books</h2><br><br>
        <a href="addBook.jsp" class="btn">Add New Book</a>

        <!-- Books Table -->
        <table class="books-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Authors</th>
                    <th>Year</th>
                    <th>Format</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Connection conn = DBConnection.getConnection();
                        // Fetch books with category and authors
						String query = 
						    "SELECT l.ID, l.titre, l.annee, l.format, c.nom AS categorie, " +
						    "GROUP_CONCAT(a.nom SEPARATOR ', ') AS auteurs " +
						    "FROM livres l " +
						    "JOIN categories c ON l.categorie_ID = c.ID " +
						    "LEFT JOIN livres_auteurs la ON l.ID = la.livre_ID " +
						    "LEFT JOIN auteurs a ON la.auteur_ID = a.ID " +
						    "GROUP BY l.ID, l.titre, l.annee, l.format, c.nom";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("titre") %></td>
                    <td><%= rs.getString("categorie") %></td>
                    <td><%= rs.getString("auteurs") %></td>
                    <td><%= rs.getInt("annee") %></td>
                    <td><%= rs.getString("format") %></td>
                    <td>
                        <a href="editBook.jsp?id=<%= rs.getInt("ID") %>">Edit</a> | 
                        <a href="DeleteBookServlet?id=<%= rs.getInt("ID") %>" onclick="return confirm('Are you sure you want to delete this book?');">Delete</a>
                    </td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
