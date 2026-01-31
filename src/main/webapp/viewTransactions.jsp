<table>
    <tr>
        <th>Payment ID</th>
        <th>Player ID</th>
        <th>Name</th>
        <th>Phone</th>
        <th>Amount</th>
        <th>Status</th>
        <th>Mode</th>
        <th>Total Hours</th>
        <th>Date</th>
        <th>Actions</th>
    </tr>
<%
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
%>
    <tr>
        <td><%=paymentId %></td>
        <td><%=playerId %></td>
        <td><%=playerName %></td>
        <td><%=phone %></td>
        <td><%=amount %></td>
        <td><%=status %></td>
        <td><%= (mode==null?"-":mode) %></td>
        <td><%= (totalHours==null?"-":totalHours) %></td>
        <td><%=date %></td>
        <td><a href="edit.jsp?paymentId=<%=paymentId%>">Edit</a></td>
    </tr>
<%
    }
%>
</table>
