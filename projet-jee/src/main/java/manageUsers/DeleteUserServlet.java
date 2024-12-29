package manageUsers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import signupServlet.DBConnection;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("id");

        HttpSession session = request.getSession();
        Integer currentAdminId = (Integer) session.getAttribute("adminId");
        String currentAdminEmail = (String) session.getAttribute("adminEmail");

        if (currentAdminId == null || currentAdminEmail == null) {
            response.sendRedirect("manageUsers.jsp?error=notLoggedIn");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check if the user to be deleted is an admin
            String checkAdminQuery = "SELECT role FROM utilisateurs WHERE ID = ?";
            PreparedStatement checkAdminStmt = conn.prepareStatement(checkAdminQuery);
            checkAdminStmt.setInt(1, Integer.parseInt(userId));
            ResultSet checkAdminRs = checkAdminStmt.executeQuery();

            if (checkAdminRs.next()) {
                String roleToDelete = checkAdminRs.getString("role");

                // Only allow "mohamedghanmi011@gmail.com" to delete another admin
                if ("Admin".equals(roleToDelete) && !"mohamedghanmi011@gmail.com".equals(currentAdminEmail)) {
                    response.sendRedirect("manageUsers.jsp?error=onlyAdminDelete");
                    return;
                }
            }

            // Delete related records in `livres_empruntes` table
            String deleteLoansQuery = "DELETE FROM livres_empruntes WHERE user_ID = ?";
            PreparedStatement deleteLoansStmt = conn.prepareStatement(deleteLoansQuery);
            deleteLoansStmt.setInt(1, Integer.parseInt(userId));
            deleteLoansStmt.executeUpdate();

            // Delete related records in `favorites` table
            String deleteFavoritesQuery = "DELETE FROM favorites WHERE user_ID = ?";
            PreparedStatement deleteFavoritesStmt = conn.prepareStatement(deleteFavoritesQuery);
            deleteFavoritesStmt.setInt(1, Integer.parseInt(userId));
            deleteFavoritesStmt.executeUpdate();

            // Delete the user
            String deleteUserQuery = "DELETE FROM utilisateurs WHERE ID = ?";
            PreparedStatement deleteUserStmt = conn.prepareStatement(deleteUserQuery);
            deleteUserStmt.setInt(1, Integer.parseInt(userId));

            int rows = deleteUserStmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("manageUsers.jsp?success=userDeleted");
            } else {
                response.sendRedirect("manageUsers.jsp?error=userNotFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageUsers.jsp?error=exception&message=" + e.getMessage());
        }
    }
}
