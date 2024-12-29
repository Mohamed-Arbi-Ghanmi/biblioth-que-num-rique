<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="signupServlet.DBConnection" %>
<%@ page language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reports</title>
    <link rel="stylesheet" href="ViewReportsStyle.css"> <!-- CSS for styling -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> <!-- For charts -->
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
        <h2>Library Statistics</h2>

        <!-- Summary Cards -->
        <div class="summary-cards">
            <div class="card">
                <h3>Books Borrowed</h3>
                <p>
                    <%
                        int borrowedBooks = 0;
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT COUNT(*) AS total FROM livres_empruntes WHERE MONTH(date_retour) = MONTH(CURDATE())";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next()) {
                                borrowedBooks = rs.getInt("total");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        out.print(borrowedBooks);
                    %>
                </p>
            </div>
            <div class="card">
                <h3>Books Downloaded</h3>
                <p>
                    <%
                        int downloadedBooks = 0;
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT COUNT(*) AS total FROM downloads WHERE MONTH(download_date) = MONTH(CURDATE())";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next()) {
                                downloadedBooks = rs.getInt("total");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        out.print(downloadedBooks);
                    %>
                </p>
            </div>
            <div class="card">
                <h3>Books Added</h3>
                <p>
                    <%
                        int addedBooks = 0;
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT COUNT(*) AS total FROM livres WHERE MONTH(added_date) = MONTH(CURDATE())";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            if (rs.next()) {
                                addedBooks = rs.getInt("total");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        out.print(addedBooks);
                    %>
                </p>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-section">
            <h3>Monthly Trends</h3>
            <div class="chart-container">
                <canvas id="monthlyTrendsChart"></canvas>
            </div>
            <script>
                const ctx = document.getElementById('monthlyTrendsChart').getContext('2d');
                const monthlyTrendsChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], // Fixed 12 months
                        datasets: [
                            {
                                label: 'Books Borrowed',
                                data: [12, 15, 8, 10, 20, 25, 18, 30, 12, 22, 15, 10], // Ensure proper values
                                borderColor: 'rgba(75, 192, 192, 1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: false,
                            },
                            {
                                label: 'Books Downloaded',
                                data: [5, 10, 7, 8, 15, 20, 10, 25, 10, 15, 12, 8],
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: false,
                            },
                            {
                                label: 'Books Added',
                                data: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 2,
                                tension: 0.4,
                                fill: false,
                            },
                        ],
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: {
                                beginAtZero: true,
                            },
                            y: {
                                ticks: {
                                    stepSize: 5, // Prevent runaway scaling
                                },
                            },
                        },
                    },
                });
            </script>
        </div>

        <!-- Most Active Users Table -->
        <div class="data-table">
            <h3>Most Active Users</h3>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Books Borrowed</th>
                        <th>Books Downloaded</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection conn = DBConnection.getConnection()) {
                            String query = "SELECT u.nom, u.email, " +
                                           "(SELECT COUNT(*) FROM livres_empruntes le WHERE le.user_ID = u.ID) AS borrowed, " +
                                           "(SELECT COUNT(*) FROM downloads d WHERE d.user_ID = u.ID) AS downloaded " +
                                           "FROM utilisateurs u ORDER BY borrowed DESC, downloaded DESC LIMIT 5";
                            PreparedStatement stmt = conn.prepareStatement(query);
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getString("nom") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getInt("borrowed") %></td>
                        <td><%= rs.getInt("downloaded") %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
