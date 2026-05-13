package com.ecommerce.control;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "LogoutControl", value = "/logout")
public class LogoutControl extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Expire all cookies (including remember-me)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                cookie.setValue("");
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
            }
        }

        // Fully invalidate the session so all attributes are cleared server-side
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/");
    }
}
