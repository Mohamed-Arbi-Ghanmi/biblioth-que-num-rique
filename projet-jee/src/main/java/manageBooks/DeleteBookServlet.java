package manageBooks;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import signupServlet.DBConnection;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("id");

        try (Connection conn = DBConnection.getConnection()) {
            // Step 1: Remove associations from livres_auteurs
            String deleteAssociationsQuery = "DELETE FROM livres_auteurs WHERE livre_ID = ?";
            PreparedStatement deleteAssociationsStmt = conn.prepareStatement(deleteAssociationsQuery);
            deleteAssociationsStmt.setInt(1, Integer.parseInt(bookId));
            deleteAssociationsStmt.executeUpdate();

            // Step 2: Delete the book from livres
            String deleteBookQuery = "DELETE FROM livres WHERE ID = ?";
            PreparedStatement deleteBookStmt = conn.prepareStatement(deleteBookQuery);
            deleteBookStmt.setInt(1, Integer.parseInt(bookId));
            int rows = deleteBookStmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("manageBooks.jsp"); // Redirect to Manage Books page
            } else {
                response.getWriter().write("Error: Book not found or could not be deleted.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
