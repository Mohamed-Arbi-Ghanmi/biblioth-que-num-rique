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

@WebServlet("/AddAuthorServlet")
public class AddAuthorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");

        try (Connection conn = DBConnection.getConnection()) {
            // Insert the new author into the 'auteurs' table
            String query = "INSERT INTO auteurs (nom, date_de_naissance) VALUES (?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, dob);

            int rows = pstmt.executeUpdate();
            
            if (rows > 0) {
                // Redirect to manage authors page if successful
                response.sendRedirect("manageAuthors.jsp");
            } else {
                response.getWriter().write("Error: Could not add author.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
