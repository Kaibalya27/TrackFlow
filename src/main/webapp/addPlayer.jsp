<%@ page import="com.servlet.database" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Player - RTR Badminton Team</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <form method="post" class="add-player-form">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="phone_no">Phone Number:</label>
        <input type="text" id="phone_no" name="phone_no" required>

        <label for="amount">Amount:</label>
        <input type="number" id="amount" name="amount" required>

        <label for="payment_mode">Payment Mode:</label>
        <input type="text" id="payment_mode" name="payment_mode" required placeholder="e.g. CASH, GPay">

        <label for="date">Payment Date</label>
        <input type="date" id="date" name="date" required>

        <label for="status" class="label-inline">In / Out:</label>
        <span class="radio-inline">
            <label><input type="radio" name="status" value="In" required> In</label>
            <label><input type="radio" name="status" value="Out" required> Out</label>
        </span>

        <button type="submit">Add Player</button>
    </form>

    <%
    if(request.getMethod().equalsIgnoreCase("GET")){
        return;
    }
    database db=new database();
    String name=request.getParameter("name");
    String phone_no=request.getParameter("phone_no");
    int amount=Integer.parseInt(request.getParameter("amount"));
    String status=request.getParameter("status");
    String paymentMode = request.getParameter("payment_mode");
    String dateParam = request.getParameter("date");
    int res=db.addPlayer(name,phone_no,amount,status,paymentMode,dateParam);
    if(res>0){
        out.println("<h2>Player added successfully.</h2>");
    }else{
        out.println("<h2>Failed to add player.</h2>");
    }
    %>
    <script>
    setTimeout(()=>{
        window.location.href="admin.jsp?action=viewPlayers";
    },2000)
    </script>
</body>
</html>