<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Book</title>
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
        <h2>Edit Book</h2>
        <%
            String bookId = request.getParameter("id");
            Connection conn = DBConnection.getConnection();

            // Fetch book details
            String bookQuery = "SELECT * FROM livres WHERE ID = ?";
            PreparedStatement bookStmt = conn.prepareStatement(bookQuery);
            bookStmt.setInt(1, Integer.parseInt(bookId));
            ResultSet bookRs = bookStmt.executeQuery();

            // Fetch book's authors
            String authorsQuery = "SELECT auteur_ID FROM livres_auteurs WHERE livre_ID = ?";
            PreparedStatement authorsStmt = conn.prepareStatement(authorsQuery);
            authorsStmt.setInt(1, Integer.parseInt(bookId));
            ResultSet authorsRs = authorsStmt.executeQuery();

            // Collect author IDs
            java.util.Set<Integer> selectedAuthors = new java.util.HashSet<>();
            while (authorsRs.next()) {
                selectedAuthors.add(authorsRs.getInt("auteur_ID"));
            }

            if (bookRs.next()) {
        %>
		<form action="EditBookServlet" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= bookId %>">

            <label for="title">Title</label>
            <input type="text" id="title" name="title" value="<%= bookRs.getString("titre") %>" required><br>

            <label for="category">Category</label>
            <select id="category" name="category" required>
                <% 
                    String categoryQuery = "SELECT * FROM categories";
                    PreparedStatement categoryStmt = conn.prepareStatement(categoryQuery);
                    ResultSet categoryRs = categoryStmt.executeQuery();

                    while (categoryRs.next()) {
                        int categoryId = categoryRs.getInt("ID");
                        String selected = (categoryId == bookRs.getInt("categorie_ID")) ? "selected" : "";
                %>
                <option value="<%= categoryId %>" <%= selected %>><%= categoryRs.getString("nom") %></option>
                <% } %>
            </select><br>

            <label for="authors">Authors</label>
            <select id="authors" name="authors" multiple required>
                <% 
                    String allAuthorsQuery = "SELECT * FROM auteurs";
                    PreparedStatement allAuthorsStmt = conn.prepareStatement(allAuthorsQuery);
                    ResultSet allAuthorsRs = allAuthorsStmt.executeQuery();

                    while (allAuthorsRs.next()) {
                        int authorId = allAuthorsRs.getInt("ID");
                        String authorSelected = selectedAuthors.contains(authorId) ? "selected" : "";
                %>
                <option value="<%= authorId %>" <%= authorSelected %>><%= allAuthorsRs.getString("nom") %></option>
                <% } %>
            </select><br>

            <label for="year">Year</label>
            <input type="number" id="year" name="year" value="<%= bookRs.getInt("annee") %>" required><br>

            <label for="format">Format</label>
            <select id="format" name="format" required>
                <option value="PDF" <%= "PDF".equals(bookRs.getString("format")) ? "selected" : "" %>>PDF</option>
                <option value="EPUB" <%= "EPUB".equals(bookRs.getString("format")) ? "selected" : "" %>>EPUB</option>
            </select><br>	
            <label for="file">Upload New File (Optional)</label>
    		<input type="file" id="file" name="file"><br><br>


            <label for="resume">Summary</label>
            <textarea id="resume" name="resume" rows="5" required><%= bookRs.getString("resume") %></textarea><br><br>

            <button type="submit">Save Changes</button>
        </form>
        <% 
            } else { 
        %>
        <p>Book not found.</p>
        <% } %>
    </div>
</body>
</html>
