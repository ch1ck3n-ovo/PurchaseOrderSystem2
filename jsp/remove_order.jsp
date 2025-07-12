
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>

<%!
    private <T> T requireNonNullElse(T obj, T defaultObj) {
        return (obj != null) ? obj : defaultObj;
    }
    private java.sql.Date getDateOrDefault(HttpServletRequest request, String paramName, java.time.LocalDate defaultDate) {
        String param = request.getParameter(paramName);
        return (param != null) ? java.sql.Date.valueOf(param) : java.sql.Date.valueOf(defaultDate);
    }
%>

<%
    java.time.LocalDate today   = java.time.LocalDate.now();
    String message              = request.getParameter("message");
    boolean isClosed            = Boolean.valueOf(request.getParameter("is_closed"));

    java.sql.Date orderDueDate  = getDateOrDefault(request, "order_due_date", today);
    java.sql.Date t2cDueDate    = getDateOrDefault(request, "t2c_due_date", today);
    java.sql.Date mailSentDate  = getDateOrDefault(request, "mail_sent_date", today);
    
    String clientId             = requireNonNullElse(request.getParameter("client_id"), "C");
    if (clientId.equals("C")) {
        response.sendRedirect("show_orders.jsp");
        return;
    }

    String clientName           = requireNonNullElse(request.getParameter("client_name"), "");
    String t2tOrderNo           = requireNonNullElse(request.getParameter("t2t_order_no"), "");
    String tBoxOrderNo          = requireNonNullElse(request.getParameter("t_box_order_no"), "");
    String tSourceOrderNo       = requireNonNullElse(request.getParameter("t_source_order_no"), "");
    String t2cOrderNo           = requireNonNullElse(request.getParameter("t2c_order_no"), "");
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

    function updateText(src, dest) {
        const source = document.getElementsByName(src)[0];
        const target = document.getElementsByName(dest)[0];
        if (source && target) {
            target.value = source.value.replace(/-/g, '');
        }
    }
</script>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>刪除訂單</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/form_base.css">
        <link rel="icon" href="../assets/img/clipboard-x.svg" type="image/svg+xml" />
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
            <a class="button button--selected" href="select_client.jsp?next=show_orders.jsp">
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

        <form action="../sql/delete_order.jsp" method="post">
            <div style="display: flex;">
                <div class="form-container">
                    <div class="form-header">
                        <h1>刪除訂單</h1>
                    </div>
                    <div class="form-field">
                        <div class="form-label">結案</div>
                        <input class="toggle-switch" type="checkbox" name="is_closed" <%= isClosed ? "checked" : "" %> disabled>
                    </div>
                    <div class="form-field">
                        <div class="form-label">訂單交期 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--date margin-left" type="date" name="order_due_date" value="<%= orderDueDate != null ? orderDueDate : today %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">客戶代號 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="client_id" value="<%= clientId %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">客戶名稱 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="" value="<%= clientName %>" maxlength="20" readonly>
                    </div>
                    <div class="form-field"> 
                        <div class="form-label">珅億訂單單號</div>
                        <input class="input input--text margin-left" type="text" name="t2t_order_no" value="<%= t2tOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">珅億採購單號(紙箱3323)</div>
                        <input class="input input--text margin-left" type="text" name="t_box_order_no" value="<%= tBoxOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">珅億採購單號(原物料3321)</div>
                        <input class="input input--text margin-left" type="text" name="t_source_order_no" value="<%= tSourceOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">訂單數量(PCS) <span style="color: #ff0000;">*</span></div>
                        <input class="input input--number margin-left" type="number" name="order_quantity" min="0" max="9999999" value="<%= orderQuantity %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">⭢ 已出貨量(PCS)</div>
                        <input class="input input--number margin-left" type="number" name="shipped_quantity" min="0" max="9999999" value="<%= shippedQuantity %>" readonly>
                    </div>
                </div>

                <div class="form-container">
                    <div class="form-header" style="height: 88.88px;">
                        <h1>&nbsp;</h1>
                    </div>
                    <div class="form-field">
                        <div class="form-label">交期 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--date margin-left" type="date" name="t2c_due_date" value="<%= t2cDueDate != null ? t2cDueDate : today %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">產鈞訂單單號 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="t2c_order_no" value="<%= t2cOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">採購單發送日期 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--date margin-left" type="date" name="mail_sent_date" value="<%= mailSentDate != null ? mailSentDate : today %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">排程採購建議 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="schedule_suggestion" value="<%= scheduleSuggestion %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">客戶單號 <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="client_order_no" value="<%= clientOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">採購單號(單別3303) <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="purchase_order_no" value="<%= purchaseOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">製令單號(單別3301) <span style="color: #ff0000;">*</span></div>
                        <input class="input input--text margin-left" type="text" name="production_order_no" value="<%= productionOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">託工單號</div>
                        <input class="input input--text margin-left" type="text" name="outsourcing_order_no" value="<%= outsourcingOrderNo %>" readonly>
                    </div>
                    <div class="form-field">
                        <div class="form-label">備註</div>
                        <input class="input input--text margin-left" type="text" name="note" value="<%= note %>" readonly>
                    </div>
                    <input class="button button--round button--danger" type="submit" value="刪除">
                </div>
            </div>
        </form>
    </body>
</html>
