package com.servlet;

import java.sql.*;

public class database {
    private final String host = System.getenv("MYSQLHOST");
    private final String port = System.getenv("MYSQLPORT");
    private final String db   = System.getenv("MYSQLDATABASE");
    private final String user_name = System.getenv("MYSQLUSER");
    private final String password = System.getenv("MYSQLPASSWORD");
    private final String url = "jdbc:mysql://" + host + ":" + port + "/" + db
           + "?useSSL=false&allowPublicKeyRetrieval=true";

    Connection con;
    
    public database() throws Exception{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con=DriverManager.getConnection(url,user_name,password);
    }

    public ResultSet viewPlayers() throws Exception{
        String query = "SELECT p.id, p.name, p.phone_no, "
            + "COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.amount ELSE 0 END),0) AS amount, "
            + "(SELECT date FROM payments WHERE pid=p.id AND Status='IN' ORDER BY date DESC LIMIT 1) AS last_payment_date, "
            + "COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.Total_hours ELSE 0 END),0) AS total_hours, "
            + "(SELECT Status FROM payments WHERE pid=p.id ORDER BY date DESC LIMIT 1) AS status, "
            + "COALESCE(SUM(d.played_hours),0) AS played_hours "
            + "FROM players p "
            + "LEFT JOIN payments pay ON p.id=pay.pid "
            + "LEFT JOIN daily_record d ON p.id=d.pid "
            + "GROUP BY p.id";
        Statement st = con.createStatement();
        return st.executeQuery(query);
    }
    
    public ResultSet searchPlayer(int id) throws Exception{
        String query = "SELECT p.id, p.name, p.phone_no, "
            + "COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.amount ELSE 0 END),0) AS amount, "
            + "(SELECT date FROM payments WHERE pid=p.id AND Status='IN' ORDER BY date DESC LIMIT 1) AS last_payment_date, "
            + "COALESCE(SUM(CASE WHEN pay.Status='IN' THEN pay.Total_hours ELSE 0 END),0) AS total_hours "
            + "FROM players p "
            + "LEFT JOIN payments pay ON p.id=pay.pid "
            + "WHERE p.id=? "
            + "GROUP BY p.id";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, id);
        return pst.executeQuery();
    }

        // (removed) viewOutPlayers - replaced by viewTransactions.jsp which lists all payments

        // Return all payment transactions with player name and phone
        public ResultSet viewTransactions() throws Exception{
            String query = "SELECT pay.id AS payment_id, p.id AS player_id, p.name, p.phone_no, "
                + "pay.amount, pay.Status, pay.payment_mode, pay.Total_hours, pay.date "
                + "FROM payments pay "
                + "LEFT JOIN players p ON pay.pid = p.id "
                + "ORDER BY pay.date DESC";
            Statement st = con.createStatement();
            return st.executeQuery(query);
        }

        // Return a single payment record by payment id
        public ResultSet getPayment(int paymentId) throws Exception{
            String q = "SELECT id, pid, amount, Status, payment_mode, Total_hours, date FROM payments WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(q);
            pst.setInt(1, paymentId);
            return pst.executeQuery();
        }

        // Update an existing payment record. All fields are optional; amountParam is parsed here.
        public int updatePayment(int paymentId, String amountParam, String status, String paymentMode, String paymentDate) throws Exception{
            Integer amount = null;
            if(amountParam != null && !amountParam.trim().isEmpty()){
                try{ amount = Integer.parseInt(amountParam.trim()); } catch(NumberFormatException e){ amount = null; }
            }

            boolean hasAmount = amount != null;
            boolean hasStatus = status != null && !status.trim().isEmpty();
            boolean hasPaymentMode = paymentMode != null && !paymentMode.trim().isEmpty();
            boolean hasDate = paymentDate != null && !paymentDate.trim().isEmpty();

            String query = "UPDATE payments SET amount = ?, Status = ?, Total_hours = ?, payment_mode = ?, date = ? WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(query);
            if(hasAmount) pst.setInt(1, amount); else pst.setNull(1, java.sql.Types.INTEGER);
            pst.setString(2, status);
            if(status != null && "IN".equalsIgnoreCase(status) && hasAmount && amount > 0){
                pst.setInt(3, amount/120);
            } else {
                pst.setNull(3, java.sql.Types.INTEGER);
            }
            if(hasPaymentMode) pst.setString(4, paymentMode); else pst.setNull(4, java.sql.Types.VARCHAR);
            if(hasDate){
                String dateOnly = paymentDate.contains(" ") ? paymentDate.split(" ")[0] : paymentDate;
                pst.setDate(5, java.sql.Date.valueOf(dateOnly));
            } else {
                pst.setNull(5, java.sql.Types.DATE);
            }
            pst.setInt(6, paymentId);
            return pst.executeUpdate();
        }
    
    public ResultSet searchPlayerRecord(int id) throws Exception{
        String query="select date, played_hours from daily_record where pid=?";
        PreparedStatement pst=con.prepareStatement(query);
        pst.setInt(1, id);
        return pst.executeQuery();
    }

    // Record a payment (IN/OUT) for a player. This replaces updating amount/status on players.
    // Accepts payment mode and optional date. If date is null/empty, server will use NOW().
    public int updateDetails(int id, String amountParam, String status, String paymentMode, String paymentDate) throws Exception{
        // Parse amount internally; treat presence by nullity
        Integer amount = null;
        if(amountParam != null && !amountParam.trim().isEmpty()){
            try{ amount = Integer.parseInt(amountParam.trim()); } catch(NumberFormatException e){ amount = null; }
        }
        // If nothing meaningful provided, do nothing
        boolean hasAmount = amount != null;
        boolean hasStatus = status != null && !status.trim().isEmpty();
        boolean hasPaymentMode = paymentMode != null && !paymentMode.trim().isEmpty();
        boolean hasDate = paymentDate != null && !paymentDate.trim().isEmpty();
        if(!hasAmount && !hasStatus && !hasPaymentMode && !hasDate) return 0;

        String query;
        if(hasDate) {
            query = "INSERT INTO payments (pid, amount, Status, Total_hours, payment_mode, date) VALUES (?, ?, ?, ?, ?, ?)";
        } else {
            query = "INSERT INTO payments (pid, amount, Status, Total_hours, payment_mode, date) VALUES (?, ?, ?, ?, ?, CURDATE())";
        }
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, id);
        if(hasAmount) pst.setInt(2, amount); else pst.setNull(2, java.sql.Types.INTEGER);
        pst.setString(3, status);
        // Only calculate and store Total_hours for IN payments when amount present and >0
        if(status != null && "IN".equalsIgnoreCase(status) && hasAmount && amount > 0) {
            int totalHours = amount / 120;
            pst.setInt(4, totalHours);
        } else {
            pst.setNull(4, java.sql.Types.INTEGER);
        }
        // payment mode: keep NULL if not provided
        if(hasPaymentMode) pst.setString(5, paymentMode); else pst.setNull(5, java.sql.Types.VARCHAR);
        if(hasDate) pst.setString(6, paymentDate);
        return pst.executeUpdate();
    }

    public int deletePlayer(int id) throws Exception{
        // delete dependent payments first to be safe, then player
        String q1 = "DELETE FROM payments WHERE pid = ?";
        PreparedStatement pst1 = con.prepareStatement(q1);
        pst1.setInt(1, id);
        pst1.executeUpdate();

        String q2 = "DELETE FROM players WHERE id = ?";
        PreparedStatement pst2 = con.prepareStatement(q2);
        pst2.setInt(1, id);
        return pst2.executeUpdate();
    }

    // Create a player and optionally create an initial payment record
    public int addPlayer(String name, String phone_no, int amount, String status, String paymentMode, String paymentDate) throws Exception{
        String insertPlayer = "INSERT INTO players (name, phone_no) VALUES (?, ?)";
        PreparedStatement pst = con.prepareStatement(insertPlayer, Statement.RETURN_GENERATED_KEYS);
        pst.setString(1, name);
        pst.setString(2, phone_no);
        int res = pst.executeUpdate();
        ResultSet keys = pst.getGeneratedKeys();
        if(keys.next()){
            int playerId = keys.getInt(1);
            if(amount > 0) {
                // validate required fields for initial payment
                if(paymentMode == null || paymentMode.trim().isEmpty() || paymentDate == null || paymentDate.trim().isEmpty()){
                    throw new IllegalArgumentException("paymentMode and paymentDate are required for addPlayer");
                }
                String insertPayment = "INSERT INTO payments (pid, amount, Status, Total_hours, payment_mode, date) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement p2 = con.prepareStatement(insertPayment);
                p2.setInt(1, playerId);
                p2.setInt(2, amount);
                p2.setString(3, status);
                if(status != null && "IN".equalsIgnoreCase(status)){
                    p2.setInt(4, amount/120);
                } else {
                    p2.setNull(4, java.sql.Types.INTEGER);
                }
                p2.setString(5, paymentMode);
                p2.setString(6, paymentDate);
                p2.executeUpdate();
            }
        }
        return res;
    }
}
