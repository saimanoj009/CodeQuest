
package com.codequest.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public final class WebUtil {

    private WebUtil() {
    }

    // Escape HTML characters
    public static String esc(String value) {

        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }

    // Check student login
    public static boolean requireStudent(
            HttpServletRequest req,
            HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp"
            );

            return false;
        }

        return true;
    }

    // Check admin login
    public static boolean requireAdmin(
            HttpServletRequest req,
            HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/admin-login.jsp"
            );

            return false;
        }

        return true;
    }
}
