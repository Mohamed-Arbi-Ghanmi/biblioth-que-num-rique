package manageUsers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import signupServlet.DBConnection;

@WebServlet("/EditUserServlet")
public class EditUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE utilisateurs SET nom = ?, email = ?, role = ? WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, role);
            pstmt.setInt(4, Integer.parseInt(userId));

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("manageUsers.jsp"); // Redirect to the Manage Users page
            } else {
                response.getWriter().write("Error: Could not update user.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
