

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>採購單</title>
        <link rel="stylesheet" href="assets/css/global.css">
        <link rel="icon" href="assets/img/clipboard-list.svg" type="image/svg+xml" />
    </head>

    <body>
        <div id="navbar--fixed">
            <a class="button" href="jsp/add_client.jsp">
                <img class="svg" src="assets/img/user-plus.svg"/>
                新增客戶
            </a>
            <a class="button" href="jsp/show_clients.jsp">
                <img class="svg" src="assets/img/users.svg"/>
                顯示客戶
            </a>
            <a class="button" href="jsp/select_client.jsp?next=add_order.jsp">
                <img class="svg" src="assets/img/clipboard-plus.svg"/>
                新增訂單
            </a>
            <a class="button" href="jsp/select_client.jsp?next=show_orders.jsp">
                <img class="svg" src="assets/img/clipboard.svg"/>
                顯示訂單
            </a>
            <a class="button" href="jsp/show_orders.jsp">
                <img class="svg" src="assets/img/clipboard-list.svg"/>
                全部訂單
            </a>
            <a class="button" href="jsp/statistics_order.jsp">
                <img class="svg" src="assets/img/chart-bar.svg"/>
                訂單統計
            </a>
        </div>
    </body>
</html>
