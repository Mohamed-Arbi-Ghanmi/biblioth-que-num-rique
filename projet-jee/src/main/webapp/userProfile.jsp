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
    <title>User Profile</title>
    <link rel="stylesheet" href="userProfileStyle.css"> <!-- Separate CSS for user profile -->
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-container">
            <a href="userDashboard.jsp" class="navbar-brand">User Dashboard</a>
            <ul class="navbar-links">
                <li><a href="borrowedBooks.jsp">Borrowed Books</a></li>
                <li><a href="searchBooks.jsp">Search Books</a></li>
                <li><a href="userProfile.jsp">Profile</a></li>
                <li><a href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <h2>User Profile</h2>
        
        <!-- Profile Management Section -->
        <section class="profile-management">
            <h3>Manage Your Profile</h3>
            <form action="UpdateProfileServlet" method="POST">
                <% 
                    // Fetch the user's current details
                    session = request.getSession();
                    Integer userId = (Integer) session.getAttribute("userId");
                    if (userId == null) {
                        response.sendRedirect("login.jsp");
                    }
                    
                    try (Connection conn = DBConnection.getConnection()) {
                        String query = "SELECT nom, email FROM utilisateurs WHERE ID = ?";
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, userId);
                        ResultSet rs = pstmt.executeQuery();
                        if (rs.next()) {
                %>
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="<%= rs.getString("nom") %>" required>
                
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required>
                
                <label for="password">New Password:</label>
                <input type="password" id="password" name="password" placeholder="Leave blank to keep current password">
                
                <button type="submit">Update Profile</button>
               <% if ("success".equals(request.getParameter("status"))) { %>
				    <div id="statusMessage" class="notification success" style="display:block;">
				        Profile updated successfully!
				    </div>
				<% } else if ("error".equals(request.getParameter("status"))) { %>
				    <div id="statusMessage" class="notification error" style="display:block;">
				        Error updating profile. Please try again.
				    </div>
				<% } %>
					<script>
					    window.onload = function() {
					        var statusMessage = document.getElementById("statusMessage");
					        
					        if (statusMessage) {
					            setTimeout(function() {
					                statusMessage.style.display = "none";
					            }, 5000); // Hide after 5 seconds
					        }
					    };
					</script>
				
                
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </form>
        </section>

        <!-- Downloaded Books Section -->
		      <section class="books-list">
			    <h3>Downloaded Books</h3>
			    <table class="books-table">
			        <thead>
			            <tr>
			                <th>Title</th>
			                <th>Year</th>
			                <th>Format</th>
			                <th>Download Date</th>
			            </tr>
			        </thead>
			        <tbody>
			            <% 
			                try (Connection conn = DBConnection.getConnection()) {
			                    String downloadedQuery = "SELECT l.titre, l.annee, l.format, d.download_date " +
			                                             "FROM downloads d " +
			                                             "JOIN livres l ON d.book_ID = l.ID " +
			                                             "WHERE d.user_ID = ? " +
			                                             "ORDER BY d.download_date DESC";
			                    PreparedStatement downloadedStmt = conn.prepareStatement(downloadedQuery);
			                    downloadedStmt.setInt(1, userId);
			                    ResultSet downloadedBooks = downloadedStmt.executeQuery();
			                    while (downloadedBooks.next()) {
			            %>
			            <tr>
			                <td><%= downloadedBooks.getString("titre") %></td>
			                <td><%= downloadedBooks.getInt("annee") %></td>
			                <td><%= downloadedBooks.getString("format") %></td>
			                <td><%= downloadedBooks.getTimestamp("download_date") %></td>
			            </tr>
			            <% 
			                    }
			                } catch (Exception e) {
			                    e.printStackTrace();
			                    out.println("<tr><td colspan='4'>Error fetching downloaded books.</td></tr>");
			                }
			            %>
			        </tbody>
			    </table>
			</section>


        <!-- Borrowed Books Section -->
        <section class="books-list">
		    <h3>Borrowed Books</h3>
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
		            <%
		                try (Connection conn = DBConnection.getConnection()) {
		                    String borrowedQuery = "SELECT l.ID, l.titre, l.annee, l.format, le.date_retour " +
		                                           "FROM livres l " +
		                                           "JOIN livres_empruntes le ON l.ID = le.book_ID " +
		                                           "WHERE le.user_ID = ?";
		                    PreparedStatement borrowedStmt = conn.prepareStatement(borrowedQuery);
		                    borrowedStmt.setInt(1, userId);
		                    ResultSet borrowedBooks = borrowedStmt.executeQuery();
		
		                    if (!borrowedBooks.next()) {
		            %>
		                        <tr><td colspan="6">No borrowed books found.</td></tr>
		            <%
		                    } else {
		                        do {
		                            java.sql.Date returnDate = borrowedBooks.getDate("date_retour");
		                            long timeLeft = returnDate.getTime() - System.currentTimeMillis();
		                            long daysLeft = timeLeft / (1000 * 60 * 60 * 24);
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
		            <%
		                        } while (borrowedBooks.next());
		                    }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                    out.println("<tr><td colspan='6'>Error fetching borrowed books.</td></tr>");
		                }
		            %>
		        </tbody>
		    </table>
		</section>

    </div>
</body>
</html>
