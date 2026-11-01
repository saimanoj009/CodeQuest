
package com.codequest.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin-logout")
public class AdminLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        // Get the existing admin session
        HttpSession session = request.getSession(false);

        // Invalidate the session
        if (session != null) {
            session.invalidate();
        }

        // Redirect to admin login page
        response.sendRedirect(
            request.getContextPath() + "/admin-login.jsp"
        );
    }
}
