package borrowedBooks;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import signupServlet.DBConnection;

@WebServlet("/BorrowedBooksServlet")
public class BorrowedBooksServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user ID from the session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            // If the user is not logged in, redirect to the login page
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Query to fetch the borrowed books and return dates for the logged-in user
            String query = "SELECT l.ID, l.titre, l.annee, l.format, le.date_emprunt, le.date_retour " +
                           "FROM livres l " +
                           "JOIN livres_empruntes le ON l.ID = le.book_ID " +
                           "WHERE le.user_ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, userId); // Set the user ID in the query
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // If there are borrowed books, set the ResultSet as an attribute
                request.setAttribute("borrowedBooks", rs);
            } else {
                // If no borrowed books, set a flag to show a message in the JSP
                request.setAttribute("noBorrowedBooks", true);
            }

            // Forward the request to the borrowedBooks.jsp page
            request.getRequestDispatcher("borrowedBooks.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
