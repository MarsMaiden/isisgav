DROP DATABASE IF EXISTS db_isisgav;

CREATE DATABASE db_isisgav;
--  SQLINES DEMO *** GAV

USE db_isisgav;
 
DROP TABLE IF EXISTS articulo;
CREATE TABLE articulo (
    id_articulo INT PRIMARY KEY AUTO_INCREMENT,
    cod_art VARCHAR(8),
    nom_art VARCHAR(50),
    marca_art VARCHAR(20),
    id_categoria INT,
    desc_art VARCHAR(80),
    precio_venta DECIMAL(6 , 2 )
);

DROP TABLE IF EXISTS boleta;
CREATE TABLE boleta (
	id_boleta INT PRIMARY KEY AUTO_INCREMENT,
    cod_bol VARCHAR(8),
    id_venta INT
);

DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    cod_cat VARCHAR(8),
    desc_cat VARCHAR(25)
);

DROP TABLE IF EXISTS cliente;
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cod_cli VARCHAR(8),
    dir_cli VARCHAR(80),
    ruc_cli DECIMAL(11,0),
    correo_cli VARCHAR(50),
    tel_cli VARCHAR(9)
);

DROP TABLE IF EXISTS compra;
CREATE TABLE compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    cod_compra VARCHAR(8),
    id_empleado INT,
    id_proveedor INT,
	id_factura VARCHAR(13),
    fecha_compra DATE,
    importe_compra DECIMAL(9 , 2 )
);

DROP TABLE IF EXISTS detalle_compra;
CREATE TABLE detalle_compra (
	id_detalle_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT,
    id_articulo INT,
    cant_compra INT,
    precio_compra DECIMAL(9 , 2 )
);

DROP TABLE IF EXISTS detalle_venta;
CREATE TABLE detalle_venta (
	id_detalle_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT,
    id_articulo INT,
    cant_venta INT
);

DROP TABLE IF EXISTS empleado;
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    cod_emp VARCHAR(8),
    dni_emp INT,
    nom_emp VARCHAR(18),
    ape_emp VARCHAR(18),
    tel_emp VARCHAR(9),
    correo_emp VARCHAR(50),
    dir_emp VARCHAR(80)
);

DROP TABLE IF EXISTS factura;
CREATE TABLE factura (
	id_factura INT PRIMARY KEY AUTO_INCREMENT,
    cod_fac VARCHAR(8),
    id_venta INT
);

DROP TABLE IF EXISTS forma_pago;
CREATE TABLE forma_pago (
    id_pago INT PRIMARY KEY,
    desc_pago VARCHAR(15)
);

DROP TABLE IF EXISTS kardex;
CREATE TABLE kardex (
    id_kardex INT PRIMARY KEY AUTO_INCREMENT,
    fecha_kardex DATE,
    stock_actual INT,
    valor_stock_actual DECIMAL(9 , 2 ),
    id_articulo INT,
    id_compra INT,
    id_venta INT
);

DROP TABLE IF EXISTS persona_juridica;
CREATE TABLE persona_juridica (
    id_cliente INT,
    nombre_comercial VARCHAR(80)
);

DROP TABLE IF EXISTS persona_natural;
CREATE TABLE persona_natural (
    id_cliente INT,
    nom_cli VARCHAR(20),
    ape_cli VARCHAR(20),
    dni_cli INT
);

DROP TABLE IF EXISTS proveedor;
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    cod_prov VARCHAR(9),
    ruc_prov DECIMAL(11,0),
    razon_social VARCHAR(80),
    dir_prov VARCHAR(80),
    tel_prov VARCHAR(9),
    correo_prov VARCHAR(50)
);

DROP TABLE IF EXISTS tipo_usuario;
CREATE TABLE tipo_usuario (
    id_tipouser INT PRIMARY KEY AUTO_INCREMENT,
    desc_user VARCHAR(15)
);

DROP TABLE IF EXISTS usuario;
CREATE TABLE usuario(
	id_usuario INT PRIMARY KEY AUTO_INCREMENT,
	id_empleado int,
    usuario varchar(20),
    pass varchar(80)
);

DROP TABLE IF EXISTS usuario_roles;
CREATE TABLE usuario_roles (
	id_usuario int,
	id_tipouser int
);

DROP TABLE IF EXISTS venta;
CREATE TABLE venta (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    cod_ven VARCHAR(8),
    id_empleado INT,
    id_cliente INT,
    id_pago INT,
    id_comprobante_pago int,
    fecha_venta DATE,
    sub_total DECIMAL(7,2),
    igv DECIMAL(7 , 2 ),
    descuento DECIMAL(5 , 2 ) DEFAULT 0,
    importe_venta DECIMAL(7 , 2 )
);



alter table articulo
add foreign key (id_categoria) references categoria(id_categoria),
ADD FULLTEXT INDEX `Full_Text_idx` (`nom_art`, `marca_art`) VISIBLE;

alter table boleta
add foreign key (id_venta) references venta(id_venta);

alter table compra
add foreign key (id_empleado) references empleado(id_empleado),
add foreign key (id_proveedor) references proveedor(id_proveedor);

alter table detalle_compra
add foreign key (id_compra) references Compra(id_compra),
add foreign key (id_articulo) references articulo(id_articulo);

alter table detalle_venta
add foreign key (id_venta) references venta(id_venta),
add foreign key (id_articulo) references articulo(id_articulo);

alter table factura
add foreign key (id_venta) references venta(id_venta);

alter table kardex
add foreign key (id_articulo) references articulo(id_articulo),
add foreign key (id_compra) references compra(id_compra),
add foreign key (id_venta) references Venta(id_venta);

alter table persona_juridica
add foreign key (id_cliente) references cliente(id_cliente);

alter table persona_natural
add foreign key (id_cliente) references cliente(id_cliente);

alter table usuario
add foreign key (id_empleado) references empleado(id_empleado);

alter table usuario_roles
add foreign key (id_usuario) references usuario(id_usuario),
add foreign key (id_tipouser) references tipo_usuario(id_tipouser);

alter table venta
add foreign key (id_empleado) references empleado(id_empleado),
add foreign key (id_cliente) references cliente(id_cliente),
add foreign key (id_pago) references forma_pago(id_pago);

DROP TRIGGER IF EXISTS insert_cod_art;
DELIMITER $$
CREATE TRIGGER insert_cod_art BEFORE INSERT ON articulo FOR EACH ROW
BEGIN
	SET @COD_ART = CONCAT('ART-', LPAD((SELECT MAX(id_articulo) from articulo) + 1 , 4, '0'));
	IF @COD_ART IS NULL THEN
		SET NEW.COD_ART = 'ART-0001';
	ELSE
		SET NEW.COD_ART = @COD_ART;
    END IF; 
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_bol;
DELIMITER $$
CREATE TRIGGER insert_cod_bol BEFORE INSERT ON boleta FOR EACH ROW
BEGIN
	SET @COD_BOL = CONCAT('BOL-', LPAD((SELECT MAX(id_boleta) from boleta) + 1 , 4, '0'));	
	IF @COD_BOL IS NULL THEN
		SET NEW.COD_BOL = 'BOL-0001';
    ELSE
		SET NEW.COD_BOL = @COD_BOL;
    END IF; 
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_cat;
DELIMITER $$
CREATE TRIGGER insert_cod_cat BEFORE INSERT ON categoria FOR EACH ROW
BEGIN
	SET @COD_CAT = CONCAT('CAT-', LPAD((SELECT MAX(id_categoria) from categoria) + 1 , 4, '0'));
    IF @COD_CAT IS NULL THEN
		SET NEW.COD_CAT = 'CAT-0001';
	ELSE
		SET NEW.COD_CAT = @COD_CAT;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_cli;
DELIMITER $$
CREATE TRIGGER insert_cod_cli BEFORE INSERT ON cliente FOR EACH ROW
BEGIN
	SET @COD_CLI = CONCAT('CLI-', LPAD((SELECT MAX(id_cliente) from cliente) + 1 , 4, '0'));
	IF @COD_CLI IS NULL THEN
		SET NEW.COD_CLI = 'CLI-0001';
    ELSE
		SET NEW.COD_CLI = @COD_CLI;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_compra;
DELIMITER $$
CREATE TRIGGER insert_cod_compra BEFORE INSERT ON compra FOR EACH ROW
BEGIN
	SET @COD_COMPRA = CONCAT('COM-', LPAD((SELECT MAX(id_compra) from compra) + 1 , 4, '0'));	
	IF @COD_COMPRA IS NULL THEN
		SET NEW.COD_COMPRA = 'COM-0001';
	ELSE
		SET NEW.COD_COMPRA = @COD_COMPRA;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_emp
DELIMITER $$
CREATE TRIGGER insert_cod_emp BEFORE INSERT ON empleado FOR EACH ROW
BEGIN
	SET @COD_EMP = CONCAT('EMP-', LPAD((SELECT MAX(id_empleado) from empleado) + 1 , 4, '0'));
	IF @COD_EMP IS NULL THEN
		SET NEW.COD_EMP = 'EMP-0001';
	ELSE
		SET NEW.COD_EMP = @COD_EMP;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_fac;
DELIMITER $$
CREATE TRIGGER insert_cod_fac BEFORE INSERT ON factura FOR EACH ROW
BEGIN
	SET @COD_FAC = CONCAT('FAC-', LPAD((SELECT MAX(id_factura) from factura) + 1 , 4, '0'));
	IF @COD_FAC IS NULL THEN
		SET NEW.COD_FAC = 'FAC-0001';
    ELSE
		SET NEW.COD_FAC = @COD_FAC;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_prov;
DELIMITER $$
CREATE TRIGGER insert_cod_prov BEFORE INSERT ON proveedor FOR EACH ROW
BEGIN
	SET @COD_PROV = CONCAT('PROV-', LPAD((SELECT MAX(id_proveedor) from proveedor) + 1 , 4, '0'));	
	IF @COD_PROV IS NULL THEN
		SET NEW.COD_PROV = 'PROV-0001';
    ELSE
		SET NEW.cod_prov = @COD_PROV;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insert_cod_ven;
DELIMITER $$
CREATE TRIGGER insert_cod_ven BEFORE INSERT ON venta FOR EACH ROW
BEGIN
	SET @COD_VEN = CONCAT('VEN-', LPAD((SELECT MAX(id_venta) from venta) + 1 , 4, '0'));
	IF @COD_VEN IS NULL THEN
		SET NEW.COD_VEN = 'VEN-0001';
    ELSE
		SET NEW.COD_VEN = @COD_VEN;
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS Insertar_detalle_compra;
DELIMITER $$
CREATE TRIGGER Insertar_detalle_compra AFTER INSERT ON DETALLE_COMPRA FOR EACH ROW
BEGIN
	SET @MAX_ID_COMPRA = (SELECT MAX(ID_COMPRA) FROM COMPRA);    
    SET @IMPORTE_COMPRA = (SELECT SUM(CANT_COMPRA * PRECIO_COMPRA) FROM DETALLE_COMPRA WHERE ID_COMPRA = @MAX_ID_COMPRA);
    UPDATE COMPRA SET IMPORTE_COMPRA = @IMPORTE_COMPRA WHERE ID_COMPRA = @MAX_ID_COMPRA;
	CALL ActualizarStockCompra();
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS ActualizarStockCompra;
DELIMITER $$
CREATE PROCEDURE ActualizarStockCompra ()
BEGIN	
    DECLARE LOCAL_ID_COMPRA INT;
	DECLARE LOCAL_FECHA date;
    DECLARE LOCAL_ID_ARTICULO INT;
    DECLARE LOCAL_CANT_COMPRA INT;
    DECLARE LOCAL_STOCK_ANTERIOR INT;
    DECLARE LOCAL_PRECIO_VENTA DECIMAL(6,2);
    DECLARE LOCAL_STOCK_ACTUAL INT;
    DECLARE LOCAL_STOCK_VALOR_ACTUAL DECIMAL(9,2);
	
    SET LOCAL_ID_COMPRA = (SELECT MAX(ID_COMPRA) FROM COMPRA);
    SET LOCAL_FECHA = (SELECT FECHA_COMPRA FROM COMPRA WHERE ID_COMPRA = LOCAL_ID_COMPRA);
    SET LOCAL_ID_ARTICULO = (SELECT ID_ARTICULO FROM DETALLE_COMPRA ORDER BY ID_DETALLE_COMPRA DESC LIMIT 1);
    SET LOCAL_CANT_COMPRA = (SELECT CANT_COMPRA FROM DETALLE_COMPRA ORDER BY ID_DETALLE_COMPRA DESC LIMIT 1);    
    SET LOCAL_STOCK_ANTERIOR = (SELECT STOCK_ACTUAL FROM KARDEX WHERE ID_ARTICULO = LOCAL_ID_ARTICULO ORDER BY ID_KARDEX DESC LIMIT 1);
    
    IF LOCAL_STOCK_ANTERIOR IS NULL THEN
		SET LOCAL_STOCK_ANTERIOR = 0;
	END IF;
    
    SET LOCAL_PRECIO_VENTA = (SELECT PRECIO_VENTA FROM ARTICULO WHERE ID_ARTICULO = LOCAL_ID_ARTICULO);
    SET LOCAL_STOCK_ACTUAL = (LOCAL_STOCK_ANTERIOR + LOCAL_CANT_COMPRA);
    SET LOCAL_STOCK_VALOR_ACTUAL = (LOCAL_STOCK_ACTUAL * LOCAL_PRECIO_VENTA);   
    
	INSERT INTO KARDEX (FECHA_KARDEX, ID_COMPRA, ID_ARTICULO, STOCK_ACTUAL, VALOR_STOCK_ACTUAL)
    VALUES (LOCAL_FECHA, LOCAL_ID_COMPRA, LOCAL_ID_ARTICULO, LOCAL_STOCK_ACTUAL, LOCAL_STOCK_VALOR_ACTUAL);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS Insertar_detalle_Venta;
DELIMITER $$
CREATE TRIGGER Insertar_detalle_venta AFTER INSERT ON DETALLE_VENTA FOR EACH ROW
BEGIN	
    DECLARE LOCAL_MAX_ID_VENTA INT;
    DECLARE LOCAL_IMPORTE_VENTA FLOAT;
    DECLARE LOCAL_IGV FLOAT;
    DECLARE LOCAL_SUB_TOTAL FLOAT;

	SET LOCAL_MAX_ID_VENTA = (SELECT MAX(ID_VENTA) FROM VENTA);
    SET LOCAL_IMPORTE_VENTA = (SELECT SUM(CANT_VENTA * PRECIO_VENTA)
    FROM (SELECT DETALLE_VENTA.CANT_VENTA, ARTICULO.PRECIO_VENTA, DETALLE_VENTA.ID_VENTA FROM DETALLE_VENTA LEFT JOIN ARTICULO ON DETALLE_VENTA.ID_ARTICULO = ARTICULO.ID_ARTICULO) AS DETALLE
    WHERE ID_VENTA = LOCAL_MAX_ID_VENTA);
    
    SET LOCAL_IGV = LOCAL_IMPORTE_VENTA * 0.18;
    SET LOCAL_SUB_TOTAL = LOCAL_IMPORTE_VENTA - LOCAL_IGV;
    
    UPDATE VENTA SET IMPORTE_VENTA = LOCAL_IMPORTE_VENTA, IGV = LOCAL_IGV, SUB_TOTAL = LOCAL_SUB_TOTAL WHERE ID_VENTA = LOCAL_MAX_ID_VENTA;
	CALL ActualizarStockVenta();
END$$
DELIMITER 

DROP PROCEDURE IF EXISTS ActualizarStockVenta;
DELIMITER $$
CREATE PROCEDURE ActualizarStockVenta ()
BEGIN	
    DECLARE LOCAL_ID_VENTA INT;
	DECLARE LOCAL_FECHA date;
    DECLARE LOCAL_ID_ARTICULO INT;
    DECLARE LOCAL_CANT_VENTA INT;
    DECLARE LOCAL_STOCK_ANTERIOR INT;
    DECLARE LOCAL_PRECIO_VENTA DECIMAL(6,2);
    DECLARE LOCAL_STOCK_ACTUAL INT;
    DECLARE LOCAL_STOCK_VALOR_ACTUAL DECIMAL(9,2);
	
    SET LOCAL_ID_VENTA = (SELECT MAX(ID_VENTA) FROM VENTA);
    SET LOCAL_FECHA = (SELECT FECHA_VENTA FROM VENTA WHERE ID_VENTA = LOCAL_ID_VENTA);
    SET LOCAL_ID_ARTICULO = (SELECT ID_ARTICULO FROM DETALLE_VENTA ORDER BY ID_DETALLE_VENTA DESC LIMIT 1);
    SET LOCAL_CANT_VENTA = (SELECT CANT_VENTA FROM DETALLE_VENTA ORDER BY ID_DETALLE_VENTA DESC LIMIT 1);    
    SET LOCAL_STOCK_ANTERIOR = (SELECT STOCK_ACTUAL FROM KARDEX WHERE ID_ARTICULO = LOCAL_ID_ARTICULO ORDER BY ID_KARDEX DESC LIMIT 1);
    
    IF LOCAL_STOCK_ANTERIOR IS NULL THEN
		SET LOCAL_STOCK_ANTERIOR = 0;
	END IF;
    
    SET LOCAL_PRECIO_VENTA = (SELECT PRECIO_VENTA FROM ARTICULO WHERE ID_ARTICULO = LOCAL_ID_ARTICULO);
    SET LOCAL_STOCK_ACTUAL = (LOCAL_STOCK_ANTERIOR - LOCAL_CANT_VENTA);
    SET LOCAL_STOCK_VALOR_ACTUAL = (LOCAL_STOCK_ACTUAL * LOCAL_PRECIO_VENTA);   
    
	INSERT INTO KARDEX (FECHA_KARDEX, ID_VENTA, ID_ARTICULO, STOCK_ACTUAL, VALOR_STOCK_ACTUAL)
    VALUES (LOCAL_FECHA, LOCAL_ID_VENTA, LOCAL_ID_ARTICULO, LOCAL_STOCK_ACTUAL, LOCAL_STOCK_VALOR_ACTUAL);
END$$
DELIMITER ;


DROP TRIGGER IF EXISTS insertar_boleta;
DELIMITER $$
CREATE TRIGGER insertar_boleta AFTER INSERT ON VENTA FOR EACH ROW
BEGIN
	SET @MAX_ID_VENTA = (SELECT MAX(ID_VENTA) FROM VENTA);
    
    IF (SELECT ID_COMPROBANTE_PAGO FROM VENTA WHERE ID_VENTA = @MAX_ID_VENTA) = 1 THEN
    INSERT INTO BOLETA (ID_VENTA) VALUES (@MAX_ID_VENTA);
    END IF;
    
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS insertar_factura;
DELIMITER $$
CREATE TRIGGER insertar_factura AFTER INSERT ON VENTA FOR EACH ROW
BEGIN
	SET @MAX_ID_VENTA = (SELECT MAX(ID_VENTA) FROM VENTA);
    
    IF (SELECT ID_COMPROBANTE_PAGO FROM VENTA WHERE ID_VENTA = @MAX_ID_VENTA) = 2 THEN
    INSERT INTO FACTURA (ID_VENTA) VALUES (@MAX_ID_VENTA);
    END IF;
    
END$$
DELIMITER ;