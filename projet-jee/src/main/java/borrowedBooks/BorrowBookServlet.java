package borrowedBooks;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import signupServlet.DBConnection;

@WebServlet("/BorrowBookServlet")
public class BorrowBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("bookId");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Set borrow duration (e.g., 14 days)
            long borrowDurationMillis = 1000 * 60 * 60 * 24 * 14; // 14 days
            long borrowDateMillis = System.currentTimeMillis();
            long returnDateMillis = borrowDateMillis + borrowDurationMillis;

            Date borrowDate = new Date(borrowDateMillis);
            Date returnDate = new Date(returnDateMillis);

            // Insert into `livres_empruntes`
            String insertQuery = "INSERT INTO livres_empruntes (user_ID, book_ID, date_emprunt, date_retour) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(insertQuery);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, Integer.parseInt(bookId));
            pstmt.setDate(3, borrowDate);
            pstmt.setDate(4, returnDate);
            pstmt.executeUpdate();

            // Redirect to view the book details page with a success message
            response.sendRedirect("viewBook.jsp?id=" + bookId + "&status=borrowed");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
