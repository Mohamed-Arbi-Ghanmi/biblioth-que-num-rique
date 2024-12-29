<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Date" %>
<%@ page import="signupServlet.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Borrowed Books</title>
    <link rel="stylesheet" href="userDashboardStyle.css"> <!-- Same CSS as userDashboard -->
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-container">
            <a href="userDashboard.jsp" class="navbar-brand">User Dashboard</a>
            <ul class="navbar-links">
                <li><a href="BorrowedBooksServlet">Borrowed Books</a></li>
                <li><a href="searchBooks.jsp">Search Books</a></li>
                <li><a href="userProfile.jsp">Profile</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <h2>Your Borrowed Books</h2>

        <% 
            // Check if there are no borrowed books
            Boolean noBorrowedBooks = (Boolean) request.getAttribute("noBorrowedBooks");
            if (noBorrowedBooks != null && noBorrowedBooks) {
        %>
            <p>You have not borrowed any books yet.</p>
        <% 
            } else {
                // Get the borrowed books from the request
                ResultSet borrowedBooks = (ResultSet) request.getAttribute("borrowedBooks");
                if (borrowedBooks != null) {
        %>
        <table class="books-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Year</th>
                    <th>Format</th>
                    <th>Return Date</th>
                    <th>Time Left</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% while (borrowedBooks.next()) { 
                    Date returnDate = borrowedBooks.getDate("date_retour");
                    long timeLeft = returnDate.getTime() - System.currentTimeMillis(); // Time left in milliseconds
                    long daysLeft = timeLeft / (1000 * 60 * 60 * 24); // Convert milliseconds to days
                %>
                <tr>
                    <td><%= borrowedBooks.getString("titre") %></td>
                    <td><%= borrowedBooks.getInt("annee") %></td>
                    <td><%= borrowedBooks.getString("format") %></td>
                    <td><%= returnDate %></td>
                    <td><%= daysLeft > 0 ? daysLeft + " days left" : "Overdue" %></td>
                    <td>
                        <a href="viewBook.jsp?id=<%= borrowedBooks.getInt("ID") %>" class="btn">View Details</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% 
                } else {
                    out.println("<p>No borrowed books to display.</p>");
                }
            }
        %>
    </div>

</body>
</html>
