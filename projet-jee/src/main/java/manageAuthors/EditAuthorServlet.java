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

@WebServlet("/EditAuthorServlet")
public class EditAuthorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String authorId = request.getParameter("id");
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");

        try (Connection conn = DBConnection.getConnection()) {
            // Update the author in the 'auteurs' table
            String query = "UPDATE auteurs SET nom = ?, date_de_naissance = ? WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, dob);
            pstmt.setInt(3, Integer.parseInt(authorId));

            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                // Redirect to manage authors page if successful
                response.sendRedirect("manageAuthors.jsp");
            } else {
                response.getWriter().write("Error: Could not update author.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
