-- Generado por Oracle SQL Developer Data Modeler 21.2.0.165.1515
--   en:        2021-11-30 16:53:20 CET
--   sitio:      SQL Server 2012
--   tipo:      SQL Server 2012

use master
go


drop database if exists JAIR
go

create database JAIR
go

use JAIR
go

CREATE SCHEMA [JAIR]
GO


CREATE TABLE JAIR.CUSTOMERS 
    (
     CUSTOMER_ID NUMERIC (28) NOT NULL IDENTITY (393 , 1) NOT FOR REPLICATION , 
     EMAIL_ADDRESS VARCHAR (255) NOT NULL , 
     FULL_NAME VARCHAR (255) NOT NULL 
    )
GO 



EXEC sp_addextendedproperty 'MS_Description' , 'Details of the people placing orders' , 'USER' , 'dbo' , 'TABLE' , 'CUSTOMERS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'CUSTOMERS' , 'COLUMN' , 'CUSTOMER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The email address the person uses to access the account' , 'USER' , 'dbo' , 'TABLE' , 'CUSTOMERS' , 'COLUMN' , 'EMAIL_ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What this customer is called' , 'USER' , 'dbo' , 'TABLE' , 'CUSTOMERS' , 'COLUMN' , 'FULL_NAME' 
GO

    


CREATE UNIQUE NONCLUSTERED INDEX 
    CUSTOMERS_EMAIL_U ON JAIR.CUSTOMERS 
    ( 
     EMAIL_ADDRESS 
    ) 
GO 


CREATE NONCLUSTERED INDEX 
    CUSTOMERS_NAME_I ON JAIR.CUSTOMERS 
    ( 
     FULL_NAME 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    CUSTOMERS_PK ON JAIR.CUSTOMERS 
    ( 
     CUSTOMER_ID 
    ) 
GO

ALTER TABLE JAIR.CUSTOMERS ADD CONSTRAINT CUSTOMERS_PK PRIMARY KEY CLUSTERED (CUSTOMER_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE JAIR.CUSTOMERS ADD CONSTRAINT CUSTOMERS_EMAIL_U UNIQUE NONCLUSTERED (EMAIL_ADDRESS)
GO

CREATE TABLE JAIR.INVENTORY 
    (
     INVENTORY_ID NUMERIC (28) NOT NULL IDENTITY (567 , 1) NOT FOR REPLICATION , 
     STORE_ID NUMERIC (28) NOT NULL , 
     PRODUCT_ID NUMERIC (28) NOT NULL , 
     PRODUCT_INVENTORY NUMERIC (28) NOT NULL 
    )
GO 



EXEC sp_addextendedproperty 'MS_Description' , 'Details of the quantity of stock available for products at each location' , 'USER' , 'dbo' , 'TABLE' , 'INVENTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'INVENTORY' , 'COLUMN' , 'INVENTORY_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Which location the goods are located at' , 'USER' , 'dbo' , 'TABLE' , 'INVENTORY' , 'COLUMN' , 'STORE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Which item this stock is for' , 'USER' , 'dbo' , 'TABLE' , 'INVENTORY' , 'COLUMN' , 'PRODUCT_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The current quantity in stock' , 'USER' , 'dbo' , 'TABLE' , 'INVENTORY' , 'COLUMN' , 'PRODUCT_INVENTORY' 
GO

    


CREATE UNIQUE NONCLUSTERED INDEX 
    INVENTORY_PK ON JAIR.INVENTORY 
    ( 
     INVENTORY_ID 
    ) 
GO 


CREATE NONCLUSTERED INDEX 
    INVENTORY_PRODUCT_ID_I ON JAIR.INVENTORY 
    ( 
     PRODUCT_ID 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    INVENTORY_STORE_PRODUCT_U ON JAIR.INVENTORY 
    ( 
     STORE_ID , 
     PRODUCT_ID 
    ) 
GO

ALTER TABLE JAIR.INVENTORY ADD CONSTRAINT INVENTORY_PK PRIMARY KEY CLUSTERED (INVENTORY_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE JAIR.INVENTORY ADD CONSTRAINT INVENTORY_STORE_PRODUCT_U UNIQUE NONCLUSTERED (STORE_ID, PRODUCT_ID)
GO

CREATE TABLE JAIR.ORDER_ITEMS 
    (
     ORDER_ID NUMERIC (28) NOT NULL , 
     LINE_ITEM_ID NUMERIC (28) NOT NULL , 
     PRODUCT_ID NUMERIC (28) NOT NULL , 
     UNIT_PRICE NUMERIC (10,2) NOT NULL , 
     QUANTITY NUMERIC (28) NOT NULL , 
     SHIPMENT_ID NUMERIC (28) 
    )
GO 



EXEC sp_addextendedproperty 'MS_Description' , 'Details of which products the customer has purchased in an order' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The order these products belong to' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'ORDER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'An incrementing number, starting at one for each order' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'LINE_ITEM_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Which item was purchased' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'PRODUCT_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'How much the customer paid for one item of the product' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'UNIT_PRICE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'How many items of this product the customer purchased' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'QUANTITY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Where this product will be delivered' , 'USER' , 'dbo' , 'TABLE' , 'ORDER_ITEMS' , 'COLUMN' , 'SHIPMENT_ID' 
GO

    


CREATE UNIQUE NONCLUSTERED INDEX 
    ORDER_ITEMS_PK ON JAIR.ORDER_ITEMS 
    ( 
     ORDER_ID , 
     LINE_ITEM_ID 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    ORDER_ITEMS_PRODUCT_U ON JAIR.ORDER_ITEMS 
    ( 
     PRODUCT_ID , 
     ORDER_ID 
    ) 
GO 


CREATE NONCLUSTERED INDEX 
    ORDER_ITEMS_SHIPMENT_ID_I ON JAIR.ORDER_ITEMS 
    ( 
     SHIPMENT_ID 
    ) 
GO

ALTER TABLE JAIR.ORDER_ITEMS ADD CONSTRAINT ORDER_ITEMS_PK PRIMARY KEY CLUSTERED (ORDER_ID, LINE_ITEM_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE JAIR.ORDER_ITEMS ADD CONSTRAINT ORDER_ITEMS_PRODUCT_U UNIQUE NONCLUSTERED (PRODUCT_ID, ORDER_ID)
GO

CREATE TABLE JAIR.ORDERS 
    (
     ORDER_ID NUMERIC (28) NOT NULL IDENTITY NOT FOR REPLICATION , 
     ORDER_DATETIME DATETIME NOT NULL , 
     CUSTOMER_ID NUMERIC (28) NOT NULL , 
     ORDER_STATUS VARCHAR (10) NOT NULL , 
     STORE_ID NUMERIC (28) NOT NULL 
    )
GO 


ALTER TABLE JAIR.ORDERS 
    ADD CONSTRAINT ORDERS_STATUS_C 
    CHECK ( ORDER_STATUS IN ('CANCELLED', 'COMPLETE', 'OPEN', 'PAID', 'REFUNDED', 'SHIPPED') ) 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Details of who made purchases where' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' , 'COLUMN' , 'ORDER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'When the order was placed' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' , 'COLUMN' , 'ORDER_DATETIME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Who placed this order' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' , 'COLUMN' , 'CUSTOMER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What state the order is in. Valid values are:
OPEN - the order is in progress
PAID - money has been received from the customer for this order
SHIPPED - the products have been dispatched to the customer
COMPLETE - the customer has received the order
CANCELLED - the customer has stopped the order
REFUNDED - there has been an issue with the order and the money has been returned to the customer' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' , 'COLUMN' , 'ORDER_STATUS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Where this order was placed' , 'USER' , 'dbo' , 'TABLE' , 'ORDERS' , 'COLUMN' , 'STORE_ID' 
GO

    


CREATE NONCLUSTERED INDEX 
    ORDERS_CUSTOMER_ID_I ON JAIR.ORDERS 
    ( 
     CUSTOMER_ID 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    ORDERS_PK ON JAIR.ORDERS 
    ( 
     ORDER_ID 
    ) 
GO 


CREATE NONCLUSTERED INDEX 
    ORDERS_STORE_ID_I ON JAIR.ORDERS 
    ( 
     STORE_ID 
    ) 
GO

ALTER TABLE JAIR.ORDERS ADD CONSTRAINT ORDERS_PK PRIMARY KEY CLUSTERED (ORDER_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE JAIR.PRODUCTS 
    (
     PRODUCT_ID NUMERIC (28) NOT NULL IDENTITY (47 , 1) NOT FOR REPLICATION , 
     PRODUCT_NAME VARCHAR (255) NOT NULL , 
     UNIT_PRICE NUMERIC (10,2) , 
     PRODUCT_DETAILS IMAGE , 
     PRODUCT_IMAGE IMAGE , 
     IMAGE_MIME_TYPE VARCHAR (512) , 
     IMAGE_FILENAME VARCHAR (512) , 
     IMAGE_CHARSET VARCHAR (512) , 
     IMAGE_LAST_UPDATED DATE 
    )
GO 


ALTER TABLE JAIR.PRODUCTS 
    ADD CONSTRAINT PRODUCTS_JSON_C 
    CHECK ( product_details is json ) 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Details of goods that customers can purchase' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'PRODUCT_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What a product is called' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'PRODUCT_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The monetary value of one item of this product' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'UNIT_PRICE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Further details of the product stored in JSON format' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'PRODUCT_DETAILS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'A picture of the product' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'PRODUCT_IMAGE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The mime-type of the product image' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'IMAGE_MIME_TYPE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The name of the file loaded in the image column' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'IMAGE_FILENAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The character set used to encode the image' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'IMAGE_CHARSET' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The date the image was last changed' , 'USER' , 'dbo' , 'TABLE' , 'PRODUCTS' , 'COLUMN' , 'IMAGE_LAST_UPDATED' 
GO

    


CREATE UNIQUE NONCLUSTERED INDEX 
    PRODUCTS_PK ON JAIR.PRODUCTS 
    ( 
     PRODUCT_ID 
    ) 
GO

ALTER TABLE JAIR.PRODUCTS ADD CONSTRAINT PRODUCTS_PK PRIMARY KEY CLUSTERED (PRODUCT_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE JAIR.SHIPMENTS 
    (
     SHIPMENT_ID NUMERIC (28) NOT NULL IDENTITY (2027 , 1) NOT FOR REPLICATION , 
     STORE_ID NUMERIC (28) NOT NULL , 
     CUSTOMER_ID NUMERIC (28) NOT NULL , 
     DELIVERY_ADDRESS VARCHAR (512) NOT NULL , 
     SHIPMENT_STATUS VARCHAR (100) NOT NULL 
    )
GO 


ALTER TABLE JAIR.SHIPMENTS 
    ADD CONSTRAINT SHIPMENT_STATUS_C 
    CHECK ( SHIPMENT_STATUS IN ('CREATED', 'DELIVERED', 'IN-TRANSIT', 'SHIPPED') ) 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Details of where ordered goods will be delivered' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' , 'COLUMN' , 'SHIPMENT_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Which location the goods will be transported from' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' , 'COLUMN' , 'STORE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Who this shipment is for' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' , 'COLUMN' , 'CUSTOMER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Where the goods will be transported to' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' , 'COLUMN' , 'DELIVERY_ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The current status of the shipment. Valid values are: 
CREATED - the shipment is ready for order assignment
SHIPPED - the goods have been dispatched
IN-TRANSIT - the goods are en-route to their destination
DELIVERED - the good have arrived at their destination' , 'USER' , 'dbo' , 'TABLE' , 'SHIPMENTS' , 'COLUMN' , 'SHIPMENT_STATUS' 
GO

    


CREATE NONCLUSTERED INDEX 
    SHIPMENTS_CUSTOMER_ID_I ON JAIR.SHIPMENTS 
    ( 
     CUSTOMER_ID 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    SHIPMENTS_PK ON JAIR.SHIPMENTS 
    ( 
     SHIPMENT_ID 
    ) 
GO 


CREATE NONCLUSTERED INDEX 
    SHIPMENTS_STORE_ID_I ON JAIR.SHIPMENTS 
    ( 
     STORE_ID 
    ) 
GO

ALTER TABLE JAIR.SHIPMENTS ADD CONSTRAINT SHIPMENTS_PK PRIMARY KEY CLUSTERED (SHIPMENT_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE JAIR.STORES 
    (
     STORE_ID NUMERIC (28) NOT NULL IDENTITY (24 , 1) NOT FOR REPLICATION , 
     STORE_NAME VARCHAR (255) NOT NULL , 
     WEB_ADDRESS VARCHAR (100) , 
     PHYSICAL_ADDRESS VARCHAR (512) , 
     LATITUDE NUMERIC (28) , 
     LONGITUDE NUMERIC (28) , 
     LOGO IMAGE , 
     LOGO_MIME_TYPE VARCHAR (512) , 
     LOGO_FILENAME VARCHAR (512) , 
     LOGO_CHARSET VARCHAR (512) , 
     LOGO_LAST_UPDATED DATE 
    )
GO 



EXEC sp_addextendedproperty 'MS_Description' , 'Physical and virtual locations where people can purchase products' , 'USER' , 'dbo' , 'TABLE' , 'STORES' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Auto-incrementing primary key' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'STORE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What the store is called' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'STORE_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The URL of a virtual store' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'WEB_ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The postal address of this location' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'PHYSICAL_ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The north-south position of a physical store' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LATITUDE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The east-west position of a physical store' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LONGITUDE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'An image used by this store' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LOGO' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The mime-type of the store logo' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LOGO_MIME_TYPE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The name of the file loaded in the image column' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LOGO_FILENAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The character set used to encode the image' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LOGO_CHARSET' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The date the image was last changed' , 'USER' , 'dbo' , 'TABLE' , 'STORES' , 'COLUMN' , 'LOGO_LAST_UPDATED' 
GO

    


CREATE UNIQUE NONCLUSTERED INDEX 
    STORE_NAME_U ON JAIR.STORES 
    ( 
     STORE_NAME 
    ) 
GO 


CREATE UNIQUE NONCLUSTERED INDEX 
    STORES_PK ON JAIR.STORES 
    ( 
     STORE_ID 
    ) 
GO

ALTER TABLE JAIR.STORES ADD CONSTRAINT STORES_PK PRIMARY KEY CLUSTERED (STORE_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE JAIR.STORES ADD CONSTRAINT STORE_NAME_U UNIQUE NONCLUSTERED (STORE_NAME)
GO

ALTER TABLE JAIR.STORES ADD CONSTRAINT STORE_AT_LEAST_ONE_ADDRESS_C CHECK (  
    web_address is not null or physical_address is not null
   ) 
GO

ALTER TABLE JAIR.INVENTORY 
    ADD CONSTRAINT INVENTORY_PRODUCT_ID_FK FOREIGN KEY 
    ( 
     PRODUCT_ID
    ) 
    REFERENCES JAIR.PRODUCTS 
    ( 
     PRODUCT_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.INVENTORY 
    ADD CONSTRAINT INVENTORY_STORE_ID_FK FOREIGN KEY 
    ( 
     STORE_ID
    ) 
    REFERENCES JAIR.STORES 
    ( 
     STORE_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.ORDER_ITEMS 
    ADD CONSTRAINT ORDER_ITEMS_ORDER_ID_FK FOREIGN KEY 
    ( 
     ORDER_ID
    ) 
    REFERENCES JAIR.ORDERS 
    ( 
     ORDER_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.ORDER_ITEMS 
    ADD CONSTRAINT ORDER_ITEMS_PRODUCT_ID_FK FOREIGN KEY 
    ( 
     PRODUCT_ID
    ) 
    REFERENCES JAIR.PRODUCTS 
    ( 
     PRODUCT_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.ORDER_ITEMS 
    ADD CONSTRAINT ORDER_ITEMS_SHIPMENT_ID_FK FOREIGN KEY 
    ( 
     SHIPMENT_ID
    ) 
    REFERENCES JAIR.SHIPMENTS 
    ( 
     SHIPMENT_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.ORDERS 
    ADD CONSTRAINT ORDERS_CUSTOMER_ID_FK FOREIGN KEY 
    ( 
     CUSTOMER_ID
    ) 
    REFERENCES JAIR.CUSTOMERS 
    ( 
     CUSTOMER_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.ORDERS 
    ADD CONSTRAINT ORDERS_STORE_ID_FK FOREIGN KEY 
    ( 
     STORE_ID
    ) 
    REFERENCES JAIR.STORES 
    ( 
     STORE_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.SHIPMENTS 
    ADD CONSTRAINT SHIPMENTS_CUSTOMER_ID_FK FOREIGN KEY 
    ( 
     CUSTOMER_ID
    ) 
    REFERENCES JAIR.CUSTOMERS 
    ( 
     CUSTOMER_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE JAIR.SHIPMENTS 
    ADD CONSTRAINT SHIPMENTS_STORE_ID_FK FOREIGN KEY 
    ( 
     STORE_ID
    ) 
    REFERENCES JAIR.STORES 
    ( 
     STORE_ID 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

CREATE OR REPLACE VIEW CUSTOMER_ORDER_PRODUCTS ( ORDER_ID, ORDER_DATETIME, ORDER_STATUS, CUSTOMER_ID, EMAIL_ADDRESS, FULL_NAME, ORDER_TOTAL, ITEMS ) AS
select o.order_id, o.order_datetime, o.order_status, 
         c.customer_id, c.email_address, c.full_name, 
         sum ( oi.quantity * oi.unit_price ) order_total,
         listagg (
           p.product_name, ', ' 
           on overflow truncate '...' with count
         ) within group ( order by oi.line_item_id ) items
  from   orders o
  join   order_items oi
  on     o.order_id = oi.order_id
  join   customers c
  on     o.customer_id = c.customer_id
  join   products p
  on     oi.product_id = p.product_id
  group  by o.order_id, o.order_datetime, o.order_status, 
         c.customer_id, c.email_address, c.full_name 
GO






EXEC sp_addextendedproperty 'MS_Description' , 'A summary of who placed each order and what they bought' , 'USER' , 'dbo' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The primary key of the order' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'ORDER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The date and time the order was placed' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'ORDER_DATETIME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The current state of this order' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'ORDER_STATUS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The primary key of the customer' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'CUSTOMER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The email address the person uses to access the account' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'EMAIL_ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What this customer is called' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'FULL_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The total amount the customer paid for the order' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'ORDER_TOTAL' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'A comma-separated list naming the products in this order' , 'VIEW' , 'CUSTOMER_ORDER_PRODUCTS' , 'COLUMN' , 'ITEMS' 
GO

CREATE OR REPLACE VIEW PRODUCT_ORDERS ( PRODUCT_NAME, ORDER_STATUS, TOTAL_SALES, ORDER_COUNT ) AS
select p.product_name, o.order_status, 
         sum ( oi.quantity * oi.unit_price ) total_sales,
         count (*) order_count
  from   orders o
  join   order_items oi
  on     o.order_id = oi.order_id
  join   customers c
  on     o.customer_id = c.customer_id
  join   products p
  on     oi.product_id = p.product_id
  group  by p.product_name, o.order_status 
GO






EXEC sp_addextendedproperty 'MS_Description' , 'A summary of the state of the orders placed for each product' , 'USER' , 'dbo' , 'VIEW' , 'PRODUCT_ORDERS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What this product is called' , 'VIEW' , 'PRODUCT_ORDERS' , 'COLUMN' , 'PRODUCT_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The current state of these order' , 'VIEW' , 'PRODUCT_ORDERS' , 'COLUMN' , 'ORDER_STATUS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The total value of orders placed' , 'VIEW' , 'PRODUCT_ORDERS' , 'COLUMN' , 'TOTAL_SALES' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The total number of orders placed' , 'VIEW' , 'PRODUCT_ORDERS' , 'COLUMN' , 'ORDER_COUNT' 
GO

CREATE OR REPLACE VIEW PRODUCT_REVIEWS ( PRODUCT_NAME, RATING, AVG_RATING, REVIEW ) AS
select p.product_name, r.rating, 
         round ( 
           avg ( r.rating ) over (
             partition by product_name
           ),
           2
         ) avg_rating,
         r.review
  from   products p,
         json_table (
           p.product_details, '$'
           columns ( 
             nested path '$.reviews[*]'
             columns (
               rating integer path '$.rating',
               review varchar2(4000) path '$.review'
             )
           )
         ) r 
GO






EXEC sp_addextendedproperty 'MS_Description' , 'A relational view of the reviews stored in the JSON for each product' , 'USER' , 'dbo' , 'VIEW' , 'PRODUCT_REVIEWS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What this product is called' , 'VIEW' , 'PRODUCT_REVIEWS' , 'COLUMN' , 'PRODUCT_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The review score the customer has placed. Range is 1-10' , 'VIEW' , 'PRODUCT_REVIEWS' , 'COLUMN' , 'RATING' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The mean of the review scores for this product' , 'VIEW' , 'PRODUCT_REVIEWS' , 'COLUMN' , 'AVG_RATING' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The text of the review' , 'VIEW' , 'PRODUCT_REVIEWS' , 'COLUMN' , 'REVIEW' 
GO

CREATE OR REPLACE VIEW STORE_ORDERS ( TOTAL, STORE_NAME, ADDRESS, LATITUDE, LONGITUDE, ORDER_STATUS, ORDER_COUNT, TOTAL_SALES ) AS
select case
           grouping_id ( store_name, order_status ) 
           when 1 then 'STORE TOTAL'
           when 2 then 'STATUS TOTAL'
           when 3 then 'GRAND TOTAL'
         end total,
         s.store_name, 
         coalesce ( s.web_address, s.physical_address ) address,
         s.latitude, s.longitude,
         o.order_status,
         count ( distinct o.order_id ) order_count,
         sum ( oi.quantity * oi.unit_price ) total_sales
  from   stores s
  join   orders o
  on     s.store_id = o.store_id
  join   order_items oi
  on     o.order_id = oi.order_id
  group  by grouping sets ( 
    ( s.store_name, coalesce ( s.web_address, s.physical_address ), s.latitude, s.longitude ),
    ( s.store_name, coalesce ( s.web_address, s.physical_address ), s.latitude, s.longitude, o.order_status ),
    o.order_status, 
    ()
  ) 
GO






EXEC sp_addextendedproperty 'MS_Description' , 'A summary of what was purchased at each location, including summaries each store, order status and overall total' , 'USER' , 'dbo' , 'VIEW' , 'STORE_ORDERS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Indicates what type of total is displayed, including Store, Status, or Grand Totals' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'TOTAL' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'What the store is called' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'STORE_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The physical or virtual location of this store' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'ADDRESS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The north-south position of a physical store' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'LATITUDE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The east-west position of a physical store' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'LONGITUDE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The current state of this order' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'ORDER_STATUS' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The total number of orders placed' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'ORDER_COUNT' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The total value of orders placed' , 'VIEW' , 'STORE_ORDERS' , 'COLUMN' , 'TOTAL_SALES' 
GO



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                            18
-- ALTER TABLE                             24
-- CREATE VIEW                              4
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
-- 
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
