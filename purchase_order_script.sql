create database if not exists purchase_order_database character set utf8mb4 collate utf8mb4_unicode_ci;
use purchase_order_database;

-- t = 台灣orders
-- c = 大陸

create table if not exists clients (  -- 客戶
    client_id varchar(20) not null primary key,  -- 客戶代號
    client_name varchar(40) not null  -- 公司名稱
);

create table if not exists orders (  -- 訂單
    is_closed boolean not null,  -- 結案
    order_due_date date not null,  -- 訂單交期
    client_id varchar(20) not null,  -- 客戶代號
    client_name varchar(40) not null,  -- 客戶名稱
    t2t_order_no varchar(20),  -- 業務給台灣的訂單單號
    t_box_order_no varchar(20),  -- 台灣的採購單單號
    t_source_order_no varchar(20),  -- 台灣的採購單單號
    t2c_due_date date not null,  -- 台灣給大陸的訂單交期
    t2c_order_no varchar(20) not null primary key,  -- 台灣給大陸的訂單單號
    mail_sent_date date not null,  -- 郵件發送日期
    schedule_suggestion varchar(20) not null,  -- 排程建議(?
    client_order_no varchar(20) not null,  -- 客戶給的訂單單號
    purchase_order_no varchar(20) not null,  -- 採購單單號
    production_order_no varchar(20) not null,  -- 製令單號
    outsourcing_order_no varchar(20) not null,  -- 託工單號
    order_quantity int not null,  -- 訂單數量
    note varchar(120),  -- 備註
    
    foreign key (client_id) references clients(client_id)  -- 客戶代號
);

ALTER TABLE orders ADD COLUMN shipped_quantity INT DEFAULT 0 AFTER order_quantity;
