<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="userDashboardStyle.css"> <!-- Separate CSS for user dashboard -->
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

    <!-- Main Content -->
    <div class="main-content">
        <% 
            // Get user ID and name from session
            Integer userId = (Integer) session.getAttribute("userId");
            String userName = "User";

            if (userId != null) {
                try (Connection conn = DBConnection.getConnection()) {
                    String query = "SELECT nom FROM utilisateurs WHERE ID = ?";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, userId);
                    ResultSet rs = pstmt.executeQuery();

                    if (rs.next()) {
                        userName = rs.getString("nom");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                response.sendRedirect("Login.jsp"); // Redirect to login if session is invalid
            }
        %>
        <h2>Welcome, <%= userName %>!</h2>
        <p>Discover the latest books added to our library.</p>

        <!-- Search Bar -->
        <form action="searchBooks.jsp" method="GET" class="search-bar">
            <input type="text" name="searchQuery" placeholder="Search by title, author, or category" required>
            <button type="submit">Search</button>
        </form>

        <!-- Latest Books -->
        <h3>Latest Added Books</h3>
        <div class="books-grid">
            <% 
                try (Connection conn = DBConnection.getConnection()) {
                    // Query to get the latest 9 books added
                    String query = "SELECT * FROM livres ORDER BY annee DESC LIMIT 9";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
            %>
            <div class="book-card">
                <h4><%= rs.getString("titre") %></h4>
                <p><%= rs.getString("resume").length() > 100 ? rs.getString("resume").substring(0, 100) + "..." : rs.getString("resume") %></p>
                <a href="viewBook.jsp?id=<%= rs.getInt("ID") %>" class="btn">View Details</a>
            </div>
            <% 
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</body>
</html>
