package com.servlet;

import javax.servlet.http.*;

import java.io.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;

import java.sql.*;

@WebServlet("/user_result")
public class User_result extends HttpServlet{
	 private final String host = System.getenv("MYSQLHOST");
	 private final String port = System.getenv("MYSQLPORT");
	 private final String db   = System.getenv("MYSQLDATABASE");
	 private final String user_name = System.getenv("MYSQLUSER");
	 private final String password = System.getenv("MYSQLPASSWORD");
	 private final String url = "jdbc:mysql://" + host + ":" + port + "/" + db
			+ "?useSSL=false&allowPublicKeyRetrieval=true";
	public void doPost(HttpServletRequest req,HttpServletResponse res) throws ServletException, IOException {
		res.setContentType("text/html");
		PrintWriter out=res.getWriter();
		
		out.println("<!DOCTYPE html>");
		out.println("<html><head>");
		out.println("<link rel='stylesheet' href='styles.css'>"); // Use main stylesheet (styles.css)
		out.println("</head><body>");
			out.println("<header>");
			out.println("<img src='logo.png' alt='Logo' class='logo'>");
			out.println("<h1>Paul's Badminton Team</h1>");
			out.println("<nav>");
			out.println("<a href='index.html'>Home</a>");
			out.println("<a href='login.html'>Admin</a>");
			out.println("</nav>");
			out.println("</header>");
		
		int id=Integer.parseInt(req.getParameter("Id"));
		double hours=Double.parseDouble(req.getParameter("hours"));
		String date=req.getParameter("date");
		
		out.println("<div id='user-result-container'>"); // Add a unique ID for styling
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con=DriverManager.getConnection(url,user_name,password);
			
			
			String query="select * from daily_record where pid=? and date=?";
			
			PreparedStatement pst=con.prepareStatement(query);
			pst.setInt(1, id);
			pst.setString(2, date);

			ResultSet rs1=pst.executeQuery();

			
			if(rs1.next()) {
				out.println("<h1> You have already added for this date. You can not add again </h1>");
			}
			else {
				String query1="insert into daily_record(pid,date,played_hours) values(?,?,?)";
				PreparedStatement st=con.prepareStatement(query1);
				st.setInt(1, id);
				st.setString(2, date);
				st.setDouble(3, hours);
				st.executeUpdate();
				
				out.println("<h1>Record added</h1>");
				st.close();
				
			}
			    String query2 = "SELECT COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.amount ELSE 0 END),0) AS amount,\n" +
				    "COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.Total_hours ELSE 0 END),0) AS Total_hours,\n" +
				    "COALESCE(SUM(d.played_hours),0) AS played_hours\n" +
				    "FROM players p\n" +
				    "LEFT JOIN payments pay ON p.id = pay.pid\n" +
				    "LEFT JOIN daily_record d ON p.id = d.pid\n" +
				    "WHERE p.id = ?\n" +
				    "GROUP BY p.id";
			PreparedStatement st1 = con.prepareStatement(query2);
			st1.setInt(1, id);
			ResultSet rs = st1.executeQuery();
			int amount = 0;
			int total_hours = 0;
			double played_hours = 0.0;
			if(rs.next()){
				amount = rs.getInt(1);
				total_hours = rs.getInt(2);
				played_hours = rs.getDouble(3);
			}
			out.println("<h2>You paid: "+amount+ "</h2>");
			out.println("<h2>Opted Playing Hours: "+total_hours+ "</h2>");
			out.println("<h2>Consumed Hours: "+played_hours+"</h2>");
			out.println("<h2>Balance Hours: "+(total_hours-played_hours)+ "</h2>");
			
			pst.close();
			rs.close();
			rs1.close();
			con.close();
			st1.close();
		}
		catch(Exception e) {
			out.println("<h1>"+e+" resubmit</h1>");
		}

		out.println("</div>"); // Close the container div
		out.println("</body></html>");
	}
}
