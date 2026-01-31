package com.servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/logout")
public class logout extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session=req.getSession();
        session.invalidate();
        res.sendRedirect("login.html");
    }
    
}
