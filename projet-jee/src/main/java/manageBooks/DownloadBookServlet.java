package manageBooks;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import signupServlet.DBConnection;

@WebServlet("/DownloadBookServlet")
public class DownloadBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookId = request.getParameter("id");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch book file path
            String query = "SELECT file_path FROM livres WHERE ID = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(bookId));
            var rs = pstmt.executeQuery();

            if (rs.next()) {
                String filePath = rs.getString("file_path");
                File file = new File(filePath);

                if (!file.exists()) {
                    response.getWriter().write("Error: File not found.");
                    return;
                }

                // Log the download in the downloads table
                String logDownloadQuery = "INSERT INTO downloads (user_ID, book_ID) VALUES (?, ?)";
                PreparedStatement logStmt = conn.prepareStatement(logDownloadQuery);
                logStmt.setInt(1, userId);
                logStmt.setInt(2, Integer.parseInt(bookId));
                logStmt.executeUpdate();

                // Send the file to the user
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment;filename=" + file.getName());
                FileInputStream in = new FileInputStream(file);
                OutputStream out = response.getOutputStream();

                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }

                in.close();
                out.close();
            } else {
                response.getWriter().write("Error: Book not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
