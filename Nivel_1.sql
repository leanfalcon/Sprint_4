CREATE SCHEMA `nueva_db`;
USE nueva_db;

-- Tabala transactions
CREATE TABLE IF NOT EXISTS transactions(
id	VARCHAR(50) PRIMARY KEY,
card_id	VARCHAR(20),
business_id	VARCHAR(20),
timestamp TIMESTAMP,
amount	DECIMAL(10,2),
declined TINYINT(1),
product_ids	VARCHAR(20),
user_id	INT,
lat	FLOAT,
longitude FLOAT);

-- Configuracion para acceder a cargar los archivos
SHOW VARIABLES LIKE 'secure_file_priv';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Tabla companies
CREATE TABLE IF NOT EXISTS companies(
company_id VARCHAR(20) PRIMARY KEY,
company_name VARCHAR(25),
phone VARCHAR(30),
email VARCHAR(50),
country VARCHAR(50),
website VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Tabla credit_card
CREATE TABLE IF NOT EXISTS credit_cards (
id VARCHAR(20) PRIMARY KEY,
user_id INT,
Iban VARCHAR(50),
pan VARCHAR(50),
pin VARCHAR(4),
cvv VARCHAR(3),
Track1 VARCHAR(100),
Track2 VARCHAR(100),
expiring_date date
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Tabla product
CREATE TABLE IF NOT EXISTS products (
id VARCHAR(100) PRIMARY KEY,
product_name VARCHAR(50),
price DECIMAL(10,2),
colour VARCHAR(20),
weight DECIMAL(10,2),
warehouse_id VARCHAR(20)
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Tabla users
CREATE TABLE IF NOT EXISTS users (
id INT PRIMARY KEY,
name VARCHAR(50),
surname VARCHAR(50),
phone VARCHAR(30),
email VARCHAR(50),
birth_date VARCHAR(30),
country VARCHAR(50),
city VARCHAR(50),
post_code VARCHAR(50),
address VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Claves Foraneas
ALTER TABLE transactions
ADD CONSTRAINT fk_companies_id
FOREIGN KEY (business_id) REFERENCES companies(company_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_credit_cards_id
FOREIGN KEY (card_id) REFERENCES credit_cards(id);

ALTER TABLE transactions
ADD CONSTRAINT fk_users_id
FOREIGN KEY (user_id) REFERENCES users(id);

-- Usuarios con mas de 30 transacciones
SELECT id, name, surname
FROM users
WHERE id IN (
    SELECT transactions.user_id
    FROM transactions
    GROUP BY transactions.user_id
    HAVING COUNT(transactions.id) > 30
);

-- Opcion con JOIN
SELECT users.id, name, surname, COUNT(transactions.id) as Numero_transacciones
FROM users
JOIN transactions ON users.id = transactions.user_id
GROUP BY users.id, name, surname
HAVING COUNT(transactions.id) > 30
ORDER BY Numero_transacciones DESC;

-- Compania Donec LTD
SELECT cc.Iban, AVG(t.amount) as Media_amount
FROM credit_cards cc
JOIN transactions t ON cc.id = t.card_id
JOIN companies c ON t.business_id = c.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.Iban;

