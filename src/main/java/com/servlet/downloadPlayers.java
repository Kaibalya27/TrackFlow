package com.servlet;
import java.io.*;

import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;

@WebServlet("/downloadPlayers")
public class downloadPlayers extends javax.servlet.http.HttpServlet {
    protected void doGet(javax.servlet.http.HttpServletRequest req, javax.servlet.http.HttpServletResponse res) throws javax.servlet.ServletException, java.io.IOException {
        // Your code to handle GET requests here
        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment; filename=\"players.csv\"");
        PrintWriter out = res.getWriter();
        // Write CSV header
        out.println("ID,Name,Phone,Amount,Opted Hours,Played Hours,Remaining Hours");
        // Your code to fetch player data and write to CSV
        database db;
        try {
            db = new database();
        
        ResultSet rs=db.viewPlayers();
        while(rs.next()){
            int id=rs.getInt(1);
            String playerName=rs.getString(2);
            String phone=rs.getString(3);
            int amount=rs.getInt(4);
            double total_hours=rs.getDouble(5);
            double played_hours=rs.getDouble(6);
            double remaining = total_hours - played_hours;
            // Write player data to CSV
            out.println(id + "," + playerName + "," + phone + "," + amount + "," + total_hours + "," + played_hours + "," + remaining);
        }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            out.println("<h1>"+e+"</h1>");
        }
    }
    
}
