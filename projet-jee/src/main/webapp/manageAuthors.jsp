<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Authors</title>
    <link rel="stylesheet" href="manageAuthorsStyle.css">
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
        <h2>Manage Authors</h2><br><br>
        <a href="addAuthor.jsp" class="btn">Add New Author</a>

        <table class="authors-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Date of Birth</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Fetch authors from the database
                    try (Connection conn = DBConnection.getConnection()) {
                        String query = "SELECT * FROM auteurs";
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("nom") %></td>
                    <td><%= rs.getDate("date_de_naissance") %></td>
                   <td>
					    <a href="editAuthor.jsp?id=<%= rs.getInt("ID") %>">Edit</a> | 
					    <a href="DeleteAuthorServlet?id=<%= rs.getInt("ID") %>" onclick="return confirm('Are you sure you want to delete this author?');">Delete</a> |
					    <a href="displayBooksByAuthor.jsp?authorId=<%= rs.getInt("ID") %>">View Books</a> <!-- Link to Display Books -->
					</td>


                </tr>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Error: Unable to fetch authors.</p>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
