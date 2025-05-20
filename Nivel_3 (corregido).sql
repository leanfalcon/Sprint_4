-- Creamos la tabla temporal
CREATE TABLE transaction_products (
    transaction_id VARCHAR(50),
    product_id VARCHAR(100),
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insertamos los datos
INSERT INTO transaction_products (transaction_id, product_id)
SELECT t.id as transaction_id, p.id as product_id
FROM transactions t
JOIN products p  ON FIND_IN_SET(CAST(p.id AS CHAR), REPLACE(t.product_id_1,' ', '')) > 0;

-- Hacemos consulta de los datos
SELECT * FROM transaction_products;

-- Numero de veces que se ha vendido cada producto
SELECT tp.product_id, p.product_name, COUNT(*) as Ventas_totales
FROM transaction_products tp
JOIN products p ON tp.product_id = p.id
GROUP BY tp.product_id, p.product_name
ORDER BY Ventas_totales DESC;
