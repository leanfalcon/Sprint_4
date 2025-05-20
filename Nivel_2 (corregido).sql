CREATE TABLE credit_card_status (
    card_id VARCHAR(20) PRIMARY KEY,
    status BOOLEAN,
    FOREIGN KEY (card_id) REFERENCES credit_cards(id));

INSERT INTO credit_card_status (card_id, status)
SELECT  t.card_id,
    CASE
        WHEN SUM(t.declined) >= 3 THEN 0
        ELSE 1
    END AS status
FROM ( SELECT t.card_id, t.declined,
    ROW_NUMBER() OVER (PARTITION BY t.card_id ORDER BY t.timestamp DESC) AS fila
    FROM transactions t
) t
WHERE t.fila <= 3
GROUP BY t.card_id;

SELECT COUNT(*) AS Tarjetas_Activas
FROM credit_card_status
WHERE status = 1;
