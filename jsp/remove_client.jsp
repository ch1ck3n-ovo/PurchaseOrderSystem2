
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<%!
    private <T> T requireNonNullElse(T obj, T defaultObj) {
        return (obj != null) ? obj : defaultObj;
    }
%>

<%
    String message      = request.getParameter("message");
    String clientId     = request.getParameter("client_id");
    if (clientId == null) {
        response.sendRedirect("show_clients.jsp");
        return;
    }
    String clientName   = request.getParameter("client_name");

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
        <title>刪除客戶</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/form_base.css">
        <link rel="icon" href="../assets/img/user-x.svg" type="image/svg+xml" />
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

        <div class="form-container">
            <div class="form-header">
                <h1>確認刪除</h1>
            </div>
            <form action="../sql/delete_client.jsp" method="post">
                <div class="form-field">
                    <div class="form-label">客戶代號</div>
                    <input class="input input--text" type="text" name="client_id" value="<%= clientId %>" readonly>
                </div>
                <div class="form-field">
                    <div class="form-label">客戶名稱</div>
                    <input class="input input--text" type="text" name="client_name" value="<%= clientName %>" readonly>
                </div>
                <input class="button button--round button--danger" type="submit" value="刪除">
            </form>
        </div>
    </body>
</html>
