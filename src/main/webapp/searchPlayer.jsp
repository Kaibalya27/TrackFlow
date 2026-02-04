<%@ page import="com.servlet.database" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Player Status</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body { margin: 10px; }
    </style>
</head>
<body>
<% 
    try {
        database db = new database();
        int playerId = Integer.parseInt(request.getParameter("Id"));
        ResultSet rs = db.searchPlayer(playerId);
        
        if(rs.next()){
            int id = rs.getInt(1);
            String playerName = rs.getString(2);
            String phone = rs.getString(3);
            int amount = rs.getInt(4);
            String lastDate = rs.getString(5);
            double total_hours = rs.getDouble(6);
            
            ResultSet rsPlayed = db.searchPlayerRecord(id);
            double consumed = 0;
            while(rsPlayed.next()){
                consumed += rsPlayed.getDouble(2);
            }
            double remaining = total_hours - consumed;
            boolean isAdmin = session.getAttribute("username") != null;
    %>
            <h2><%=playerName %>'s Details </h2>
            <div style="display:flex;flex-direction: row;justify-content: space-evenly;">
                <h3>ID: <%=id %></h3>
                <h3>Phone: <%=phone %></h3>
                <h3>Amount: <%=amount %></h3>
                <h3>Total Hours: <%=total_hours %></h3>
                <h3>Consumed: <%=consumed %></h3>
                <h3>Remaining: <%=remaining %></h3>
            </div>
            
            <% if(isAdmin) { %>
                <div style="text-align:center;margin:12px 0;">
                    <a class="btn" href="addTransaction.jsp?Id=<%=id%>" target="_top">Add Transaction</a>
                </div>
            <% } %>
            
            <div>
                <table>
                <tr>
                    <th>Date</th>
                    <th>Hours Played</th>
                </tr>
<%
            ResultSet rs1 = db.searchPlayerRecord(playerId);
            while(rs1.next()){
                String date = rs1.getString(1);
                double hours = rs1.getDouble(2);
%>
                <tr>
                    <td><%=date %></td>
                    <td><%=hours %></td>
                </tr>
<%
            }
%>
                </table>
            </div>
<%
        }
    } catch(Exception e) {
        out.println("<h3>Error loading player details: " + e.getMessage() + "</h3>");
    }
%>
</body>
</html>
