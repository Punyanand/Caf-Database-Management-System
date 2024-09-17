set search_path to 'cafe';

/*
 Project BAUN 6320 - UTD
*/

/* DROP statements to clean up objects from previous run */

-- Triggers
DROP TRIGGER IF EXISTS TRG_cafe_store_store_id ON cafe_store;
DROP TRIGGER IF EXISTS TRG_orders_order_id ON orders;
DROP TRIGGER IF EXISTS TRG_purchase_detail_purchase_id ON purchase_detail;
DROP TRIGGER IF EXISTS TRG_product_product_id ON product;

-- Trigger Functions
DROP FUNCTION IF EXISTS TRG_cafe_store_store_id_function();
DROP FUNCTION IF EXISTS TRG_orders_order_id_function();
DROP FUNCTION IF EXISTS TRG_purchase_detail_purchase_id_function();
DROP FUNCTION IF EXISTS TRG_product_product_id_function();

-- Sequences
DROP SEQUENCE IF EXISTS SEQ_cafe_store_store_id;
DROP SEQUENCE IF EXISTS SEQ_orders_order_id;
DROP SEQUENCE IF EXISTS SEQ_purchase_detail_purchase_id;
DROP SEQUENCE IF EXISTS SEQ_product_product_id;

-- Indices
DROP INDEX IF EXISTS IDX_cafe_store_store_id;

DROP INDEX IF EXISTS IDX_orders_order_id;

DROP INDEX IF EXISTS IDX_orders_FK_cafe_store_pk_store_id;

DROP INDEX IF EXISTS IDX_purchase_detail_purchase_id;

DROP INDEX IF EXISTS IDX_product_product_id;

DROP INDEX IF EXISTS IDX_product_FK_purchase_detail_pk_purchase_id;

DROP INDEX IF EXISTS IDX_order_detail_FK_order_pk_order_id;
DROP INDEX IF EXISTS IDX_order_detail_FK_product_pk_product_id;

-- Tables
DROP TABLE IF EXISTS order_detail;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS purchase_detail;
DROP TABLE IF EXISTS cafe_store;

/* Create Sequences */
CREATE SEQUENCE SEQ_cafe_store_store_id
    START 100
    INCREMENT 100;

CREATE SEQUENCE SEQ_orders_order_id
    START 1
    INCREMENT 1;

CREATE SEQUENCE SEQ_purchase_detail_purchase_id
    START 10
    INCREMENT 5;
	
CREATE SEQUENCE SEQ_product_product_id
    START 10
    INCREMENT 10;
		

/* Create tables based on entities */

CREATE TABLE cafe_store(
	store_id		INTEGER NOT NULL,
	store_manager	VARCHAR(30) NOT NULL,
	store_capacity	INTEGER NOT NULL,
	phone 			NUMERIC(10,0) NOT NULL,
	street_address  VARCHAR(50) NOT NULL,
	city 			VARCHAR(30) NOT NULL,
	state 			VARCHAR(2) NOT NULL,
	zip 			VARCHAR(5) NOT NULL,
	
	CONSTRAINT PK_cafe_store PRIMARY KEY (store_id)
);

CREATE TABLE orders(
	order_id		INTEGER NOT NULL,
	order_tax		NUMERIC(10, 2) NOT NULL,
	order_tip		NUMERIC(10, 2) NOT NULL,
	order_total		NUMERIC(10, 2) NOT NULL,
	date_and_time   DATE NOT NULL,
	FK_cafe_store_pk_store_id INTEGER NOT NULL,
	
	CONSTRAINT PK_order_id PRIMARY KEY (order_id),
	CONSTRAINT FK_cafe_store FOREIGN KEY (FK_cafe_store_pk_store_id) REFERENCES cafe_store(store_id)
);

CREATE TABLE purchase_detail(
	purchase_id 	INTEGER NOT NULL,
	unit_price 		NUMERIC(10, 2) NOT NULL,
	order_date 		DATE NOT NULL,
	quantity 		NUMERIC(10, 2) NOT NULL,
	total_price 	NUMERIC(15, 2) NOT NULL,
	CONSTRAINT PK_purchase_detail PRIMARY KEY (purchase_id)
);

CREATE TABLE product(
	product_id 		INTEGER NOT NULL,
	product_name 	VARCHAR(25) NOT NULL,
	product_price NUMERIC(10, 2) NOT NULL,
	product_category VARCHAR(30) NOT NULL,
	product_description VARCHAR(255) NOT NULL,
	FK_purchase_detail_pk_purchase_id INTEGER NOT NULL,
	
	CONSTRAINT PK_product_id PRIMARY KEY (product_id),
	CONSTRAINT FK_purchase_detail FOREIGN KEY (FK_purchase_detail_pk_purchase_id) REFERENCES purchase_detail(purchase_id)
);

CREATE TABLE order_detail(
	FK_order_pk_order_id INTEGER NOT NULL,
	FK_product_pk_product_id INTEGER NOT NULL,
	order_special_info VARCHAR(100),
	order_quantity INTEGER NOT NULL,
	order_discount DECIMAL(4, 2),
	order_prep_time INTERVAL NOT NULL,
	order_size VARCHAR(10) NOT NULL,
	
	CONSTRAINT PK_order_detail PRIMARY KEY (FK_order_pk_order_id, FK_product_pk_product_id),
	CONSTRAINT FK_orders FOREIGN KEY (FK_order_pk_order_id) REFERENCES orders(order_id),
	CONSTRAINT FK_products FOREIGN KEY (FK_product_pk_product_id) REFERENCES product(product_id)
);

/* Create Trigger Functions */
CREATE OR REPLACE FUNCTION TRG_cafe_store_store_id_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.store_id IS NULL THEN
            NEW.store_id := NEXTVAL('SEQ_cafe_store_store_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TRG_orders_order_id_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.order_id IS NULL THEN
            NEW.order_id := NEXTVAL('SEQ_orders_order_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TRG_purchase_detail_purchase_id_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.purchase_id IS NULL THEN
            NEW.purchase_id := NEXTVAL('SEQ_purchase_detail_purchase_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION TRG_product_product_id_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.product_id IS NULL THEN
            NEW.product_id := NEXTVAL('SEQ_product_product_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create Triggers */

CREATE TRIGGER TRG_cafe_store_store_id
BEFORE INSERT OR UPDATE OF store_id ON cafe_store
FOR EACH ROW
EXECUTE FUNCTION TRG_cafe_store_store_id_function();

CREATE TRIGGER TRG_orders_order_id
BEFORE INSERT OR UPDATE OF order_id ON orders
FOR EACH ROW
EXECUTE FUNCTION TRG_orders_order_id_function();

CREATE TRIGGER TRG_purchase_detail_purchase_id
BEFORE INSERT OR UPDATE OF purchase_id ON purchase_detail
FOR EACH ROW
EXECUTE FUNCTION TRG_purchase_detail_purchase_id_function();

CREATE TRIGGER TRG_product_product_id
BEFORE INSERT OR UPDATE OF product_id ON product
FOR EACH ROW
EXECUTE FUNCTION TRG_product_product_id_function();



/* Create indices for natural keys, foreign keys, and frequently-queried columns */	

-- cafe_store
--  Primary Key
CREATE INDEX IDX_cafe_store_store_id ON cafe_store(store_id);
-- orders
--  Primary Key
CREATE INDEX IDX_orders_order_id ON orders(order_id);
--  Foreign Key
CREATE INDEX IDX_orders_FK_cafe_store_pk_store_id ON orders(FK_cafe_store_pk_store_id);

-- purchase_detail
--  Primary Key
CREATE INDEX IDX_purchase_detail_purchase_id ON purchase_detail(purchase_id);

-- product
--  Primary Key
CREATE INDEX IDX_product_product_id ON product(product_id);
--  Foreign Key
CREATE INDEX IDX_product_FK_purchase_detail_pk_purchase_id ON product(FK_purchase_detail_pk_purchase_id);

-- order_detail
-- Primary Key / Foreign Key
CREATE INDEX IDX_order_detail_FK_order_pk_order_id ON order_detail(FK_order_pk_order_id);
CREATE INDEX IDX_order_detail_FK_product_pk_product_id ON order_detail(FK_product_pk_product_id);
	

