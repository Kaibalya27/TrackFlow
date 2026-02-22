<%@ page import="com.servlet.database" %>
<%@ page import="java.sql.*" %>
<%
    // Check if we're in a standalone context or included in admin.jsp
    boolean isStandalone = request.getParameter("Id") != null && request.getAttribute("javax.servlet.include.request_uri") == null;
%>
<% if(isStandalone) { %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Player Status</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body { margin: 10px; }

        .box {
            display: flex;
            justify-content: center;
            margin-top: 15px;
        }

        table {
            border-collapse: collapse;
            min-width: 400px;   /* 👀 important */
             
        }

        th, td {
            padding: 8px 12px;
            border: 1px solid #ccc;
            text-align: center;
            width: 50%;
            min-width: 50px;
        }

        @media screen and (max-width: 600px) {

            .box {
                display: block;
                text-align: center;
                overflow-x: auto;
            }

            table {
                font-size: 14px;
                width: 50%;
                min-width: 100px;
                margin: 0 auto !important;
                display: inline-block;
            }
        }
    </style>
</head>
<body>
<% } %>
<% 
    try {
        // Always create our own database connection
        database dbConnection = new database();
        
        int playerId = Integer.parseInt(request.getParameter("Id"));
        ResultSet rs = dbConnection.searchPlayer(playerId);
        
        if(rs.next()){
            int id = rs.getInt(1);
            String playerName = rs.getString(2);
            String phone = rs.getString(3);
            int amount = rs.getInt(4);
            String lastDate = rs.getString(5);
            double total_hours = rs.getDouble(6);
            
            ResultSet rsPlayed = dbConnection.searchPlayerRecord(id);
            double consumed = 0;
            while(rsPlayed.next()){
                consumed += rsPlayed.getDouble(3);
            }
            double remaining = total_hours - consumed;
            boolean isAdmin = session.getAttribute("username") != null;
    %>
            <h2><%=playerName %>'s Details </h2>
            <div class="player-details-grid" style="display:flex;flex-direction: row;justify-content: space-evenly;flex-wrap: wrap;gap: 10px;">
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
            
            <div class="box">
                <table>
                <tr>
                    <th>Date</th>
                    <th>Hours Played</th>
                    <% if(isAdmin) { %>
                    <th>Action</th>
                    <% } %>
                </tr>
<%
            ResultSet rs1 = dbConnection.searchPlayerRecord(playerId);
            while(rs1.next()){
                int recordId = rs1.getInt(1); 
                String date = rs1.getString(2);
                double hours = rs1.getDouble(3);
%>
                <tr>
                    <td><%=date %></td>
                    <td><%=hours %></td>
                    <% if(isAdmin) { %>
                    <td><a href="editRecord.jsp?recordId=<%=recordId%>&Id=<%=playerId%>">Edit</a></td>
                    <% } %>
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
<% if(isStandalone) { %>
</body>
</html>
<% } %>
