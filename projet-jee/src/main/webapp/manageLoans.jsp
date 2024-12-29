<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>
<%@ page import="java.sql.Date" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Loans</title>
    <link rel="stylesheet" href="manageLoansStyle.css"> <!-- Reuse admin styles -->
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
        <h2>Active Loans</h2>
        <table class="loans-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Book</th>
                    <th>Return Date</th>
                    <th>Time Left</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try (Connection conn = DBConnection.getConnection()) {
                        String query = "SELECT u.nom AS user_name, l.titre AS book_title, le.date_retour AS return_date " +
                                       "FROM livres_empruntes le " +
                                       "JOIN utilisateurs u ON le.user_ID = u.ID " +
                                       "JOIN livres l ON le.book_ID = l.ID";
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        ResultSet rs = pstmt.executeQuery();
                        while (rs.next()) {
                            Date returnDate = rs.getDate("return_date");
                            long timeLeft = returnDate.getTime() - System.currentTimeMillis();
                            long daysLeft = timeLeft / (1000 * 60 * 60 * 24); // Convert to days
                %>
                <tr>
                    <td><%= rs.getString("user_name") %></td>
                    <td><%= rs.getString("book_title") %></td>
                    <td><%= returnDate %></td>
                    <td><%= daysLeft > 0 ? daysLeft + " days left" : "Overdue" %></td>
                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<tr><td colspan='4'>Error loading loans.</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
