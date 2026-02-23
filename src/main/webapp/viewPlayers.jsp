<div style="text-align: center;">
<a href="downloadPlayers" >Download</a>
</div>
<table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Phone</th>
            <th>Amount</th>
            <th>Opted Hours</th>
            <th>Played Hours</th>
            <th>Remaining Hours</th>
            <th>Actions</th>
            <th>Whatsapp</th>
            <th>View</th>
        </tr>
<%  
    ResultSet rs=db.viewPlayers();
    while(rs.next()){
        int id=rs.getInt(1);
        String playerName=rs.getString(2);
        String phone=rs.getString(3);
        int amount=rs.getInt(4);
        double total_hours=rs.getDouble(5);
        double played_hours=rs.getDouble(6);
        double remaining = total_hours - played_hours;
        
        String encodedMessage = URLEncoder.encode(
            "Hi " + playerName + "\n" +
            "You Paid " + amount + " for " + total_hours + " Hrs\n" +
            "Played: " + played_hours + " Hrs\n" +
            "Balance: " + remaining + " Hrs\n" +
            "Update the playing hours using the link https://trackflow-flax.onrender.com",
            "UTF-8"
        );

        String whatsappUrl = "https://wa.me/" + phone + "?text=" + encodedMessage;
%>
        <tr>
            <td><%=id %></td>
            <td><%=playerName %></td>
            <td><%=phone %></td>
            <td><%=amount %></td>
            <td><%=total_hours %></td>
            <td><%=played_hours %></td>
            <td><%=remaining %></td>
            
            <form action="delete.jsp" method="post">
            <td><button type="submit" name="delete" value="<%=id%>">delete</button></td>
            </form>
            <td><a href="<%=whatsappUrl%>" target="_blank">Send</a></td>
            <td><a href="admin.jsp?Id=<%=id%>&action=SearchPlayer">View</a></td>
        </tr>
        
<%
    }
%>
    </table>

