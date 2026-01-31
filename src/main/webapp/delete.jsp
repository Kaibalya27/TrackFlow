<%@ page import="com.servlet.database" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Player</title>
    <link rel="stylesheet" href="styles.css">
</head>

<%
        database db=new database();
        int deleteId=Integer.parseInt(request.getParameter("delete"));
        int res=db.deletePlayer(deleteId);
        if(res>0){
            out.println("<h2>Player deleted successfully.</h2>");
        }else{
            out.println("<h2>Failed to delete player.</h2>");
        }
        ;
    %>

    <script>
    setTimeout(()=>{
        window.location.href="admin.jsp?action=viewPlayers";
    },2000)
    </script>