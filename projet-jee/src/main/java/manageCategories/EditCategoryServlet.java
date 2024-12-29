package manageCategories;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import signupServlet.DBConnection;

@WebServlet("/EditCategoryServlet")
public class EditCategoryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryId = request.getParameter("id");
        String categoryName = request.getParameter("categoryName");

        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE categories SET nom = ? WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, categoryName);
            pstmt.setInt(2, Integer.parseInt(categoryId));

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("manageCategories.jsp");  // Redirect to manage categories page
            } else {
                response.getWriter().write("Error: Could not update category.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
