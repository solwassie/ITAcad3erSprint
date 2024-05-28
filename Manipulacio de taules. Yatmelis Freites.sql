/* La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre
les targetes de crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir
una relació adequada amb les altres dues taules ("transaction" i "company"). Després de crear la taula serà
necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.*/

CREATE TABLE credit_card (
    id varchar(15) PRIMARY KEY,
    iban varchar(34) NOT NULL unique,
	pan varchar(25) NOT NULL,
	pin INT(4) NOT NULL,
    cvv INT(3) NOT NULL,
    expiring_date varchar(8) NOT NULL
);

/* Exercici 2
El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb 
ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999.
 Recorda mostrar que el canvi es va realitzar.*/
SELECT * 
FROM credit_card
WHERE id = "CcU-2938";
UPDATE credit_card 
SET iban = 'R323456312213576817699999' 
WHERE id = "CcU-2938";

/*Exercici 3
En la taula "transaction" ingressa un nou usuari amb la següent informació:*/
-- company_id 'b-9999' no existe en la tabla company, por lo que debes insertar el id en tabla 
-- company y todo queda nulo
INSERT INTO company (id) 
VALUES ('b-9999');
-- TAMBIÉN ALTERÉ LAS TABLAS Y LOS VALORES DEFAULT PARA LAS COLUMNAS IBAN, PIN, CVV Y EXPIRING_DATE para
-- que me permita añadir una columna y dejar el resto de los campos con valores default
ALTER TABLE credit_card
ALTER COLUMN iban
SET DEFAULT 'Null';
ALTER TABLE credit_card
ALTER COLUMN pin
SET DEFAULT '0';
ALTER TABLE credit_card
ALTER COLUMN cvv
SET DEFAULT '0';
ALTER TABLE credit_card
ALTER COLUMN expiring_date
SET DEFAULT 'NULL';
-- credit_card_id 'CcU-9999' no existe en la tabla credit_card, por lo que debo insertar esa PK en su tabla
INSERT INTO credit_card (id) 
VALUES ('CcU-9999');
-- por último hago la inserción de la fila
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999',
 '111.11', '0');
/*- Exercici 4
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card.
Recorda mostrar el canvi realitzat.*/
SELECT * 
FROM transactions.credit_card;

ALTER TABLE credit_card
DROP COLUMN pan;

/* Nivell 2
Exercici 1
Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de 
dades.*/
SELECT * 
FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

DELETE FROM transaction 
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

/*Exercici 2
La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies
 efectives. S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les 
 seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que contingui la 
 següent informació: Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra 
 realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de 
 compra.
*/
CREATE VIEW VistaMarketing AS
SELECT company.company_name, company.phone, company.country, 
AVG(transaction.amount) AS mediana_compra_por_compañía
FROM company
JOIN transaction
ON company.id = transaction.company_id
GROUP BY company.company_name, company.phone, company.country
ORDER BY AVG(transaction.amount) DESC;

/*Exercici 3
Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de 
residència en "Germany"*/
SELECT * 
FROM transactions.vistamarketing
WHERE country = "Germany";

/*Nivell 3
Exercici 1
La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip
 va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
 Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:
*/
ALTER TABLE company
DROP COLUMN website;

RENAME TABLE user TO data_user;

ALTER TABLE credit_card MODIFY pin varchar(4);

ALTER TABLE credit_card ADD COLUMN fecha_actual DATE;


/* Exercici 2
L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent 
informació:

ID de la transacció
Nom de l'usuari/ària
Cognom de l'usuari/ària
IBAN de la targeta de crèdit usada.
Nom de la companyia de la transacció realitzada.
Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de 
nom columnes segons sigui necessari.
Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable
ID de transaction.*/
CREATE VIEW InformeTecnico AS
SELECT 
	transaction.id AS id_transaction, 
    data_user.name AS nombre_usuario, 
    data_user.surname AS apellido_usuario, 
    credit_card.iban AS iban_tarjeta, 
    company.company_name AS nombre_compañia, 
    company.country AS pais_compañía
FROM data_user
JOIN transaction
ON data_user.id = transaction.user_id
JOIN credit_card
ON credit_card.id = transaction.credit_card_id
JOIN company
ON company.id = transaction.company_id
ORDER BY transaction.id DESC;
