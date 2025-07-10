
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<%!
    private <T> T requireNonNullElse(T obj, T defaultObj) {
        return (obj != null) ? obj : defaultObj;
    }
    private String buildOrderUrl(String baseUrl, String message, boolean isClosed, String orderDueDate, String clientId, 
                                String t2tOrderNo, String tBoxOrderNo, String tSourceOrderNo, String t2cDueDate, 
                                String t2cOrderNo, String mailSentDate, String scheduleSuggestion, String clientOrderNo, 
                                String purchaseOrderNo, String productionOrderNo, String outsourcingOrderNo, 
                                int orderQuantity, int shippedQuantity, String note) throws Exception {
        return baseUrl +
            "?message="                 + java.net.URLEncoder.encode(requireNonNullElse(message,            ""), "UTF-8") +
            "&is_closed="               + java.net.URLEncoder.encode(String.valueOf(isClosed), "UTF-8") +
            "&order_due_date="          + java.net.URLEncoder.encode(requireNonNullElse(orderDueDate,       ""), "UTF-8") +
            "&client_id="               + java.net.URLEncoder.encode(requireNonNullElse(clientId,           ""), "UTF-8") +
            "&t2t_order_no="            + java.net.URLEncoder.encode(requireNonNullElse(t2tOrderNo,         ""), "UTF-8") +
            "&t_box_order_no="          + java.net.URLEncoder.encode(requireNonNullElse(tBoxOrderNo,        ""), "UTF-8") +
            "&t_source_order_no="       + java.net.URLEncoder.encode(requireNonNullElse(tSourceOrderNo,     ""), "UTF-8") +
            "&t2c_due_date="            + java.net.URLEncoder.encode(requireNonNullElse(t2cDueDate,         ""), "UTF-8") +
            "&t2c_order_no="            + java.net.URLEncoder.encode(requireNonNullElse(t2cOrderNo,         ""), "UTF-8") +
            "&mail_sent_date="          + java.net.URLEncoder.encode(requireNonNullElse(mailSentDate,       ""), "UTF-8") +
            "&schedule_suggestion="     + java.net.URLEncoder.encode(requireNonNullElse(scheduleSuggestion, ""), "UTF-8") +
            "&client_order_no="         + java.net.URLEncoder.encode(requireNonNullElse(clientOrderNo,      ""), "UTF-8") +
            "&purchase_order_no="       + java.net.URLEncoder.encode(requireNonNullElse(purchaseOrderNo,    ""), "UTF-8") +
            "&production_order_no="     + java.net.URLEncoder.encode(requireNonNullElse(productionOrderNo,  ""), "UTF-8") +
            "&outsourcing_order_no="    + java.net.URLEncoder.encode(requireNonNullElse(outsourcingOrderNo, ""), "UTF-8") +
            "&order_quantity="          + java.net.URLEncoder.encode(String.valueOf(orderQuantity), "UTF-8") +
            "&shipped_quantity="        + java.net.URLEncoder.encode(String.valueOf(shippedQuantity), "UTF-8") +
            "&note="                    + java.net.URLEncoder.encode(String.valueOf(note), "UTF-8");
    }
    private String buildOrderUrl(String baseUrl, String message) throws Exception {
        return baseUrl +
            "&message="                 + java.net.URLEncoder.encode(requireNonNullElse(message,            ""), "UTF-8");
    }
%>

<%  
    // 1. 避免亂碼
    request.setCharacterEncoding("UTF-8");
    
    // 取得表單欄位
    boolean isClosed            = request.getParameter("is_closed") != null;
    
    String orderDueDate         = requireNonNullElse(request.getParameter("order_due_date"), "");
    String clientId             = requireNonNullElse(request.getParameter("client_id"), "C");
    String clientName           = requireNonNullElse(request.getParameter("client_name"), "");
    String t2tOrderNo           = requireNonNullElse(request.getParameter("t2t_order_no"), "");
    String tBoxOrderNo          = requireNonNullElse(request.getParameter("t_box_order_no"), "");
    String tSourceOrderNo       = requireNonNullElse(request.getParameter("t_source_order_no"), "");
    String t2cDueDate           = requireNonNullElse(request.getParameter("t2c_due_date"), "");
    String t2cOrderNo           = requireNonNullElse(request.getParameter("t2c_order_no"), "");
    String mailSentDate         = requireNonNullElse(request.getParameter("mail_sent_date"), "");
    String scheduleSuggestion   = requireNonNullElse(request.getParameter("schedule_suggestion"), "");
    String clientOrderNo        = requireNonNullElse(request.getParameter("client_order_no"), "");
    String purchaseOrderNo      = requireNonNullElse(request.getParameter("purchase_order_no"), "");
    String productionOrderNo    = requireNonNullElse(request.getParameter("production_order_no"), "");
    String outsourcingOrderNo   = requireNonNullElse(request.getParameter("outsourcing_order_no"), "");
    String note                 = requireNonNullElse(request.getParameter("note"), "");

    int orderQuantity = 0;
    try {
        orderQuantity = Integer.parseInt(request.getParameter("order_quantity"));
    } catch (NumberFormatException e) {
        ;
    }

    int shippedQuantity = 0;
    try {
        shippedQuantity = Integer.parseInt(request.getParameter("shipped_quantity"));
    } catch (NumberFormatException e) {
        ;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        if (orderQuantity == 0) {
            String newUrl = buildOrderUrl(
                    "../jsp/add_order.jsp", "❌ 訂單數量不可為0！", 
                    isClosed, orderDueDate, 
                    clientId, t2tOrderNo, tBoxOrderNo, 
                    tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                    mailSentDate, scheduleSuggestion, clientOrderNo, 
                    purchaseOrderNo, productionOrderNo, outsourcingOrderNo, 
                    orderQuantity, shippedQuantity, note);
            response.sendRedirect(newUrl);
            return;
        }

        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
        String user = "poc_user_1", password = "1234";

        connection = DriverManager.getConnection(url, user, password);

        String sql = "SELECT client_name FROM clients WHERE client_id = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, clientId);
        resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            clientName = resultSet.getString("client_name");
        } else {
            String newUrl = buildOrderUrl(
                    "../jsp/add_order.jsp", 
                    "❌ 客戶代號 " + clientId + " 不存在！", 
                    isClosed, orderDueDate, 
                    clientId, t2tOrderNo, tBoxOrderNo, 
                    tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                    mailSentDate, scheduleSuggestion, clientOrderNo, 
                    purchaseOrderNo, productionOrderNo, outsourcingOrderNo, 
                    orderQuantity, shippedQuantity, note);
            response.sendRedirect(newUrl);
            return;
        }

        // 1. 準備 SQL（16 個欄位就要 16 個參數）
        sql = 
                "INSERT INTO orders (" +
                "is_closed, order_due_date, client_id, client_name, " +
                "t2t_order_no, t_box_order_no, t_source_order_no, " +
                "t2c_due_date, t2c_order_no, mail_sent_date, " +
                "schedule_suggestion, client_order_no, purchase_order_no, " +
                "production_order_no, outsourcing_order_no, order_quantity, shipped_quantity, note" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        preparedStatement = connection.prepareStatement(sql);

        if (orderQuantity - shippedQuantity == 0) {
            isClosed = true;
        }

        // 2. 設定參數
        preparedStatement.setBoolean(1, isClosed);
        preparedStatement.setDate(2, java.sql.Date.valueOf(orderDueDate));
        preparedStatement.setString(3, clientId);
        preparedStatement.setString(4, clientName);

        // 以下三個如果要留 NULL，就用 setNull，否則 setString
        if (t2tOrderNo != null) {
            preparedStatement.setString(5, t2tOrderNo);
        } else {
            preparedStatement.setNull(5, Types.VARCHAR);
        }

        if (tBoxOrderNo != null) {
            preparedStatement.setString(6, tBoxOrderNo);
        } else {
            preparedStatement.setNull(6, Types.VARCHAR);
        }

        if (tSourceOrderNo != null) {
            preparedStatement.setString(7, tSourceOrderNo);
        } else {
            preparedStatement.setNull(7, Types.VARCHAR);
        }

        // 再繼續後面的必填欄位
        preparedStatement.setDate(8, java.sql.Date.valueOf(t2cDueDate));
        preparedStatement.setString(9, t2cOrderNo);
        preparedStatement.setDate(10, java.sql.Date.valueOf(mailSentDate));
        preparedStatement.setString(11, scheduleSuggestion);
        preparedStatement.setString(12, clientOrderNo);
        preparedStatement.setString(13, purchaseOrderNo);
        preparedStatement.setString(14, productionOrderNo);
        preparedStatement.setString(15, outsourcingOrderNo);
        preparedStatement.setInt(16, orderQuantity);
        preparedStatement.setInt(17, shippedQuantity);
        preparedStatement.setString(18, note);

        // 3. 執行
        preparedStatement.executeUpdate();

        response.sendRedirect(buildOrderUrl("../jsp/select_client.jsp?next=add_order.jsp", "⭕ 新增成功！"));
    } catch (Exception e) {

        String message = "❌ 錯誤： " + e.getMessage().replace("'", "\\'");
        if (message.contains("Duplicate entry")) {
            message = "❌ 產鈞訂單單號為 " + t2cOrderNo + " 的訂單已經存在，請勿重複新增！";
        }
        String newUrl = buildOrderUrl("../jsp/add_order.jsp", message, isClosed, orderDueDate, 
                    clientId, t2tOrderNo, tBoxOrderNo, 
                    tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                    mailSentDate, scheduleSuggestion, clientOrderNo, 
                    purchaseOrderNo, productionOrderNo, outsourcingOrderNo, 
                    orderQuantity, shippedQuantity, note);
        response.sendRedirect(newUrl);
        return;
    } finally {

        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>