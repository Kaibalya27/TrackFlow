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
        </tr>
        
<%
    }
%>
    </table>

