-- Crear la tabla status credit cards
CREATE TABLE credit_card_status (
    card_id VARCHAR(20) PRIMARY KEY,
    active tinyint,
    FOREIGN KEY (card_id) REFERENCES credit_cards(id)
);
    
--  Ingresar datos en la tabla credit_card_status
INSERT INTO credit_card_status (card_id, active)
SELECT cc.id,
    CASE
        WHEN (SELECT COUNT(*)
              FROM transactions t
              WHERE t.card_id = cc.id
              ORDER BY t.timestamp DESC
              LIMIT 3
             ) = 3 AND 
             (SELECT COUNT(*)
              FROM transactions t
              WHERE t.card_id = cc.id
              AND t.declined = 1
              ORDER BY t.timestamp DESC
               LIMIT 3) = 3
        THEN 0
        ELSE 1
    END AS active
FROM credit_cards cc;

SELECT * FROM credit_card_status;

-- Cantidad de Tarjetas de credito activas
SELECT COUNT(*) as Número_de_Tarjetas_Activas
FROM credit_card_status
WHERE active = 1;