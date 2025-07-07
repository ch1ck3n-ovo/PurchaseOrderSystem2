
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<%!
    private <T> T requireNonNullElse(T obj, T defaultObj) {
        return (obj != null) ? obj : defaultObj;
    }
    private String buildOrderUrl(String baseUrl, boolean isClosed, String orderDueDate, String clientId, 
                                String t2tOrderNo, String tBoxOrderNo, String tSourceOrderNo, String t2cDueDate, 
                                String t2cOrderNo, String mailSentDate, String scheduleSuggestion, String clientOrderNo, 
                                String purchaseOrderNo, String productionOrderNo, String outsourcingOrderNo, 
                                int orderQuantity, int shippedQuantity, String note) throws Exception {
        return baseUrl +
            "?is_closed="               + java.net.URLEncoder.encode(String.valueOf(isClosed), "UTF-8") +
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
            "&shipped_quantity="          + java.net.URLEncoder.encode(String.valueOf(shippedQuantity), "UTF-8") +
            "&note="                    + java.net.URLEncoder.encode(String.valueOf(note), "UTF-8");
    }
%>

<%
    int totalQuantity       = 0;
    int closedQuantity      = 0;
    int notClosedQuantity   = 0;

    String message      = request.getParameter("message");
    String clientId     = request.getParameter("client_id");
    String clientName   = request.getParameter("client_name");
    String time         = request.getParameter("time");
    String filter       = request.getParameter("filter");
    String buttonAdd    = clientId != null ? "button--selected" : "";
    String buttonShow   = clientId == null ? "button--selected" : "";

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
        <title>採購單</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/order_base.css">
        <link rel="icon" href="../assets/img/clipboard-list.svg" type="image/svg+xml" />
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
            <a class="button <%= buttonAdd %>" href="select_client.jsp?next=show_orders.jsp">
                <img class="svg" src="../assets/img/clipboard.svg"/>
                顯示訂單
            </a>
            <a class="button <%= buttonShow %>" href="show_orders.jsp">
                <img class="svg" src="../assets/img/clipboard-list.svg"/>
                全部訂單
            </a>
            <a class="button" href="statistics_order.jsp">
                <img class="svg" src="../assets/img/chart-bar.svg"/>
                訂單統計
            </a>
        </div>

        <div class="order-container">
            <table class="order-container__table">
                <thead>
                    <tr class="order-table__row">
                        <th class="order-table__cell" style="width: 2%;">結案</th> 
                        <th class="order-table__cell" style="width: 6%;">訂單交期</th>
                        <th class="order-table__cell" style="width: 12%;">客戶代號/名稱</th>
                        <th class="order-table__cell" style="width: 4%;">珅億<br>訂單<br></th>
                        <th class="order-table__cell" style="width: 4%;">紙箱3323</th>
                        <th class="order-table__cell" style="width: 4%;">原物料3321</th>
                        <th class="order-table__cell" style="width: 3%;">交期</th>
                        <th class="order-table__cell" style="width: 5.5%;">產鈞<br>訂單<br></th>
                        <th class="order-table__cell" style="width: 6%;">採購單<br>發送日期</th>
                        <th class="order-table__cell" style="width: 6%;">採購排程</th>
                        <th class="order-table__cell" style="width: 6%;">客戶單號</th>
                        <th class="order-table__cell" style="width: 5.5%;">單別3303<br>採購單</th>
                        <th class="order-table__cell" style="width: 5.5%;">單別3301<br>製令單</th>
                        <th class="order-table__cell" style="width: 5.5%;">託工單</th>
                        <th class="order-table__cell" style="width: 5%;">訂單數量<br>PCS</th>
                        <th class="order-table__cell" style="width: 12%;">備註</th>
                        <th class="order-table__cell" style="width: 10%;"></th>
                    </tr>  
                </thead>

                <tbody>
                <%
                    Connection connection = null;
                    Statement statement = null;
                    PreparedStatement preparedStatement = null;
                    ResultSet resultSet = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        String url = "jdbc:mysql://localhost:3306/purchase_order_database?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
                        String user = "poc_user_1";
                        String password = "1234";

                        connection = DriverManager.getConnection(url, user, password);
                        statement = connection.createStatement();
                        String command = "SELECT * FROM orders ORDER BY t2c_order_no ASC";
                        preparedStatement = connection.prepareStatement(command);
                        if (clientId != null) {
                            command = "SELECT * FROM orders WHERE client_id = ? ORDER BY t2c_order_no ASC;";
                            preparedStatement = connection.prepareStatement(command);
                            preparedStatement.setString(1, clientId);
                        }
                        resultSet = preparedStatement.executeQuery();

                        while (resultSet.next()) {
                            String isClosed             = resultSet.getString("is_closed").equals("0") ? "X" : "V";
                            boolean boolClosed          = isClosed.equals("V");

                            String orderDueDate         = resultSet.getString("order_due_date");

                            if (time != null && !orderDueDate.startsWith(time)) {
                                continue;
                            }

                            int orderQuantity           = Integer.parseInt(resultSet.getString("order_quantity"));
                            int shippedQuantity         = Integer.parseInt(resultSet.getString("shipped_quantity"));

                            if (boolClosed) {
                                if (shippedQuantity != 0) {
                                    closedQuantity += shippedQuantity;
                                } else {
                                    closedQuantity += orderQuantity;
                                }
                            } else {
                                closedQuantity += shippedQuantity;
                                notClosedQuantity += (orderQuantity - shippedQuantity);
                            }
                            totalQuantity += orderQuantity;

                            if (filter != null && 
                                    ((filter.equals("closed") && !boolClosed) || 
                                    (filter.equals("not_closed") && boolClosed))) {
                                continue;
                            }

                            // if ((filter.equals("closed") && boolClosed)) {
                            //     continue;
                            // }

                            String clientId2            = resultSet.getString("client_id");
                            String t2tOrderNo           = resultSet.getString("t2t_order_no");
                            String tBoxOrderNo          = resultSet.getString("t_box_order_no");
                            String tSourceOrderNo       = resultSet.getString("t_source_order_no");
                            String t2cDueDate           = resultSet.getString("t2c_due_date");
                            String t2cOrderNo           = resultSet.getString("t2c_order_no");
                            String mailSentDate         = resultSet.getString("mail_sent_date");
                            String scheduleSuggestion   = resultSet.getString("schedule_suggestion");
                            String clientOrderNo        = resultSet.getString("client_order_no");
                            String purchaseOrderNo      = resultSet.getString("purchase_order_no");
                            String productionOrderNo    = resultSet.getString("production_order_no");
                            String outsourcingOrderNo   = resultSet.getString("outsourcing_order_no");
                            String note                 = resultSet.getString("note");

                            String editUrl = buildOrderUrl("edit_order.jsp", 
                                    boolClosed, orderDueDate, clientId2, t2tOrderNo, 
                                    tBoxOrderNo, tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                                    mailSentDate, scheduleSuggestion, clientOrderNo, purchaseOrderNo, 
                                    productionOrderNo, outsourcingOrderNo, orderQuantity, shippedQuantity, note);
                            String deleteUrl = buildOrderUrl("remove_order.jsp", 
                                    boolClosed, orderDueDate, clientId2, t2tOrderNo, 
                                    tBoxOrderNo, tSourceOrderNo, t2cDueDate, t2cOrderNo, 
                                    mailSentDate, scheduleSuggestion, clientOrderNo, purchaseOrderNo, 
                                    productionOrderNo, outsourcingOrderNo, orderQuantity, shippedQuantity, note);

                            note = ((shippedQuantity != 0) ? "已出貨量: " + String.valueOf(shippedQuantity) : "") + note;
                            
                            orderDueDate                = orderDueDate.replaceAll("-", "/");
                            t2cDueDate                  = t2cDueDate.substring(t2cDueDate.indexOf('-') + 1).replaceAll("-", "/");
                            mailSentDate                = mailSentDate.replaceAll("-", "/");

                            command = "SELECT client_name FROM clients WHERE client_id = ?";
                            preparedStatement = connection.prepareStatement(command);
                            preparedStatement.setString(1, clientId2);
                            ResultSet nameSet = preparedStatement.executeQuery();
                            if (nameSet.next()) {
                                clientId2 += "<br>" + nameSet.getString("client_name");
                            }
                            nameSet.close();
                            preparedStatement.close();
                %>
                            <tr class="order-table__row">
                                <th class="order-table__cell"><%= isClosed %></th>
                                <th class="order-table__cell"><%= orderDueDate %></th>
                                <th class="order-table__cell"><%= clientId2 %></th>
                                <th class="order-table__cell"><%= t2tOrderNo %></th>
                                <th class="order-table__cell"><%= tBoxOrderNo %></th>
                                <th class="order-table__cell"><%= tSourceOrderNo %></th>
                                <th class="order-table__cell"><%= t2cDueDate %></th>
                                <th class="order-table__cell"><%= t2cOrderNo %></th>
                                <th class="order-table__cell"><%= mailSentDate %></th>
                                <th class="order-table__cell"><%= scheduleSuggestion %></th>
                                <th class="order-table__cell"><%= clientOrderNo %></th>
                                <th class="order-table__cell"><%= purchaseOrderNo %></th>
                                <th class="order-table__cell"><%= productionOrderNo %></th>
                                <th class="order-table__cell"><%= outsourcingOrderNo %></th>
                                <th class="order-table__cell"><%= orderQuantity %></th>
                                <th class="order-table__cell"><%= note %></th>
                                <th class="order-table__cell">
                                    <div class="order-table__cell--actions">
                                        <a class="button" href="<%= editUrl %>">編輯</a>
                                        <a class="button button--danger" href="<%= deleteUrl %>">刪除</a>
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

        <%
            String requestURL = request.getRequestURL().toString() + "?";
            if (clientId != null) {
                requestURL += "client_id=" + clientId + "&";
            }
            if (clientName != null) {
                requestURL += "client_name=" + clientName + "&";
            }
            if (time != null) {
                requestURL += "time=" + time + "&";
            }
        %>

        <form class="time-selector--fixed" method="get" action="show_orders.jsp">
            <input class="time-selector" type="month" name="time" onchange="this.form.submit()"
                    value="<%= request.getParameter("time") != null ? request.getParameter("time") : "" %>">
            <% if (clientId != null) { %>
                <input type="hidden" name="client_id" value="<%= clientId %>">
                <input type="hidden" name="client_name" value="<%= clientName %>">
            <% } %>
        </div>

        <div class="statistics--fixed">
            <a class="button" href="<%= requestURL %>">
                總出貨量: <%= totalQuantity %>
            </a>
            <a class="button" href="<%= requestURL %>&filter=closed">
                已出貨量: <%= closedQuantity %>
            </a>
            <a class="button" href="<%= requestURL %>&filter=not_closed">
                未出貨量: <%= notClosedQuantity %>
            </a>
        </div>
    </body>
</html>
