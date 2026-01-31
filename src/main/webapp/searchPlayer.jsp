<% 
    ResultSet rs=db.searchPlayer(Integer.parseInt(request.getParameter("Id")));
    if(rs.next()){
        int id=rs.getInt(1);
        String playerName=rs.getString(2);
        String phone=rs.getString(3);
        int amount=rs.getInt(4);
        String lastDate=rs.getString(5);
        int total_hours=rs.getInt(6);
        int played_hours=0; // will fetch below if needed
        // compute consumed and remaining from daily_record
        ResultSet rsPlayed = db.searchPlayerRecord(id);
        int consumed = 0;
        while(rsPlayed.next()){
            consumed += rsPlayed.getInt(2);
        }
        int remaining = total_hours - consumed;
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
            <div style="text-align:center;margin:12px 0;">
                <a class="btn" href="addTransaction.jsp?Id=<%=id%>">Add Transaction</a>
            </div>
    <%
    }
%>
        <div>
            <table>
            <tr>
                <th>Date</th>
                <th>Hours Played</th>
            </tr>
<%
    ResultSet rs1=db.searchPlayerRecord(Integer.parseInt(request.getParameter("Id")));
    while(rs1.next()){
        String date=rs1.getString(1);
        int hours=rs1.getInt(2);
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
