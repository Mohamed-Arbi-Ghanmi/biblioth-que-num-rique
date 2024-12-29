package manageBooks;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import signupServlet.DBConnection;

@WebServlet("/EditBookServlet")
@MultipartConfig // Enables file upload handling
public class EditBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("id");
        String title = request.getParameter("title");
        String[] authors = request.getParameterValues("authors"); // Handle multiple authors
        String categoryIdStr = request.getParameter("category");
        int year = Integer.parseInt(request.getParameter("year"));
        String format = request.getParameter("format");
        String resume = request.getParameter("resume");

        // Handle file upload
        Part filePart = request.getPart("file"); // File input field name
        String fileName = null;
        String uploadPath = null;

        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            uploadPath = "/home/mohamed/Bureau/Books" + fileName; // Update the path as per your server
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Validate category ID
            if (categoryIdStr == null || categoryIdStr.isEmpty()) {
                response.getWriter().write("Error: Category not selected.");
                return;
            }

            int categoryId = Integer.parseInt(categoryIdStr);

            // Update the book details in `livres`
            StringBuilder updateQuery = new StringBuilder(
                "UPDATE livres SET titre = ?, categorie_ID = ?, annee = ?, format = ?, resume = ?"
            );
            if (uploadPath != null) {
                updateQuery.append(", file_path = ?");
            }
            updateQuery.append(" WHERE ID = ?");

            PreparedStatement pstmt = conn.prepareStatement(updateQuery.toString());
            pstmt.setString(1, title);
            pstmt.setInt(2, categoryId);
            pstmt.setInt(3, year);
            pstmt.setString(4, format);
            pstmt.setString(5, resume);

            int parameterIndex = 6;
            if (uploadPath != null) {
                pstmt.setString(parameterIndex++, uploadPath);

                // Save the uploaded file to the server
                File file = new File(uploadPath);
                filePart.write(file.getAbsolutePath());
            }
            pstmt.setInt(parameterIndex, Integer.parseInt(bookId));

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                // Step 1: Remove old associations from `livres_auteurs`
                String deleteOldAuthorsQuery = "DELETE FROM livres_auteurs WHERE livre_ID = ?";
                PreparedStatement deleteOldAuthorsStmt = conn.prepareStatement(deleteOldAuthorsQuery);
                deleteOldAuthorsStmt.setInt(1, Integer.parseInt(bookId));
                deleteOldAuthorsStmt.executeUpdate();

                // Step 2: Insert new author associations into `livres_auteurs`
                if (authors != null) {
                    String insertAuthorsQuery = "INSERT INTO livres_auteurs (livre_ID, auteur_ID) VALUES (?, ?)";
                    PreparedStatement insertAuthorsStmt = conn.prepareStatement(insertAuthorsQuery);
                    for (String authorId : authors) {
                        insertAuthorsStmt.setInt(1, Integer.parseInt(bookId));
                        insertAuthorsStmt.setInt(2, Integer.parseInt(authorId));
                        insertAuthorsStmt.executeUpdate();
                    }
                }

                // Redirect after updating the book
                response.sendRedirect("manageBooks.jsp");
            } else {
                response.getWriter().write("Error: Could not update book.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
