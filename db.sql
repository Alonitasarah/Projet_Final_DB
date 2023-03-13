CREATE TABLE users
		(id_user serial PRIMARY KEY, 
		nom VARCHAR (150), 
		prenom VARCHAR (150), 
		datNais DATE,
		email VARCHAR (250),
		adresse VARCHAR(500), 
		telephone VARCHAR(30));

-- pour ajouter le not null à mes table que j'ai oublié de mettre
ALTER TABLE users ALTER COLUMN nom SET NOT NULL;
ALTER TABLE users ALTER COLUMN prenom SET NOT NULL;
ALTER TABLE users ALTER COLUMN adresse SET NOT NULL;
ALTER TABLE users ALTER COLUMN datnai SET NOT NULL;
ALTER TABLE users ALTER COLUMN telephone SET NOT NULL;


CREATE TABLE ville 
       (id_ville serial PRIMARY KEY, nom VARCHAR (150));

-- pour ajouter le not null à mes table que j'ai oublié de mettre
ALTER TABLE ville ALTER COLUMN (nom) SET NOT NULL;


CREATE TABLE compagnie 
       (id_compagny serial PRIMARY KEY, 
		nom VARCHAR (150), 
		email VARCHAR (250), 
		adresse VARCHAR (500), 
		telephone VARCHAR (30));

-- pour ajouter le not null à mes table que j'ai oublié de mettre		
ALTER TABLE compagnie ALTER COLUMN (nom) SET NOT NULL;
ALTER TABLE compagnie ALTER COLUMN (adresse) SET NOT NULL;
ALTER TABLE compagnie ALTER COLUMN (email) SET NOT NULL;
ALTER TABLE compagnie ALTER COLUMN (telephone) SET NOT NULL;



CREATE TABLE gestionnaire 
       (id_gest serial PRIMARY KEY,
	   nom VARCHAR (150),
	   prenom VARCHAR (150),
	   datNais DATE,
	   email VARCHAR (250),
	   adresse VARCHAR(500), 
	   telephone VARCHAR(30));

-- pour ajouter le not null sur un colone
ALTER TABLE gestionnaire ALTER COLUMN nom SET NOT NULL;
ALTER TABLE gestionnaire ALTER COLUMN prenom SET NOT NULL;
ALTER TABLE gestionnaire ALTER COLUMN datnais SET NOT NULL;
ALTER TABLE gestionnaire ALTER COLUMN email SET NOT NULL;
ALTER TABLE gestionnaire ALTER COLUMN adresse SET NOT NULL;
ALTER TABLE gestionnaire ALTER COLUMN telephone SET NOT NULL;


CREATE TABLE gare 
       (id_gare serial PRIMARY KEY,
	   nom VARCHAR (150),
	   id_compagny INT, FOREIGN KEY  (id_compagny) REFERENCES compagnie (id_compagny),
	   id_ville INT, FOREIGN KEY (id_ville) REFERENCES ville (id_ville));

-- pour ajouter le not null sur un colone
ALTER TABLE gare ALTER COLUMN nom SET NOT NULL;
	 


CREATE TABLE trajet
       (id_trajet serial PRIMARY KEY,
	   typ_voyage VARCHAR (50),
	   prix INTEGER,
		currency varchar(5) default 'XOF',
	   date DATE,
	   duree TIME,
	   depart VARCHAR (250),
	   id_gare INT, FOREIGN KEY (id_gare) REFERENCES gare (id_gare));

-- pour ajouter le not null sur un colone
ALTER TABLE trajet ALTER COLUMN typ_trajet SET NOT NULL;
ALTER TABLE trajet ALTER COLUMN prix SET NOT NULL;
ALTER TABLE trajet ALTER COLUMN date SET NOT NULL;
ALTER TABLE trajet ALTER COLUMN duree SET NOT NULL;
ALTER TABLE trajet ALTER COLUMN depart SET NOT NULL;

-- pour ajouter une colone
ALTER TABLE trajet ADD COLUMN heureDepart time;
ALTER TABLE trajet ADD COLUMN heurearrive time;
ALTER TABLE trajet ADD COLUMN destination time;

-- pour changer le type d'une colone
ALTER TABLE trajet ALTER COLUMN destination TYPE VARCHAR(200);

	   
CREATE TABLE ticket
       (id_ticket serial PRIMARY KEY,
	   prix_total INTEGER,
	   currency VARCHAR (5) default 'XOF',
	   id_client INT, FOREIGN KEY (id_client) REFERENCES client (id_client),
	   id_trajet INT, FOREIGN KEY (id_trajet) REFERENCES trajet (id_trajet));

-- pour ajouter le not null sur un colone
ALTER TABLE ticket ALTER COLUMN prix_total SET NOT NULL;
	   
CREATE TABLE car 
       (num_place serial PRIMARY KEY,
	   typ_car VARCHAR (150),
	   id_compagny INT, FOREIGN KEY (id_compagny) REFERENCES compagnie (id_compagny));

-- pour ajouter le not null sur un colone
ALTER TABLE car ALTER COLUMN typ_car SET NOT NULL;

--  pour remplacer le champs d'une colone 
ALTER TABLE car RENAME COLUMN num_place TO num_car;
	   


CREATE TABLE place 
        (num_place serial PRIMARY KEY,
		ranger VARCHAR (250),
		nbre_place INTEGER,
		id_trajet INT, FOREIGN KEY (id_trajet) REFERENCES trajet (id_trajet),
		num_car INT, FOREIGN KEY (num_car) REFERENCES car (num_car));

-- pour ajouter le not null sur une colone
ALTER TABLE place ALTER COLUMN ranger SET NOT NULL;
ALTER TABLE place ALTER COLUMN nbre_place SET NOT NULL;

		
-- pour ajouter une colone
ALTER TABLE client ADD COLUMN adresse VARCHAR (30);




-- Les requetes que j'ai ecrites

-- la liste des trajets par compagnie et ordonnee par ordre d'heure de depart
SELECT trajet.id_trajet,trajet.prix,trajet.date,trajet.depart,trajet.typ_voyage,trajet.duree,
       trajet.destination,trajet.heuredepart,trajet.heurearrive,trajet.destination,
	   trajet.id_gare,compagnie.nom,ville.nom
FROM trajet 
join gare ON trajet.id_gare=gare.id_gare
join ville ON gare.id_ville=ville.id_ville
join compagnie ON gare.id_compagny=compagnie.id_compagny
WHERE compagnie.nom='avs'
ORDER BY trajet.heuredepart;

-- la liste des clients d'un trajet ordonnée par trajet.date
SELECT client.id_client,client.nom,client.prenom,client.datnais,client.adresse,client.telephone,client.email,client.adresse,
        trajet.id_trajet,trajet.date
FROM client
JOIN ticket ON client.id_client=ticket.id_client
JOIN trajet ON ticket.id_trajet=trajet.id_trajet
WHERE trajet.id_trajet=4
ORDER BY trajet.date;

-- la liste des clients par trajet et selon le typ_voyage
SELECT client.id_client,client.nom,client.prenom,client.datnais,client.adresse,client.telephone,client.email,
       client.adresse,trajet.id_trajet,trajet.typ_voyage
FROM client,trajet
WHERE trajet.typ_voyage='aller';

-- la liste des gares par ville
SELECT gare.id_gare,gare.nom,ville.nom
FROM gare,ville
WHERE ville.nom='abidjan';

-- la liste des compagnies par ville
SELECT compagnie.id_compagny,compagnie.nom,compagnie.adresse,compagnie.telephone,compagnie.email,
       ville.id_ville,ville.nom
FROM compagnie
JOIN gare ON compagnie.id_compagny=gare.id_compagny
JOIN ville ON gare.id_ville=ville.id_ville
WHERE ville.nom='abidjan'

-- la liste des cars qui ont effectué au moins un trajet pour chaque compagnie
SELECT car.num_car,car.typ_car,compagnie.nom
FROM car 
JOIN place ON car.num_car=place.num_car
JOIN trajet ON place.id_trajet=trajet.id_trajet
JOIN compagnie ON compagnie.id_compagny=car.id_compagny
WHERE trajet.id_trajet > 1 AND compagnie.nom='avs';

-- la liste des places disponible pour un trajet et par compagnie
SELECT DISTINCT place.num_place,place.ranger,place.nbre_place,trajet.id_trajet
FROM place
JOIN trajet ON place.id_trajet=trajet.id_trajet
JOIN gare On trajet.id_gare=gare.id_gare
JOIN compagnie ON gare.id_compagny=compagnie.id_compagny
WHERE trajet.typ_voyage='allerretour' 
AND compagnie.nom='utb';