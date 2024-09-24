create database imdb;
use imdb;

CREATE TABLE `studiouri` (
  `id_studio` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `nume` VARCHAR(64) NOT NULL,
  `adresa` VARCHAR(256) UNIQUE,
  `data_infiintare` DATE NOT NULL,
  `numar_telefon` BIGINT NOT NULL
);

ALTER TABLE `studiouri`
  ADD CONSTRAINT `NN_numar_telefon_studio` CHECK (length(`numar_telefon`)>= 9);

CREATE TABLE `filme` (
  `id_film` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `nume` VARCHAR(64) NOT NULL,
  `studio` INT(5) NOT NULL,
  `data_lansare` DATE NOT NULL
);

ALTER TABLE `filme`
  ADD CONSTRAINT `FK_studio_filme` FOREIGN KEY (`studio`) REFERENCES `studiouri` (`id_studio`) ON DELETE CASCADE;

CREATE TABLE `persoane` (
  `id_persoana` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `nume` VARCHAR(32) NOT NULL,
  `prenume` VARCHAR(32) NOT NULL,
  `gen` VARCHAR(32) NOT NULL,
  `data_nasterii` DATE NOT NULL,
  `data_decesului` DATE
);

ALTER TABLE `persoane`
  ADD CONSTRAINT `NN_gen` CHECK (`gen` IN ('masculin', 'feminin'));

CREATE TABLE `premii` (
  `id_premiu` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `tip` VARCHAR(32) NOT NULL,
  `motiv` VARCHAR(128) NOT NULL,
  `film_premiant` INT(5) NOT NULL
);

ALTER TABLE `premii`
  ADD CONSTRAINT `FK_film_premiant` FOREIGN KEY (`film_premiant`) REFERENCES `filme` (`id_film`) ON DELETE CASCADE;

CREATE TABLE `utilizatori` (
  `id_utilizator` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(64) UNIQUE,
  `email` VARCHAR(64) UNIQUE,
  `parola` VARCHAR(32) NOT NULL,
  `data_inregistrare` DATE NOT NULL,
  `data_nasterii` DATE NOT NULL,
  `tara_origine` VARCHAR(32) NOT NULL
);

CREATE TABLE `cinematografe` (
  `id_cinematograf` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `nume` VARCHAR(64) NOT NULL,
  `numar_sali` INT(3) NOT NULL,
  `adresa` VARCHAR(256) UNIQUE,
  `numar_telefon` BIGINT NOT NULL
);

ALTER TABLE `cinematografe`
  ADD CONSTRAINT `NN_numar_telefon_cinematograf` CHECK (length(`numar_telefon`)>= 9);

CREATE TABLE `genuri` (
  `id_gen` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `tip` VARCHAR(32) UNIQUE
);

CREATE TABLE `participare_in_film` (
  `participare_in_film_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `persoana_id` INT NOT NULL,
  `film_id` INT NOT NULL,
  `data_angajare` DATE NOT NULL,
  `meserie` VARCHAR(32) NOT NULL,
  `rol` VARCHAR(64),
  `tip_rol` VARCHAR(64)
);

ALTER TABLE `participare_in_film`
  ADD CONSTRAINT `FK_persoana_participare` FOREIGN KEY (`persoana_id`) REFERENCES `persoane` (`id_persoana`),
  ADD CONSTRAINT `FK_film_participare` FOREIGN KEY (`film_id`) REFERENCES `filme` (`id_film`);

CREATE TABLE `evaluare` (
  `evaluare_ID` INT AUTO_INCREMENT PRIMARY KEY,
  `film_id` INT NOT NULL,
  `utilizator_id` INT NOT NULL,
  `nota` INT NOT NULL,
  `data_acordare_evaluare` DATE NOT NULL,
  `recomanda_filmul` BOOLEAN NOT NULL
);

ALTER TABLE `evaluare`
  ADD CONSTRAINT `FK_film_evaluare` FOREIGN KEY (`film_id`) REFERENCES `filme` (`id_film`),
  ADD CONSTRAINT `FK_utilizator_evaluare` FOREIGN KEY (`utilizator_id`) REFERENCES `utilizatori` (`id_utilizator`);

CREATE TABLE `filme_genuri` (
  `filme_genuri_ID` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `film_id` INT(5) NOT NULL,
  `gen_id` INT(5) NOT NULL,
  `gen_predominant` VARCHAR(32) NOT NULL
);

ALTER TABLE `filme_genuri`
  ADD CONSTRAINT `FK_film_fg` FOREIGN KEY (`film_id`) REFERENCES `filme` (`id_film`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_gen_fg` FOREIGN KEY (`gen_id`) REFERENCES `genuri` (`id_gen`) ON DELETE CASCADE;

CREATE TABLE `filme_cinematografe` (
  `filme_cinematografe_ID` INT(5) AUTO_INCREMENT PRIMARY KEY,
  `film_id` INT(5) NOT NULL,
  `cinematograf_id` INT(5) NOT NULL,
  `data_prima_difuzare` DATE NOT NULL,
  `data_ultima_difuzare` DATE NOT NULL
);

ALTER TABLE `filme_cinematografe`
  ADD CONSTRAINT `FK_film_fc` FOREIGN KEY (`film_id`) REFERENCES `filme` (`id_film`) ON DELETE CASCADE,
  ADD CONSTRAINT `FK_cinematograf_fc` FOREIGN KEY (`cinematograf_id`) REFERENCES `cinematografe` (`id_cinematograf`) ON DELETE CASCADE;

-- inserare date in tabele

INSERT INTO `persoane` (`nume`, `prenume`, `gen`, `data_nasterii`, `data_decesului`)
VALUES
    ('DiCaprio', 'Leonardo', 'masculin', '1974-11-11', NULL),
    ('Pitt', 'Brad', 'masculin', '1963-12-18', NULL),
    ('Streep', 'Meryl', 'feminin', '1949-06-22', NULL),
    ('Spielberg', 'Steven', 'masculin', '1946-12-18', NULL),
    ('Nolan', 'Christopher', 'masculin', '1970-07-30', NULL),
    ('Portman', 'Natalie', 'feminin', '1981-06-09', NULL),
    ('Tarantino', 'Quentin', 'masculin', '1963-03-27', NULL),
    ('Blanchett', 'Cate', 'feminin', '1969-05-14', NULL),
    ('Scorsese', 'Martin', 'masculin', '1942-11-17', NULL),
    ('Marlon', 'Brando', 'masculin', '1924-04-03', '2004-07-01'),
    ('Al', 'Pacino', 'masculin', '1940-04-25', NULL);

INSERT INTO `studiouri` (`nume`, `adresa`, `data_infiintare`, `numar_telefon`)
VALUES
    ('Warner Bros', 'Burbank 2 , California, SUA', '1923-04-04', '0723456789'),
    ('Columbia Pictures', 'Culver City, California, SUA', '1924-01-10', '07987654321'),
    ('20th Century Fox', 'Los Angeles 2, California, SUA', '1935-05-31', '0724613579'),
    ('Universal Pictures', 'Universal City, California, SUA', '1912-04-30', '0713579246'),
    ('Paramount Pictures', 'Hollywood, California, SUA', '1912-05-08', '0786429753'),
    ('DreamWorks Pictures', 'Universal City 2, California, SUA', '1994-10-12', '0757293861'),
    ('Miramax Films', 'New York City, SUA', '1979-01-01', '0795847302'),
    ('New Line Cinema', 'Los Angeles 3, California, SUA', '1967-02-28', '0738479529'),
    ('Walt Disney Pictures', 'Burbank, California, SUA', '1923-10-16', '0791263845'),
    ('Metro-Goldwyn-Mayer', 'Beverly Hills, California, SUA', '1924-04-17', '0720394576'),
    ('United Artists', 'Los Angeles, California, SUA', '1919-02-05', '0731582946');

INSERT INTO `filme` (`nume`, `studio`, `data_lansare`)
VALUES
    ('Titanic', 1, '1997-01-01'),
    ('Once Upon a Time in Hollywood', 2, '2019-02-02'),
    ('The Devil Wears Prada', 3, '2006-03-03'),
    ('Jaws', 4, '1975-04-04'),
    ('Inception', 5, '2010-05-05'),
    ('Black Swan', 6, '2010-06-06'),
    ('Pulp Fiction', 7, '1994-07-07'),
    ('The Aviator', 8, '2004-08-08'),
    ('The Reader', 9, '2008-09-09'),
    ('The Godfather', 10, '1972-10-10'),
    ('The Godfather: Part II', 11, '1974-11-11');


INSERT INTO `premii` (`tip`, `motiv`, `film_premiant`)
VALUES
    ('oscar', 'Cel mai bun actor', 1),
    ('bafta', 'Cel mai bun actor in rol secundar', 2),
    ('golden_glove', 'Cea mai buna actrita', 3),
    ('oscar', 'Cel mai bun regizor', 4),
    ('bafta', 'Cel mai bun regizor', 5),
    ('oscar', 'Cea mai buna actrita', 6),
    ('bafta', 'Cel mai bun regizor', 7),
    ('oscar', 'Cea mai buna actrita', 8),
    ('oscar', 'Cel mai bun regizor', 9),
    ('golden_glove', 'Cel mai bun actor', 10),
    ('oscar', 'Cel mai bun actor', 11);


INSERT INTO `utilizatori` (`username`, `email`, `parola`, `data_inregistrare`, `data_nasterii`, `tara_origine`)
VALUES
    ('IoanaPopescu', 'ioanapopescu@gmail.com', 'parola1', '2022-01-01', '1990-01-01', 'Romania'),
    ('AndreiIonescu', 'andreiionescu@gmail.com', 'parola2', '2022-01-02', '1991-02-02', 'Romania'),
    ('MariaGeorgescu', 'mariageorgescu@gmail.com', 'parola3', '2022-01-03', '1992-03-03', 'Romania'),
    ('MihaiStanciu', 'mihaistanciu@gmail.com', 'parola4', '2022-01-04', '1993-04-04', 'Romania'),
    ('ElenaDumitrescu', 'elenadumitrescu@gmail.com', 'parola5', '2022-01-05', '1994-05-05', 'Romania'),
    ('AlexandruConstantin', 'alexandruconstantin@gmail.com', 'parola6', '2022-01-06', '1995-06-06', 'Romania'),
    ('CristinaRadu', 'cristinaradu@gmail.com', 'parola7', '2022-01-07', '1996-07-07', 'Romania'),
    ('GabrielNeagu', 'gabrielneagu@gmail.com', 'parola8', '2022-01-08', '1997-08-08', 'Romania'),
    ('AnaMihalache', 'anamihalache@gmail.com', 'parola9', '2022-01-09', '1998-09-09', 'Romania'),
    ('GeorgeBalan', 'georgebalan@gmail.com', 'parola10', '2022-01-10', '1999-10-10', 'Romania'),
    ('LauraPopa', 'laurapopa@gmail.com', 'parola11', '2022-01-11', '2000-11-11', 'Romania');

INSERT INTO `cinematografe` (`nume`, `numar_sali`, `adresa`, `numar_telefon`)
VALUES
    ('Cinema City', 10, 'Bucuresti, Str. Victoriei 1', '0723456789'),
    ('Dream City', 10, 'Cluj-Napoca, Str. Avram Iancu 2', '07987654321'),
    ('Valley City', 10, 'Timisoara, Str. Libertatii 3', '0724613579'),
    ('Patria', 10, 'Iasi, Str. Palat 4', '0713579246'),
    ('Cinema Cultural', 10, 'Constanta, Str. Tomis 5', '0786429753'),
    ('Cinema City', 10, 'Brasov, Str. Muresenilor 6', '0757293861'),
    ('Dream City', 10, 'Oradea, Str. Independentei 7', '0795847302'),
    ('Valley City', 10, 'Sibiu, Str. Cetatii 8', '0738479529'),
    ('Cinema City', 10, 'Ploiesti, Str. Republicii 9', '0791263845'),
    ('Cinema City', 10, 'Galati, Str. Dunarii 10', '0720394576'),
    ('Movieplex', 8, 'Craiova, Str. Unirii 11', '0731582946');


INSERT INTO `genuri` (`tip`)
VALUES
    ('Actiune'),
    ('Comedie'),
    ('Drama'),
    ('Horror'),
    ('Romantic'),
    ('SF'),
    ('Thriller'),
    ('Documentar'),
    ('Animatie'),
    ('Aventura'),
    ('Mister');


INSERT INTO `participare_in_film` (`persoana_id`, `film_id`, `data_angajare`, `meserie`, `rol`, `tip_rol`)
VALUES
    (1, 1, '1997-01-01', 'actor', 'Jack Dawson', 'principal'),
    (2, 2, '2019-02-02', 'actor', 'Cliff Booth', 'principal'),
    (3, 3, '2006-03-03', 'actor', 'Miranda Priestly', 'principal'),
    (4, 4, '1975-04-04', 'regizor', NULL, NULL),
    (5, 5, '2010-05-05', 'regizor', NULL, NULL),
    (6, 6, '2010-06-06', 'actor', 'Nina Sayers', 'principal'),
    (7, 7, '1994-07-07', 'regizor', NULL, NULL),
    (8, 8, '2004-08-08', 'actor', 'Katharine Hepburn', 'principal'),
    (9, 9, '2008-09-09', 'regizor', NULL, NULL),
    (10, 10, '1972-10-10', 'actor', 'Vito Corleone', 'principal'),
    (11, 11, '1974-11-11', 'actor', 'Michael Corleone', 'principal');


INSERT INTO `evaluare` (`film_id`, `utilizator_id`, `nota`, `data_acordare_evaluare`, `recomanda_filmul`)
VALUES
    (1, 8, 9, '2022-01-01', 1),
    (2, 7, 8, '2022-01-02', 1),
    (3, 6, 7, '2022-01-03', 1),
    (4, 4, 6, '2022-01-04', 0),
    (5, 5, 9, '2022-01-05', 1),
    (6, 6, 8, '2022-01-06', 1),
    (7, 7, 7, '2022-01-07', 1),
    (8, 8, 6, '2022-01-08', 0),
    (9, 9, 9, '2022-01-09', 1),
    (10, 10, 8, '2022-01-10', 1),
    (11, 11, 7, '2022-01-11', 1);


INSERT INTO `filme_genuri` (`film_id`, `gen_id`, `gen_predominant`)
VALUES
    (1, 5, 'romantic'),
    (2, 2, 'comedie'),
    (3, 2, 'comedie'),
    (4, 4, 'horror'),
    (5, 6, 'SF'),
    (6, 3, 'drama'),
    (7, 7, 'thriller'),
    (8, 3, 'drama'),
    (9, 3, 'drama'),
    (10, 3, 'drama'),
    (11, 3, 'drama');


INSERT INTO `filme_cinematografe` (`film_id`, `cinematograf_id`, `data_prima_difuzare`, `data_ultima_difuzare`)
VALUES
    (1, 1, '1997-01-01', '1997-01-31'),
    (2, 2, '2019-02-02', '2019-02-28'),
    (3, 3, '2006-03-03', '2006-03-31'),
    (4, 4, '1975-04-04', '1975-04-30'),
    (5, 5, '2010-05-05', '2010-05-31'),
    (6, 6, '2010-06-06', '2010-06-30'),
    (7, 7, '1994-07-07', '1994-07-31'),
    (8, 8, '2004-08-08', '2004-08-31'),
    (9, 9, '2008-09-09', '2008-09-30'),
    (10, 10, '1972-10-10', '1972-10-31'),
    (11, 11, '1974-11-11', '1974-11-30');

CREATE VIEW `film_studio_details` AS
SELECT
    f.`id_film`,
    f.`nume` AS `nume_film`,
    f.`data_lansare`,
    s.`id_studio`,
    s.`nume` AS `nume_studio`
FROM
    `filme` f
JOIN `studiouri` s ON f.`studio` = s.`id_studio`;

CREATE VIEW `film_summary_view` AS
SELECT
    f.`id_film`,
    f.`nume` AS `nume_film`,
    s.`nume` AS `nume_studio`,
    f.`data_lansare`,
    (
        SELECT MAX(p.`nume`)
        FROM `participare_in_film` pif
        JOIN `persoane` p ON pif.`persoana_id` = p.`id_persoana`
        WHERE pif.`film_id` = f.`id_film` AND `pif.meserie` = 'regizor'
    ) AS `nume_regizor`,
    (
        SELECT GROUP_CONCAT(g.`tip` ORDER BY g.`tip` ASC)
        FROM `filme_genuri` fg
        JOIN `genuri` g ON fg.`gen_id` = g.`id_gen`
        WHERE fg.`film_id` = f.`id_film`
    ) AS `genuri_film`,
    (
        SELECT c.`nume`
        FROM `filme_cinematografe` fc
        JOIN `cinematografe` c ON fc.`cinematograf_id` = c.`id_cinematograf`
        WHERE fc.`film_id` = f.`id_film`
        LIMIT 1
    ) AS `nume_cinematograf`
FROM
    `filme` f
JOIN
    `studiouri` s ON f.`studio` = s.`id_studio`;