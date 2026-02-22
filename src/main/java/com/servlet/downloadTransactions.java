package com.servlet;
import java.io.*;

import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;

@WebServlet("/downloadTransactions")
public class downloadTransactions extends javax.servlet.http.HttpServlet {
    protected void doGet(javax.servlet.http.HttpServletRequest req, javax.servlet.http.HttpServletResponse res) throws javax.servlet.ServletException, java.io.IOException {
        // Your code to handle GET requests here
        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment; filename=\"transactions.csv\"");
        PrintWriter out = res.getWriter();
        // Write CSV header
        out.println("Payment ID,Player ID,Name,Phone,Amount,Status,Mode,Total Hours,Date");
        // Your code to fetch player data and write to CSV
        database db;
        try {
            db = new database();
        
        ResultSet rs = db.viewTransactions();
        while(rs.next()){
            int paymentId = rs.getInt(1);
            int playerId = rs.getInt(2);
            String playerName = rs.getString(3);
            String phone = rs.getString(4);
            int amount = rs.getInt(5);
            String status = rs.getString(6);
            String mode = rs.getString(7);
            String totalHours = rs.getString(8);
            String date = rs.getString(9);
            // Write player data to CSV
            out.println(paymentId + "," + playerId + "," + playerName + "," + phone + "," + amount + "," + status + "," + mode + "," + totalHours + "," + date);
        }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            out.println("<h1>"+e+"</h1>");
        }
    }
    
}
