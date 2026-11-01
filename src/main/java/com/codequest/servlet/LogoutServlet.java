
package com.codequest.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        // Get existing student session
        HttpSession session = request.getSession(false);

        // Destroy session
        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
    }
}
