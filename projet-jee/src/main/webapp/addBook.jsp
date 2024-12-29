<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Book</title>
    <link rel="stylesheet" href="adminStyle.css">
    <link rel="stylesheet" href="manageBooksStyle.css"> <!-- Specific CSS for Manage Books -->
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
        <h2>Add New Book</h2>
		   <form action="AddBookServlet" method="POST" enctype="multipart/form-data">
			    <label for="title">Title</label>
			    <input type="text" id="title" name="title" required><br>
			
			    <label for="category">Category</label>
			    <select id="category" name="category" required>
			        <% 
			            Connection conn = DBConnection.getConnection();
			            String categoryQuery = "SELECT * FROM categories";
			            PreparedStatement categoryStmt = conn.prepareStatement(categoryQuery);
			            ResultSet categoryRs = categoryStmt.executeQuery();
			
			            while (categoryRs.next()) {
			        %>
			        <option value="<%= categoryRs.getInt("ID") %>"><%= categoryRs.getString("nom") %></option>
			        <% } %>
			    </select><br>
			
			   <label for="authors">Authors</label>
					<select id="authors" name="authors" multiple required style="height: 150px; width: 100%;">
					    <% 
					        // Fetch authors from the database
					        String authorQuery = "SELECT * FROM auteurs";
					        PreparedStatement authorStmt = conn.prepareStatement(authorQuery);
					        ResultSet authorRs = authorStmt.executeQuery();
					
					        while (authorRs.next()) {
					    %>
					    <option value="<%= authorRs.getInt("ID") %>"><%= authorRs.getString("nom") %></option>
					    <% } %>
					</select><br>
			
			    <label for="year">Year</label>
			    <input type="number" id="year" name="year" required><br>
			
			    <label for="format">Format</label>
			    <select id="format" name="format" required>
			        <option value="PDF">PDF</option>
			        <option value="EPUB">EPUB</option>
			    </select><br>
			     <label for="file">Book File</label>
    			<input type="file" id="file" name="file" required><br><br>
    
			
			    <label for="resume">Summary</label>
			    <textarea id="resume" name="resume" rows="5" required></textarea><br><br>
				
			    <button type="submit">Add Book</button>
			</form>


    </div>
</body>
</html>
