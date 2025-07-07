
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.command.*, javax.command.*, java.util.*, java.sql.*" %>

<%! 
    private <T> T requireNonNullElse(T obj, T defaultObj) {
        return (obj != null) ? obj : defaultObj;
    }
    private String buildRedirectUrl(String baseUrl, String message, String clientId, String clientName) throws Exception {
        return baseUrl +
            "?message="     + java.net.URLEncoder.encode(message, "UTF-8") +
            "&client_id="   + java.net.URLEncoder.encode(requireNonNullElse(clientId,   ""), "UTF-8") +
            "&client_name=" + java.net.URLEncoder.encode(requireNonNullElse(clientName, ""), "UTF-8");
    }
    private String buildRedirectUrl(String baseUrl, String message) throws Exception {
        return baseUrl +
            "?message="     + java.net.URLEncoder.encode(message, "UTF-8");
    }
%>

<%
    request.setCharacterEncoding("UTF-8");
        
    String clientId     = request.getParameter("client_id");
    String clientName   = request.getParameter("client_name");
    if (!clientId.startsWith("C")) {
        response.sendRedirect(buildRedirectUrl(
            "../jsp/add_client.jsp", 
            "❌ 客戶代號必須是 C 開頭！", 
            clientId, clientName
        ));
        return;
    } else if (clientId.equals("C")) {
        response.sendRedirect(buildRedirectUrl(
            "../jsp/add_client.jsp", 
            "❌ 客戶代號不能為 C ！", 
            clientId, clientName
        ));
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
        String user = "poc_user_1";
        String password = "1234";
        connection = DriverManager.getConnection(url, user, password);

        String command = "INSERT INTO clients (client_id, client_name) VALUES (?, ?)";
        preparedStatement = connection.prepareStatement(command);
        preparedStatement.setString(1, clientId);
        preparedStatement.setString(2, clientName);
        preparedStatement.executeUpdate();

        response.sendRedirect(buildRedirectUrl("../jsp/add_client.jsp", "⭕ 新增成功！"));
    } catch (Exception e) {

        String message = "❌ 錯誤： " + e.getMessage().replace("'", "\\'");
        if (message.contains("Duplicate entry")) {
            message = "❌ 客戶代號為 " + clientId + " 的訂單已經存在，請勿重複新增！";
        }
        response.sendRedirect(buildRedirectUrl("../jsp/add_client.jsp", message, clientId, clientName));
    } finally {
        
        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>