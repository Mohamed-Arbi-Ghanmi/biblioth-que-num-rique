<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category</title>
	<link rel="stylesheet" href="manageCategoriesStyle.css">
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
        <h2>Edit Category</h2>
        <%
            String categoryId = request.getParameter("id");
            Connection conn = DBConnection.getConnection();
            String query = "SELECT * FROM categories WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(categoryId));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
        %>
        <form action="EditCategoryServlet" method="POST">
            <input type="hidden" name="id" value="<%= categoryId %>">

            <label for="categoryName">Category Name</label>
            <input type="text" id="categoryName" name="categoryName" value="<%= rs.getString("nom") %>" required><br><br>

            <button type="submit">Save Changes</button>
        </form>
        <% 
            } else { 
        %>
        <p>Category not found.</p>
        <% } %>
    </div>
</body>
</html>
