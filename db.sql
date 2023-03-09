CREATE TABLE users
		(id_user serial PRIMARY KEY, 
		nom VARCHAR (150), 
		prenom VARCHAR (150), 
		datNais DATE,
		email VARCHAR (250),
		adresse VARCHAR(500), 
		telephone VARCHAR(30));

CREATE TABLE ville 
       (id_ville serial PRIMARY KEY, nom VARCHAR (150));

CREATE TABLE compagnie 
       (id_compagny serial PRIMARY KEY, 
		nom VARCHAR (150), 
		email VARCHAR (250), 
		adresse VARCHAR (500), 
		telephone VARCHAR (30));

CREATE TABLE gestionnaire 
       (id_gest serial PRIMARY KEY,
	   nom VARCHAR (150),
	   prenom VARCHAR (150),
	   datNais DATE,
	   email VARCHAR (250),
	   adresse VARCHAR(500), 
	   telephone VARCHAR(30));
	   
CREATE TABLE gare 
       (id_gare serial PRIMARY KEY,
	   nom VARCHAR (150),
	   id_compagny INT, FOREIGN KEY  (id_compagny) REFERENCES compagnie (id_compagny),
	   id_ville INT, FOREIGN KEY (id_ville) REFERENCES ville (id_ville));
	 
CREATE TABLE trajet
       (id_trajet serial PRIMARY KEY,
	   typ_voyage VARCHAR (50),
	   prix INTEGER,
		currency varchar(5) default 'XOF',
	   date DATE,
	   duree TIME,
	   depart VARCHAR (250),
	   id_gare INT, FOREIGN KEY (id_gare) REFERENCES gare (id_gare));
	   
CREATE TABLE ticket
       (id_ticket serial PRIMARY KEY,
	   prix_total INTEGER,
	   currency VARCHAR (5) default 'XOF',
	   id_client INT, FOREIGN KEY (id_client) REFERENCES client (id_client),
	   id_trajet INT, FOREIGN KEY (id_trajet) REFERENCES trajet (id_trajet));
	   
CREATE TABLE car 
       (num_place serial PRIMARY KEY,
	   typ_car VARCHAR (150),
	   id_compagny INT, FOREIGN KEY (id_compagny) REFERENCES compagnie (id_compagny));
	   
ALTER TABLE car 
RENAME COLUMN num_place
TO num_car;
	   
CREATE TABLE place 
        (num_place serial PRIMARY KEY,
		ranger VARCHAR (250),
		nbre_place INTEGER,
		id_trajet INT, FOREIGN KEY (id_trajet) REFERENCES trajet (id_trajet),
		num_car INT, FOREIGN KEY (num_car) REFERENCES car (num_car));
		
		
ALTER TABLE client ADD COLUMN adresse VARCHAR (30);
