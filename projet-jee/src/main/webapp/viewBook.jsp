<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>
<%@ page import="java.sql.Date" %> <!-- Import the Date class -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Details</title>
    <link rel="stylesheet" href="ViewBookStyle.css"> <!-- Separate CSS for book details -->
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
        <% 
            String bookId = request.getParameter("id");
            try (Connection conn = DBConnection.getConnection()) {
                // Query to get book details by ID
                String query = "SELECT * FROM livres WHERE ID = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, Integer.parseInt(bookId));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
        %>
        <div class="book-details">
            <h2><%= rs.getString("titre") %></h2>
            <p><strong>Author(s):</strong> 
                <% 
                    // Get authors associated with the book
                    String authorQuery = "SELECT a.nom FROM auteurs a JOIN livres_auteurs la ON a.ID = la.auteur_ID WHERE la.livre_ID = ?";
                    PreparedStatement authorStmt = conn.prepareStatement(authorQuery);
                    authorStmt.setInt(1, rs.getInt("ID"));
                    ResultSet authorRs = authorStmt.executeQuery();
                    while (authorRs.next()) {
                        out.print(authorRs.getString("nom") + " ");
                    }
                %>
            </p>
            <p><strong>Summary:</strong> <%= rs.getString("resume") %></p>
            <p><strong>Year:</strong> <%= rs.getInt("annee") %></p>
            <p><strong>Format:</strong> <%= rs.getString("format") %></p>
            
            <% 
                // Get the session object
                session = request.getSession();
                Integer userId = (Integer) session.getAttribute("userId");
                boolean isBorrowed = false;
                String timeLeftMessage = "";

                if (userId != null) {
                    // Check if the book is already borrowed by the user
                    String checkQuery = "SELECT * FROM livres_empruntes WHERE user_ID = ? AND book_ID = ?";
                    PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                    checkStmt.setInt(1, userId);
                    checkStmt.setInt(2, Integer.parseInt(bookId));
                    ResultSet borrowedRs = checkStmt.executeQuery();

                    if (borrowedRs.next()) {
                        // Book is borrowed, display return date and time left
                        isBorrowed = true;
                        Date returnDate = borrowedRs.getDate("date_retour");
                        long timeLeft = returnDate.getTime() - System.currentTimeMillis();
                        long daysLeft = timeLeft / (1000 * 60 * 60 * 24); // Convert milliseconds to days
                        timeLeftMessage = (daysLeft > 0 ? daysLeft + " days left" : "Overdue");
                    }
                } else {
                    response.sendRedirect("login.jsp");
                }
            %>
	
			<% if (isBorrowed) { %>
                <!-- If the book is borrowed, show the return date and remaining time -->
                <p><strong>Return Date:</strong> <%= timeLeftMessage %></p>
	             <form action="AddToFavoritesServlet" method="POST">
		                <input type="hidden" name="bookId" value="<%= rs.getInt("ID") %>">
		                <button type="submit">Add to Favorites</button>
		          		<a href="DownloadBookServlet?id=<%= rs.getInt("ID") %>" class="download">Download</a>
		          </form>
            <% } else { %>
                <!-- If the book is not borrowed, show the borrow button and disable the download button -->
                <p><strong>Return Date:</strong> Not borrowed yet</p>
                <form action="BorrowBookServlet" method="POST">
                    <input type="hidden" name="bookId" value="<%= rs.getInt("ID") %>">
                    <button type="submit" class="btn">Borrow Book</button>
                </form><br>
                 <form action="AddToFavoritesServlet" method="POST">
	                <input type="hidden" name="bookId" value="<%= rs.getInt("ID") %>">
	                <button type="submit">Add to Favorites</button>
	          	</form>
            <% } %>
            <br>
            
			  <%-- Notification box for success or error message --%>
			<% if ("success".equals(request.getParameter("status"))) { %>
			    <div id="successMessage" class="notification success">
			        Book added to favorites successfully!
			    </div>
			<% } else if ("alreadyInFavorites".equals(request.getParameter("status"))) { %>
			    <div id="errorMessage" class="notification error">
			        Book is already in your favorites!
			    </div>
			<% } %>
			
			<!-- Your other page content here -->
			<script>
			    // Check if the success or error message exists
			    window.onload = function() {
			        var successMessage = document.getElementById("successMessage");
			        var errorMessage = document.getElementById("errorMessage");
			
			        if (successMessage) {
			            successMessage.style.display = "block";
			            setTimeout(function() {
			                successMessage.style.display = "none";
			            }, 5000); // 5 seconds
			        }
			
			        if (errorMessage) {
			            errorMessage.style.display = "block";
			            setTimeout(function() {
			                errorMessage.style.display = "none";
			            }, 5000); // 5 seconds
			        }
			    }
			</script>
            
            
            
        </div>
        <% 
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
