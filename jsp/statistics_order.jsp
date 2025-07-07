
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

    HashMap<String, Integer> yearClosed = new HashMap<String, Integer>();
    HashMap<String, Integer> yearNotClosed = new HashMap<String, Integer>();
    HashMap<String, Integer> monthClosed = new HashMap<String, Integer>();
    HashMap<String, Integer> monthNotClosed = new HashMap<String, Integer>();

    Connection connection = null;
    Statement statement = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    String command;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
        String user = "poc_user_1", password = "1234";

        connection = DriverManager.getConnection(url, user, password);
        statement = connection.createStatement();
        command = "SELECT * FROM orders ORDER BY t2c_order_no ASC";
        preparedStatement = connection.prepareStatement(command);
        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            String isClosed             = resultSet.getString("is_closed").equals("0") ? "X" : "V";
            boolean boolClosed          = isClosed.equals("V");
            String orderDueDate         = resultSet.getString("order_due_date");
            int orderQuantity           = Integer.parseInt(resultSet.getString("order_quantity"));
            int shippedQuantity         = Integer.parseInt(resultSet.getString("shipped_quantity"));

            String key = orderDueDate.substring(0, 4);
            int value = orderQuantity;
            if (boolClosed) {
                if (shippedQuantity != 0) {
                    value = shippedQuantity;
                }
                if (!yearClosed.containsKey(key)) {
                    yearClosed.put(key, value);
                } else {
                    yearClosed.put(key, yearClosed.get(key) + value);
                }
                if (!yearNotClosed.containsKey(key)) {
                    yearNotClosed.put(key, 0);
                }
            } else {
                if (!yearNotClosed.containsKey(key)) {
                    yearNotClosed.put(key, (value - shippedQuantity));
                } else {
                    yearNotClosed.put(key, yearNotClosed.get(key) + (value - shippedQuantity));
                }
                if (!yearClosed.containsKey(key)) {
                    yearClosed.put(key, shippedQuantity);
                } else {
                    yearClosed.put(key, yearClosed.get(key) + shippedQuantity);
                }
            } 
            
            key = orderDueDate.substring(0, 7);
            value = orderQuantity;
            if (boolClosed) {
                if (shippedQuantity != 0) {
                    value = shippedQuantity;
                }
                if (!monthClosed.containsKey(key)) {
                    monthClosed.put(key, value);
                } else {
                    monthClosed.put(key, monthClosed.get(key) + value);
                }
                if (!monthNotClosed.containsKey(key)) {
                    monthNotClosed.put(key, 0);
                }
            } else {
                if (!monthNotClosed.containsKey(key)) {
                    monthNotClosed.put(key, (value - shippedQuantity));
                } else {
                    monthNotClosed.put(key, monthNotClosed.get(key) + (value - shippedQuantity));
                }
                if (!monthClosed.containsKey(key)) {
                    monthClosed.put(key, shippedQuantity);
                } else {
                    monthClosed.put(key, monthClosed.get(key) + shippedQuantity);
                }
            }
        }
    } catch (Exception e) {

        out.println("錯誤：" + e.getMessage());
        e.printStackTrace();
    } finally {

        if (resultSet != null) {
            resultSet.close();
        }
        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
%>

<script>
    history.replaceState(null, '', window.location.pathname);
</script>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>訂單統計</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/client_base.css">
        <link rel="stylesheet" href="../assets/css/form_base.css">
        <link rel="icon" href="../assets/img/chart-bar.svg" type="image/svg+xml" />
    </head>

    <body>
        <div id="navbar--fixed">
            <a class="button" href="add_client.jsp">
                <img class="svg" src="../assets/img/user-plus.svg"/>
                新增客戶
            </a>
            <a class="button" href="show_clients.jsp">
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
            <a class="button button--selected" href="statistics_order.jsp">
                <img class="svg" src="../assets/img/chart-bar.svg"/>
                訂單統計
            </a>
        </div>

        <div style="display: flex;">
            <div class="form-container">
                <div class="form-header">
                    <h1>依年份</h1>
                </div>
                <table class="client-container__table">
                    <thead>
                        <tr class="client-table__row client-table__row--scale" style="height: 59px;">
                            <th class="client-table__cell client-table__cell--text" style="width: 18%">時間</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">總出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">已出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">未出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 1%;"></th>
                            <th class="client-table__cell" style="width: 18%;">
                                <div class="client-table__actions">
                                </div>
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                    <%
                        List<Map.Entry<String, Integer>> sortedYearClosed = new ArrayList<>(yearClosed.entrySet());

                        sortedYearClosed.sort((a, b) -> a.getKey().compareTo(b.getKey()));

                        for (Map.Entry<String, Integer> entry : sortedYearClosed) {
                            String key = entry.getKey();
                            Integer value = entry.getValue();
                            Integer notClosed = yearNotClosed.get(key);
                    %>
                            <tr class="client-table__row client-table__row--scale">
                                <th class="client-table__cell client-table__cell--text"><%= key %> 年</th>
                                <th class="client-table__cell client-table__cell--text" style="text-align: right;"><%= value + notClosed %></th>
                                <th class="client-table__cell client-table__cell--text" style="text-align: right;"><%= value %></th>
                                <th class="client-table__cell client-table__cell--text" style="text-align: right;"><%= notClosed %></th>
                                <th class="client-table__cell client-table__cell--text"></th>
                                <th>
                                    <div class="client-table__actions">
                                        <a class="button" href="show_orders.jsp?time=<%= key %>">查看</a>
                                    </div>
                                </th>
                            </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <div class="form-container">
                <div class="form__header">
                    <h1>依月份</h1>
                </div>
                <table class="client-container__table">
                    <thead>
                        <tr class="client-table__row client-table__row--scale" style="height: 59px;">
                            <th class="client-table__cell client-table__cell--text" style="width: 18%">時間</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">總出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">已出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;">未出貨量<br>(PCS)</th>
                            <th class="client-table__cell client-table__cell--text" style="width: 1%;"></th>
                            <th class="client-table__cell" style="width: 18%;">
                                <div class="client-table__actions">
                                </div>
                            </th>
                        </tr>
                    </thead>

                    <tbody>

                    <%
                        List<Map.Entry<String, Integer>> sortedMonthClosed = new ArrayList<>(monthClosed.entrySet());

                        sortedMonthClosed.sort((a, b) -> a.getKey().compareTo(b.getKey()));

                        for (Map.Entry<String, Integer> entry : sortedMonthClosed) {
                            String key = entry.getKey();
                            Integer value = entry.getValue();
                            Integer notClosed = monthNotClosed.get(key);
                    %>
                            <tr class="client-table__row client-table__row--scale">
                                <th class="client-table__cell client-table__cell--text" style="width: 18%"><%= key.substring(0, 4) %> 年 <%= key.substring(5, 7) %> 月</th>
                                <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;"><%= value + notClosed %></th>
                                <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;"><%= value %></th>
                                <th class="client-table__cell client-table__cell--text" style="width: 21%; text-align: right;"><%= notClosed %></th>
                                <th class="client-table__cell client-table__cell--text" style="width: 1%;"></th>
                                <th style="width: 18%;">
                                    <div class="client-table__actions">
                                        <a class="button" href="show_orders.jsp?time=<%= key %>">查看</a>
                                    </div>
                                </th>
                            </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
