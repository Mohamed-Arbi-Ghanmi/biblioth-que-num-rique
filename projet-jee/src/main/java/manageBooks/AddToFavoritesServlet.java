package manageBooks;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import signupServlet.DBConnection;

@WebServlet("/AddToFavoritesServlet")
public class AddToFavoritesServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.getWriter().write("Error: User is not logged in!");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check if the book is already in favorites
            String checkQuery = "SELECT * FROM favorites WHERE user_ID = ? AND book_ID = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, Integer.parseInt(bookId));
            if (checkStmt.executeQuery().next()) {
                // Redirect with an error status
                response.sendRedirect("viewBook.jsp?id=" + bookId + "&status=alreadyInFavorites");
                return;
            }

            // Add the book to favorites
            String insertQuery = "INSERT INTO favorites (user_ID, book_ID) VALUES (?, ?)";
            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setInt(1, userId);
            insertStmt.setInt(2, Integer.parseInt(bookId));
            insertStmt.executeUpdate();

            // Redirect with a success status
            response.sendRedirect("viewBook.jsp?id=" + bookId + "&status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
