<%@ page import="com.servlet.database" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
		<img src="logo.png" alt="Logo" class="logo">
		<h1>RTR Badminton Team</h1>
		<nav>
			<a href="index.html">Home</a>
            <form id="logout-form" method="post" action="logout">
                <button type="submit" class="nav-link">Logout</button>
            </form>
		</nav>
		
	</header>

    <h1>Welcome Admin</h1>
    <%
    if(session.getAttribute("username")==null){
        response.sendRedirect("login.html");
        return;
    }
    String name=(String)session.getAttribute("username");
    %>
    <h1><%=name %> </h1>
    <div class="center-links">
        <a href="admin.jsp?action=viewPlayers" class="btn-link">View Players</a>
        <a href="admin.jsp?action=viewTransactions" class="btn-link">View Transactions</a>
        <a href="addPlayer.jsp" class="btn-link">Add Player</a>
    </div>
    <form class="search-player-form">
        <label for="SearchPlayer">Search Player</label>
        <select id="SearchPlayer" name="Id" required>
            <option value="" disabled selected>Select Player</option>
        </select>
        <button type="submit" name="action" value="SearchPlayer">Search</button>
    </form>
    
    

    <% 
        
        String action=(String)request.getParameter("action");
        try{
            database db=new database();
                if(action != null && action.equals("viewPlayers")){
            %>
                <%@ include file="viewPlayers.jsp" %>
            <%
                }
                if(action != null && action.equals("viewTransactions")){
            %>
                <%@ include file="viewTransactions.jsp" %>
            <%
                }
            if(action != null && action.equals("SearchPlayer")){
    %>
                <%@ include file="searchPlayer.jsp" %>
    <%
            }
        }catch(Exception e){
            out.println("<h1>"+e+"</h1>");
        }
    %>
    <script src="script.js"></script>
</body>
</html>