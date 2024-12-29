<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <link rel="stylesheet" href="userDashboardStyle.css"> <!-- User Dashboard CSS -->
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-container">
            <a href="userDashboard.jsp" class="navbar-brand">User Dashboard</a>
            <ul class="navbar-links">
                <li><a href="BorrowedBooksServlet">Borrowed Books</a></li> <!-- Added Borrow Book -->
                <li><a href="searchBooks.jsp">Search Books</a></li>
                <li><a href="userProfile.jsp">Profile</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Search Bar -->
        <form action="searchBooks.jsp" method="GET" class="search-bar">
            <input type="text" name="searchQuery" placeholder="Search by title, author, or category" required>
            <button type="submit">Search</button>
        </form>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Search Results</h2>

        <% 
            String searchQuery = request.getParameter("searchQuery");
            try (Connection conn = DBConnection.getConnection()) {
                // SQL query to search by title, author, or category
                String query = "SELECT l.ID, l.titre, l.resume, l.annee, l.format, c.nom AS category_name, " +
                               "GROUP_CONCAT(a.nom SEPARATOR ', ') AS authors " +
                               "FROM livres l " +
                               "JOIN categories c ON l.categorie_ID = c.ID " +
                               "LEFT JOIN livres_auteurs la ON l.ID = la.livre_ID " +
                               "LEFT JOIN auteurs a ON la.auteur_ID = a.ID " +
                               "WHERE l.titre LIKE ? OR a.nom LIKE ? OR c.nom LIKE ? " +
                               "GROUP BY l.ID";
                
                PreparedStatement pstmt = conn.prepareStatement(query);
                String searchPattern = "%" + searchQuery + "%"; // Add wildcard for LIKE search
                pstmt.setString(1, searchPattern); // Search by title
                pstmt.setString(2, searchPattern); // Search by author
                pstmt.setString(3, searchPattern); // Search by category
                
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
        %>
        <div class="books-list">
            <% 
                // Loop through results and display them
                do {
            %>
            <div class="book-card">
                <h4><%= rs.getString("titre") %></h4>
                <p><strong>Author(s):</strong> <%= rs.getString("authors") %></p>
                <p><strong>Category:</strong> <%= rs.getString("category_name") %></p>
                <p><strong>Year:</strong> <%= rs.getInt("annee") %></p>
                <p><strong>Format:</strong> <%= rs.getString("format") %></p>
                <a href="viewBook.jsp?id=<%= rs.getInt("ID") %>">View Details</a>
            </div>
            <% 
                } while (rs.next());
            %>
        </div>
        <% 
                } else {
                    out.println("<p>No books found matching your search query.</p>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
