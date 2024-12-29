package manageAuthors;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import signupServlet.DBConnection;

@WebServlet("/DeleteAuthorServlet")
public class DeleteAuthorServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String authorId = request.getParameter("id");

        try (Connection conn = DBConnection.getConnection()) {
            // Delete the author from the 'auteurs' table
            String query = "DELETE FROM auteurs WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(authorId));
            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                // Redirect to manage authors page if successful
                response.sendRedirect("manageAuthors.jsp");
            } else {
                response.getWriter().write("Error: Could not delete author.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
