package manageUsers;

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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // If the user is not logged in, redirect to login page
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the form values
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Prepare the update query
            String updateQuery = "UPDATE utilisateurs SET nom = ?, email = ?";
            
            // Only add password to update query if it's not empty
            if (password != null && !password.isEmpty()) {
                updateQuery += ", mot_de_passe = ?";
            }
            updateQuery += " WHERE ID = ?";

            // Prepare the statement
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setString(1, name);
            pstmt.setString(2, email);

            // Set password if it's provided
            if (password != null && !password.isEmpty()) {
                pstmt.setString(3, password);
                pstmt.setInt(4, userId);
            } else {
                pstmt.setInt(3, userId);  // Skip password if not updating
            }

            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                response.sendRedirect("userProfile.jsp?status=success");
            } else {
                response.sendRedirect("userProfile.jsp?status=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userProfile.jsp?status=error");
        }
    }
}
