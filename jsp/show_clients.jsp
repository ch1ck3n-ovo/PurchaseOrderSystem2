
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<%
    String message = request.getParameter("message");

    if (message != null) {
    %>
    <script>
        alert('<%= message.replace("'", "\\'") %>');
    </script>
    <%
    }
%>

<script>
    history.replaceState(null, '', window.location.pathname);
</script>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>全部客戶</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/client_base.css">
        <link rel="icon" href="../assets/img/users.svg" type="image/svg+xml" />
    </head>

    <body>
        <div id="navbar--fixed">
            <a class="button" href="add_client.jsp">
                <img class="svg" src="../assets/img/user-plus.svg"/>
                新增客戶
            </a>
            <a class="button button--selected" href="show_clients.jsp">
                <img class="svg" src="../assets/img/users.svg"/>
                全部客戶
            </a>
            <a class="button" href="select_client.jsp?next=add_order.jsp">
                <img class="svg" src="../assets/img/clipboard-plus.svg"/>
                新增訂單
            </a>
            <a class="button" href="select_client.jsp?next=show_orders.jsp">
                <img class="svg" src="../assets/img/clipboard.svg"/>
                顯示訂單
            </a>
            <a class="button" href="show_orders.jsp">
                <img class="svg" src="../assets/img/clipboard-list.svg"/>
                全部訂單
            </a>
            <a class="button" href="statistics_order.jsp">
                <img class="svg" src="../assets/img/chart-bar.svg"/>
                訂單統計
            </a>
        </div>

        <div class="client-container">
            <table class="client-container__table">
                <thead>
                    <tr class="client-table__row client-table__row--scale">
                        <th class="client-table__cell client-table__cell--text" style="width: 28%">客戶編號</th>
                        <th class="client-table__cell client-table__cell--text" style="width: 48%">客戶名稱</th>
                        <th class="client-table__cell client-table__cell--actions" style="width: 24%; height: 43px;">動作</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection connection = null;
                    Statement statement = null;
                    ResultSet resultSet = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
                        String user = "poc_user_1", password = "1234";

                        connection = DriverManager.getConnection(url, user, password);
                        statement = connection.createStatement();
                        resultSet = statement.executeQuery("SELECT * FROM clients ORDER BY client_id ASC");

                        while (resultSet.next()) {
                            String clientId = resultSet.getString("client_id");
                            String clientName = resultSet.getString("client_name");
                %>
                            <tr class="client-table__row client-table__row--scale">
                                <th class="client-table__cell client-table__cell--text"><%= clientId %></th>
                                <th class="client-table__cell client-table__cell--text"><%= clientName %></th>
                                <th class="client-table__cell client-table__cell--actions">
                                    <div class="client-table__actions">
                                        <a class="button" href="edit_client.jsp?client_id=<%= clientId %>&client_name=<%= clientName %>">編輯</a>
                                        <a class="button button--danger" href="remove_client.jsp?client_id=<%= clientId %>&client_name=<%= clientName %>">刪除</a>
                                    </div>
                                </th>
                            </tr>
                <%
                        }
                    } catch (Exception e) {

                        out.println("錯誤：" + e.getMessage());
                        e.printStackTrace();
                    } finally {

                        if (resultSet != null) {
                            resultSet.close();
                        }
                        if (statement != null) {
                            statement.close();
                        }
                        if (connection != null) {
                            connection.close();
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </body>
</html>
