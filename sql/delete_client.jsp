
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

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

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
        String user = "poc_user_1";
        String password = "1234";
        connection = DriverManager.getConnection(url, user, password);

        String command = "SELECT * FROM orders WHERE client_id = ?";
        preparedStatement = connection.prepareStatement(command);
        preparedStatement.setString(1, clientId);
        resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            response.sendRedirect(buildRedirectUrl(
                "../jsp/remove_client.jsp", 
                "❌ 不能刪除有訂單的客戶！", 
                clientId, clientName
            ));
            return;
        }

        command = "DELETE FROM clients WHERE client_id = ?";
        preparedStatement = connection.prepareStatement(command);
        preparedStatement.setString(1, clientId);
        preparedStatement.executeUpdate();

        response.sendRedirect(buildRedirectUrl("../jsp/show_clients.jsp", "⭕ 刪除成功！"));
    } catch (Exception e) {

        String message = "❌ 錯誤： " + e.getMessage().replace("'", "\\'");
        response.sendRedirect(buildRedirectUrl("../jsp/remove_client.jsp", message, clientId, clientName));
    } finally {
        
        if (resultSet != null) {
            resultSet.close();
        }
        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>