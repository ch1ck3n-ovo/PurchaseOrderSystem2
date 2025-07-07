
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
            "?message="                 + java.net.URLEncoder.encode(requireNonNullElse(message,            ""), "UTF-8");
    }
%>

<%  
    // 1. 避免亂碼
    request.setCharacterEncoding("UTF-8");
    
    // 取得表單欄位
    boolean isClosed            = request.getParameter("is_closed") != null;
    
    String orderDueDate         = Objects.requireNonNullElse(request.getParameter("order_due_date"), "");
    String clientId             = Objects.requireNonNullElse(request.getParameter("client_id"), "C");
    String clientName           = Objects.requireNonNullElse(request.getParameter("client_name"), "");
    String t2tOrderNo           = Objects.requireNonNullElse(request.getParameter("t2t_order_no"), "");
    String tBoxOrderNo          = Objects.requireNonNullElse(request.getParameter("t_box_order_no"), "");
    String tSourceOrderNo       = Objects.requireNonNullElse(request.getParameter("t_source_order_no"), "");
    String t2cDueDate           = Objects.requireNonNullElse(request.getParameter("t2c_due_date"), "");
    String t2cOrderNo           = Objects.requireNonNullElse(request.getParameter("t2c_order_no"), "");
    String mailSentDate         = Objects.requireNonNullElse(request.getParameter("mail_sent_date"), "");
    String scheduleSuggestion   = Objects.requireNonNullElse(request.getParameter("schedule_suggestion"), "");
    String clientOrderNo        = Objects.requireNonNullElse(request.getParameter("client_order_no"), "");
    String purchaseOrderNo      = Objects.requireNonNullElse(request.getParameter("purchase_order_no"), "");
    String productionOrderNo    = Objects.requireNonNullElse(request.getParameter("production_order_no"), "");
    String outsourcingOrderNo   = Objects.requireNonNullElse(request.getParameter("outsourcing_order_no"), "");
    String note                 = Objects.requireNonNullElse(request.getParameter("note"), "");

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

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
        String user = "poc_user_1";
        String password = "1234";

        connection = DriverManager.getConnection(url, user, password);

        String command = "DELETE FROM orders WHERE t2c_order_no = ?";
        preparedStatement = connection.prepareStatement(command);
        preparedStatement.setString(1, t2cOrderNo);
        preparedStatement.executeUpdate();

        response.sendRedirect(buildOrderUrl("../jsp/show_orders.jsp", "⭕ 刪除成功！"));
    } catch (Exception e) {

        String message = "❌ 錯誤： " + e.getMessage().replace("'", "\\'");
        String newUrl = buildOrderUrl("../jsp/delete_order.jsp", message, isClosed, orderDueDate, 
                    clientId, t2tOrderNo, tBoxOrderNo, 
                    tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                    mailSentDate, scheduleSuggestion, clientOrderNo, 
                    purchaseOrderNo, productionOrderNo, outsourcingOrderNo, 
                    orderQuantity, shippedQuantity, note);
        response.sendRedirect(newUrl);
    } finally {

        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>