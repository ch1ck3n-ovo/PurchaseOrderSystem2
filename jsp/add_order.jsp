
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
    java.time.LocalDate today = java.time.LocalDate.now();
    String message = request.getParameter("message");
    boolean isClosed = request.getParameter("is_closed") != null ? request.getParameter("is_closed").equals("true") : false;

    java.sql.Date orderDueDate  = getDateOrDefault(request, "order_due_date", today);
    java.sql.Date t2cDueDate    = getDateOrDefault(request, "t2c_due_date", today);
    java.sql.Date mailSentDate  = getDateOrDefault(request, "mail_sent_date", today);
    
    String clientId             = Objects.requireNonNullElse(request.getParameter("client_id"), "C");
    if (clientId.equals("C")) {
        response.sendRedirect("select_client.jsp?next=add_order.jsp");
        return;
    }

    String clientName           = Objects.requireNonNullElse(request.getParameter("client_name"), "");
    String t2tOrderNo           = Objects.requireNonNullElse(request.getParameter("t2t_order_no"), "");
    String tBoxOrderNo          = Objects.requireNonNullElse(request.getParameter("t_box_order_no"), "");
    String tSourceOrderNo       = Objects.requireNonNullElse(request.getParameter("t_source_order_no"), "");
    String t2cOrderNo           = Objects.requireNonNullElse(request.getParameter("t2c_order_no"), "");
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

    if (message != null) {
    %>
    <script>
        alert('<%= 
                message.replace("\\", "\\\\")
                        .replace("'", "\\'")
                        .replace("\"", "\\\"")
                        .replace("\n", "\\n")
                        .replace("\r", "") 
        %>');
    </script>
    <%
    }
%>

<script>
    history.replaceState(null, '', window.location.pathname);

    function updateText(src, dest, amount = null) {
        const source = document.getElementsByName(src)[0];
        const target = document.getElementsByName(dest)[0];
        if (source && target) {
            const cleaned = source.value.replace(/-/g, '');
            target.value = amount != null ? cleaned.substring(0, amount) : cleaned;
        }
    }

    function rotateIcon(button) {
        const icon = button.querySelector('.img--rotatable');

        // 設定旋轉角度
        icon.style.transition = 'all 0.6s ease';
        icon.style.transform = 'rotate(360deg)';

        // 等待動畫結束後把 transform 清除，角度重置回原點
        icon.addEventListener('transitionend', function handleTransition() {
            icon.style.transition = 'none';
            icon.style.transform = 'none'; // 回到原本位置
            icon.removeEventListener('transitionend', handleTransition); // 清掉事件，避免疊加
        });
    }
</script>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>新增訂單</title>
        <link rel="stylesheet" href="../assets/css/global.css">
        <link rel="stylesheet" href="../assets/css/form_base.css">
        <link rel="icon" href="../assets/img/clipboard-plus.svg" type="image/svg+xml" />
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
            <a class="button button--selected" href="select_client.jsp?next=add_order.jsp">
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
                <h1>新增訂單</h1>
            </div>
            <form action="../sql/insert_order.jsp" method="post">
                <div class="form-field">
                    <div class="form-label">結案</div>
                    <input class="toggle-switch" type="checkbox" name="is_closed" <%= isClosed ? "checked" : "" %>>
                </div>
                <div class="form-field">
                    <div class="form-label">訂單交期 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--date margin-left" type="date" name="order_due_date" value="<%= orderDueDate != null ? orderDueDate : today %>" required>
                </div>
                <div class="form-field">
                    <div class="form-label">客戶代號 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--text margin-left" type="text" name="client_id" value="<%= clientId %>" maxlength="20" required readonly>
                </div>
                <div class="form-field">
                    <div class="form-label">客戶名稱 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--text margin-left" type="text" name="" value="<%= clientName %>" maxlength="20" required readonly>
                </div>
                <div class="form-field"> 
                    <div class="form-label">珅億訂單單號</div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('t2c_order_no', 't2t_order_no')">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="t2t_order_no" value="<%= t2tOrderNo %>" maxlength="20" 
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')">
                </div>
                <div class="form-field">
                    <div class="form-label">珅億採購單號(紙箱3323)</div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('t2c_order_no', 't_box_order_no')">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="t_box_order_no" value="<%= tBoxOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')">
                </div>
                <div class="form-field">
                    <div class="form-label">珅億採購單號(原物料3321)</div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('t2c_order_no', 't_source_order_no')">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="t_source_order_no" value="<%= tSourceOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')">
                </div>
                <div class="form-field">
                    <div class="form-label">交期 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--date margin-left" type="date" name="t2c_due_date" value="<%= t2cDueDate != null ? t2cDueDate : today %>" required>
                </div>
                <div class="form-field">
                    <div class="form-label">產鈞訂單單號 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--text margin-left" type="text" name="t2c_order_no" value="<%= t2cOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')" required>
                </div>
                <div class="form-field">
                    <div class="form-label">採購單發送日期 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--date margin-left" type="date" name="mail_sent_date" value="<%= mailSentDate != null ? mailSentDate : today %>" required>
                </div>
                <div class="form-field">
                    <div class="form-label">排程採購建議 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--text margin-left" type="text" name="schedule_suggestion" value="<%= scheduleSuggestion %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')" required>
                </div>
                <div class="form-field">
                    <div class="form-label">客戶單號 <span style="color: #ff0000;">*</span></div>
                    <input class="input input--text margin-left" type="text" name="client_order_no" value="<%= clientOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^a-zA-Z0-9\-]/g, '')" required>
                </div>
                <div class="form-field">
                    <div class="form-label">採購單號(單別3303) <span style="color: #ff0000;">*</span></div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('schedule_suggestion', 'purchase_order_no', 8)">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="purchase_order_no" value="<%= purchaseOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')" required>
                </div>
                <div class="form-field">
                    <div class="form-label">製令單號(單別3301) <span style="color: #ff0000;">*</span></div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('schedule_suggestion', 'production_order_no', 8)">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="production_order_no" value="<%= productionOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')" required>
                </div>
                <div class="form-field">
                    <div class="form-label">託工單號</div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('schedule_suggestion', 'outsourcing_order_no', 8)">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--text" type="text" name="outsourcing_order_no" value="<%= outsourcingOrderNo %>" maxlength="20"
                            oninput="this.value = this.value.replace(/[^0-9\-]/g, '')">
                </div>
                <div class="form-field">
                    <div class="form-label">訂單數量(PCS) <span style="color: #ff0000;">*</span></div>
                    <input class="input input--number margin-left" type="number" name="order_quantity" min="0" max="9999999" value="<%= orderQuantity %>" required>
                </div>
                <div class="form-field">
                    <div class="form-label">⭢ 已出貨量(PCS)</div>
                    <button type="button" class="button--reload margin-left" onclick="rotateIcon(this); updateText('order_quantity', 'shipped_quantity', 7)">
                        <img class="img--rotatable" src="../assets/img/rotate-cw.svg"/>
                    </button>
                    <input class="input input--number" type="number" name="shipped_quantity" min="0" max="9999999" value="<%= shippedQuantity %>">
                </div>
                <div class="form-field">
                    <div class="form-label">備註</div>
                    <input class="input input--text margin-left" type="text" name="note" value="<%= note %>" maxlength="60">
                </div>
                <input class="button button--round" type="submit" value="送出">
            </form>
        </div>
    </body>
</html>
