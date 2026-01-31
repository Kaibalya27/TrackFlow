package com.servlet;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/verify")
public class verify extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Map<String, String> users = new HashMap<>();
        users.put(
            "Kaibalya",
            "$2a$10$emTftJXDNaV4p3/PV11aXO1LdoQxn5Fse5JfxeoBS/kGY7jM4nzjW"
        );

        users.put(
            "NKS",
            "$2a$10$emTftJXDNaV4p3/PV11aXO1LdoQxn5Fse5JfxeoBS/kGY7jM4nzjW"
        );
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        String storedHash = users.get(username);

        if (storedHash != null && BCrypt.checkpw(password, storedHash)) {

            
            HttpSession session = req.getSession();
            session.setAttribute("username", username);
            res.sendRedirect("admin.jsp");

        } else {
            res.setContentType("text/html");
            PrintWriter out = res.getWriter();
            out.println("<h2 style='color:red'>Invalid Credentials</h2>");
            RequestDispatcher rd = req.getRequestDispatcher("login.html");
            rd.include(req, res);
        }
        
    }
}
