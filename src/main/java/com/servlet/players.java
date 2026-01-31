package com.servlet;
import java.sql.*;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;


public class players extends HttpServlet{
	 private final String host = System.getenv("MYSQLHOST");
	 private final String port = System.getenv("MYSQLPORT");
	 private final String db   = System.getenv("MYSQLDATABASE");
	 private final String user_name = System.getenv("MYSQLUSER");
	 private final String password = System.getenv("MYSQLPASSWORD");
	 private final String url = "jdbc:mysql://" + host + ":" + port + "/" + db
			+ "?useSSL=false&allowPublicKeyRetrieval=true";
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
        res.setContentType("application/json");
        PrintWriter out=res.getWriter();
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	Connection con=DriverManager.getConnection(url,user_name,password);
        	Statement st=con.createStatement();
        	String query="select id,name,phone_no from players";
        	ResultSet rs=st.executeQuery(query);
        	StringBuilder str=new StringBuilder();
        	boolean f=false;
        	str.append('[');
        	while(rs.next()) {
        		if(f) {
        			str.append(',');
        		}
        		f=true;
                int id=rs.getInt(1);
        		String name=rs.getString(2);
        		String phone=rs.getString(3);
        		str.append("{ \"id\":");
                str.append(id);
                str.append(",\"name\" : \"");
        		str.append(name);
        		str.append("\",\"phone\" : \"");
        		str.append(phone);
        		str.append("\"}");
        	}
        	str.append(']');
        	rs.close();
        	st.close();
        	con.close();
        	out.print(str.toString());
        }
        catch(Exception e) {
        	out.print("{\"error\" : \""+e.getMessage()+"\"}");
        }
        
        
        
    };

}
