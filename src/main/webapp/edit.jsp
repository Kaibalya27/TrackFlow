<%@ page import="com.servlet.database, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<%
    database db = new database();
    String paymentIdParam = request.getParameter("paymentId");

    // Single-purpose: transaction edit only. Redirect if no paymentId supplied.
    if(paymentIdParam == null || paymentIdParam.trim().isEmpty()){
        response.sendRedirect("admin.jsp?action=viewTransactions");
        return;
    }

    int paymentId = Integer.parseInt(paymentIdParam);

    if(request.getMethod().equalsIgnoreCase("GET")){
        ResultSet r = db.getPayment(paymentId);
        if(r.next()){
            int pid = r.getInt("pid");
            String amountVal = r.getString("amount");
            String statusVal = r.getString("Status");
            String modeVal = r.getString("payment_mode");
            java.sql.Date d = r.getDate("date");
%>
    <form method="post">
        <input type="hidden" name="paymentId" value="<%=paymentId%>">
        <table>
            <tr>
                <td>Player ID:</td>
                <td><strong><%=pid%></strong></td>
            </tr>
            <tr>
                <td><label for="amount">Amount:</label></td>
                <td><input type="number" name="amount" id="amount" value="<%= (amountVal==null?"":amountVal) %>"></td>
            </tr>
            <tr>
                <td><label for="status">Status:</label></td>
                <td>
                    <select name="status">
                        <option value="">--</option>
                        <option value="IN" <%= ("IN".equalsIgnoreCase(statusVal)?"selected":"") %>>IN</option>
                        <option value="OUT" <%= ("OUT".equalsIgnoreCase(statusVal)?"selected":"") %>>OUT</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td><label for="payment_mode">Payment Mode:</label></td>
                <td><input type="text" name="payment_mode" id="payment_mode" value="<%= (modeVal==null?"":modeVal) %>"></td>
            </tr>
            <tr>
                <td><label for="date">Date:</label></td>
                <td><input type="date" name="date" id="date" value="<%= (d==null?"":d.toString()) %>"></td>
            </tr>
        </table>
        <button type="submit">Save</button>
    </form>
<%
        } else {
            out.println("<h2>Payment not found</h2>");
            %><script>setTimeout(()=>{ window.location.href='admin.jsp?action=viewTransactions'; },1500);</script><%
        }
        return;
    }

    // POST -> perform updatePayment
    String amountParam = request.getParameter("amount");
    String status = request.getParameter("status");
    String paymentMode = request.getParameter("payment_mode");
    String dateParam = request.getParameter("date");
    int updated = db.updatePayment(paymentId, amountParam, status, paymentMode, dateParam);
    if(updated > 0){ out.println("<h2>Transaction updated successfully.</h2>"); }
    else { out.println("<h2>Failed to update transaction.</h2>"); }
%>
<script>
    setTimeout(()=>{ window.location.href='admin.jsp?action=viewTransactions'; },1500);
</script>
</body>
</html>

