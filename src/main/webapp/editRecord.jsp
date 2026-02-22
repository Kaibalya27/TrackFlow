<%@ page import="com.servlet.database" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <%
        String recordId = request.getParameter("recordId");
        String id = request.getParameter("Id");
        if (recordId == null) {
            response.sendRedirect("searchPlayer.jsp");
            return;
        }
    %>

    <h1>Edit Record</h1>
    <form method="post" action="editRecord.jsp" >
        <input type="hidden" name="recordId" value="<%=recordId%>">
        <input type="hidden" name="Id" value="<%=id%>">
        <label for="played_hours">Played Hours:</label>
        <input type="number" step="0.1" name="played_hours" id="played_hours" required>
        <br><br>
        <button type="submit">Update Record</button>
    </form>
    <%
    if(request.getMethod().equalsIgnoreCase("POST")) {
        int recordIdInt = Integer.parseInt(recordId);
        database db = new database();
        int res=db.updatePlayedHours(recordIdInt, request.getParameter("played_hours"));
        if(res>0){
            out.println("<p style='color:green;'>Record updated successfully!</p>");
        } else {
            out.println("<p style='color:red;'>Failed to update record.</p>");
        }
        
        response.sendRedirect("admin.jsp?Id=" + id+"&action=SearchPlayer");
        
    }
        
    %>
</body>
</html>

