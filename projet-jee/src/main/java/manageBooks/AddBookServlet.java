package manageBooks;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement; // Import this
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import signupServlet.DBConnection;

@WebServlet("/AddBookServlet")
@MultipartConfig // Enables file upload handling
public class AddBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String[] authors = request.getParameterValues("authors"); // Handle multiple authors
        int year = Integer.parseInt(request.getParameter("year"));
        String format = request.getParameter("format");
        String resume = request.getParameter("resume");

        // Handle file upload
        Part filePart = request.getPart("file"); // File input field name
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = "/home/mohamed/Bureau/Books" + fileName; // Adjust the path

        try (Connection conn = DBConnection.getConnection()) {
            // Save the file to the server
            File file = new File(uploadPath);
            filePart.write(file.getAbsolutePath());

            // Insert book into `livres` table
            String bookQuery = "INSERT INTO livres (titre, categorie_ID, annee, format, resume, file_path) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement bookStmt = conn.prepareStatement(bookQuery, Statement.RETURN_GENERATED_KEYS);
            bookStmt.setString(1, title);
            bookStmt.setInt(2, Integer.parseInt(category));
            bookStmt.setInt(3, year);
            bookStmt.setString(4, format);
            bookStmt.setString(5, resume);
            bookStmt.setString(6, uploadPath); // Add file path to the query
            bookStmt.executeUpdate();

            // Get the generated book ID
            ResultSet bookRs = bookStmt.getGeneratedKeys();
            if (bookRs.next()) {
                int bookId = bookRs.getInt(1);

                // Insert authors into `livres_auteurs` table
                String authorQuery = "INSERT INTO livres_auteurs (livre_ID, auteur_ID) VALUES (?, ?)";
                PreparedStatement authorStmt = conn.prepareStatement(authorQuery);
                for (String authorId : authors) {
                    authorStmt.setInt(1, bookId);
                    authorStmt.setInt(2, Integer.parseInt(authorId));
                    authorStmt.executeUpdate();
                }
            }

            response.sendRedirect("manageBooks.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
