<%@ page import="com.servlet.database" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Transaction</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .form-wrap{max-width:560px;margin:24px auto;padding:16px;border:1px solid #ddd;border-radius:6px}
        .form-wrap table{width:100%}
    </style>
</head>
<body>
<%
    database db = new database();
    String idParam = request.getParameter("Id");
    if(idParam == null || idParam.trim().isEmpty()){
        response.sendRedirect("admin.jsp?action=viewTransactions");
        return;
    }

    int playerId = Integer.parseInt(idParam);

    if(request.getMethod().equalsIgnoreCase("GET")){
%>
    <div class="form-wrap">
        <h2 style="text-align:center;">Add Transaction for Player ID: <%=playerId%></h2>
        <form method="post">
            <input type="hidden" name="Id" value="<%=playerId%>">
            <table>
                <tr>
                    <td><label for="amount">Amount:</label></td>
                    <td><input type="number" name="amount" id="amount" required></td>
                </tr>
                <tr>
                    <td><label for="status">Status:</label></td>
                    <td>
                        <select name="status" id="status" required>
                            <option value="">--</option>
                            <option value="IN">IN</option>
                            <option value="OUT">OUT</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><label for="payment_mode">Payment Mode:</label></td>
                    <td><input type="text" name="payment_mode" id="payment_mode" placeholder="e.g. CASH, GPay" required></td>
                </tr>
                <tr>
                    <td><label for="date">Date:</label></td>
                    <td><input type="date" name="date" id="date" required></td>
                </tr>
            </table>
            <div style="text-align:center;margin-top:12px;"><button type="submit">Add</button></div>
        </form>
    </div>
<%
        return;
    }

    // POST: call updateDetails to insert a payment for this player
    int id = Integer.parseInt(request.getParameter("Id"));
    String amountParam = request.getParameter("amount");
    String status = request.getParameter("status");
    String paymentMode = request.getParameter("payment_mode");
    String dateParam = request.getParameter("date");
    int res = db.updateDetails(id, amountParam, status, paymentMode, dateParam);
    if(res>0){ out.println("<h2 style='text-align:center;'>Transaction added successfully.</h2>"); }
    else { out.println("<h2 style='text-align:center;color:#c00;'>Failed to add transaction.</h2>"); }
%>
<script>setTimeout(()=>{ window.location.href='admin.jsp?action=SearchPlayer&Id=' + <%=id%>; },1500);</script>
</body>
</html>
