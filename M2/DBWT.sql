-- SQL DDL Intro aus der �bung
-- TODO: IS A Relation + Kostet + hat bei Kategorien + andere dreieck relation unter FH Angeh�rige
-- Ihre Datenbank ausw�hlen, �ndern Sie den Namen entsprechend...
USE `db3166667`;

-- Tabelle l�schen, falls Sie existiert
-- Alle Tabellen die Fremdschl�ssel enthalten werden als erstes gel�scht...
-- Reihenfolge beachten abh�ngigkeiten m�ssen stimmen....

DROP TABLE IF EXISTS befreundet_mit;
DROP TABLE IF EXISTS FHAng_gehoertzu_Fachbereich;
DROP TABLE IF EXISTS Bestellung_enthaelt_Mahlzeit;
DROP TABLE IF EXISTS dek_braucht_mahlzeit;
DROP TABLE IF EXISTS Mahl_enthaelt_zutat;
DROP TABLE IF EXISTS Mahlzeit_hat_Bild;
DROP TABLE IF EXISTS Zutaten;
DROP TABLE IF EXISTS Bestellungen;
DROP TABLE IF EXISTS Kommentare;
DROP TABLE IF EXISTS Deklarationen;
DROP TABLE IF EXISTS Preise;
DROP TABLE IF EXISTS Mahlzeiten;
DROP TABLE IF EXISTS Kategorien;
DROP TABLE IF EXISTS Bilder;
DROP TABLE IF EXISTS Fachbereiche;
DROP TABLE IF EXISTS Gaeste;
DROP TABLE IF EXISTS Mitarbeiter;
DROP TABLE IF EXISTS Studenten;
DROP TABLE IF EXISTS FH_Angehoerige;
DROP TABLE IF EXISTS Benutzer;



-- Empfohlen ist, zuerst die Attribute der Tabellen anzulegen und die Relationen
-- anschlie�end vorzunehmen. dabei werden Sie erkennen, dass nicht jede L�sch-
-- reihenfolge (DROP) funktioniert.

CREATE TABLE IF NOT EXISTS Benutzer (
    Nummer INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    `E-Mail` VARCHAR(255) NOT NULL UNIQUE, -- Backticks wegen Minus im namen
    Bild VARBINARY(1000), -- verbessern Sie die Datentypen, wenn n�tig
    Nutzername VARCHAR(50) NOT NULL UNIQUE,-- NOT NULL weil nicht optional
    AnlegeDatum TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Vorname VARCHAR(255) NOT NULL,
    Nachname VARCHAR(255) NOT NULL,
    Aktiv BOOL NOT NULL DEFAULT 1,
    `Hash` VARCHAR(60) NOT NULL,
    LetzterLogin TIMESTAMP DEFAULT 0,
    Geburtsdatum DATE,
    age INT AS (DATEDIFF(CURRENT_DATE, Geburtsdatum) / 365.25),
    PRIMARY KEY (Nummer)
);

CREATE TABLE IF NOT EXISTS Bilder (
    ID INT UNSIGNED AUTO_INCREMENT NOT NULL,
    `Alt-Text` BOOL NOT NULL, -- denken Sie auch hier an Backticks
    Titel VARCHAR(255),
    Bin�rdaten VARBINARY(255) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS Kategorien (
    ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Kategorie_ID INT UNSIGNED,
    Bild_ID INT UNSIGNED,
    Bezeichnung VARCHAR(255) NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT fk_kateID_bild FOREIGN KEY(Bild_ID) REFERENCES `Bilder`(ID),
    CONSTRAINT fk_mahlZeitenID_kate FOREIGN KEY(Kategorie_ID) REFERENCES `Kategorien`(ID)

);

CREATE TABLE IF NOT EXISTS Bestellungen (
  Nummer INT UNSIGNED NOT NULL UNIQUE,
  Benutzer_Nummer INT UNSIGNED NOT NULL UNIQUE,
  BestellZeitpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Hier musste ich die reihenfolge �ndern da es sonst zu problemen gekommen ist
  AbholZeitpunkt TIMESTAMP CHECK(AbholZeitpunkt > BestellZeitpunkt),
  Endpreis Double(4,2),
  PRIMARY KEY (Nummer),
  FOREIGN KEY (Benutzer_Nummer) REFERENCES `Benutzer`(nummer)

);

CREATE TABLE  IF NOT EXISTS Mahlzeiten(
    ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Kategorie_ID INT UNSIGNED NOT NULL,
    Beschreibung VARCHAR(255) NOT NULL,
    Vorrat INT UNSIGNED NOT NULL DEFAULT 0,
    Verfuegbar BOOL DEFAULT 0,
    PRIMARY KEY (ID),
    FOREIGN KEY (Kategorie_ID) REFERENCES `Kategorien`(ID)
);

CREATE TABLE IF NOT EXISTS Preise(
    Jahr YEAR NOT NULL,
    Mahlzeiten_ID INT UNSIGNED NOT NULL,
    Gastpreis DOUBLE(2,2) UNSIGNED NOT NULL,
    Studentpreis DOUBLE(2,2) UNSIGNED CHECK ( Studentpreis > `MA-Preis`),
    `MA-Preis` DOUBLE(2,2) UNSIGNED,
    PRIMARY KEY(Jahr, Mahlzeiten_ID),
    CONSTRAINT fk_mahlZeitenID_preise FOREIGN KEY(Mahlzeiten_ID) REFERENCES `Mahlzeiten`(ID)
);

CREATE TABLE IF NOT EXISTS Zutaten(
    ID INT(5) UNSIGNED NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Bio BOOLEAN NOT NULL DEFAULT FALSE,
    Vegan BOOLEAN NOT NULL DEFAULT FALSE,
    Glutenfrei BOOLEAN NOT NULL DEFAULT FALSE,
    Vegetarisch BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (ID)

);
CREATE TABLE IF NOT EXISTS FH_Angehoerige
(
    Nummer INT UNSIGNED NOT NULL UNIQUE,
    PRIMARY KEY (Nummer),
    FOREIGN KEY (Nummer) REFERENCES `Benutzer`(Nummer)
);

CREATE TABLE IF NOT EXISTS Studenten(
    Nummer INT UNSIGNED NOT NULL UNIQUE,
    Martikelnummer INT UNSIGNED NOT NULL UNIQUE,
    Studiengang VARCHAR(3) NOT NULL,
    CONSTRAINT checkstudiengang CHECK(
        studiengang = 'INF' OR
        studiengang = 'ET' OR
        studiengang = 'MCD' OR
        studiengang = 'ISE' OR
        studiengang = 'WI'
        ),
        PRIMARY KEY (Nummer),
        FOREIGN KEY (Nummer) REFERENCES FH_Angehoerige (Nummer) ON DELETE cascade

);
CREATE TABLE IF NOT EXISTS Kommentare(
    ID INT UNSIGNED AUTO_INCREMENT NOT NULL,
    Mahlzeiten_ID INT UNSIGNED,
    Studenten_ID INT UNSIGNED,
    Bemerkung VARCHAR(255),
    Bewertung INT(2) NOT NULL CHECK(Bewertung between 0 and 10),
    PRIMARY KEY(ID),
    CONSTRAINT fk_mahlZeitenID_kommentare FOREIGN KEY(Mahlzeiten_ID) REFERENCES `Mahlzeiten`(ID),
    FOREIGN KEY (Studenten_ID) REFERENCES  `Studenten`(Nummer)
);




CREATE TABLE IF NOT EXISTS  Mitarbeiter(
    Nummer INT UNSIGNED NOT NULL UNIQUE,
    B�ro VARCHAR(4),
    Telefon VARCHAR(15),
    PRIMARY KEY (Nummer),
    FOREIGN KEY (Nummer) REFERENCES FH_Angehoerige(Nummer) ON DELETE cascade

);

CREATE TABLE  IF NOT EXISTS Gaeste(
    Nummer INT UNSIGNED NOT NULL UNIQUE,
    Grund VARCHAR(255) NOT NULL,
    Ablaufdatum TIMESTAMP AS (TIMESTAMPADD(WEEK, 1, CURRENT_TIMESTAMP())),
    PRIMARY KEY (Nummer),
    FOREIGN KEY (Nummer) REFERENCES `Benutzer`(Nummer) ON DELETE cascade

);

CREATE TABLE IF NOT EXISTS Fachbereiche(
    ID INT UNSIGNED AUTO_INCREMENT,
    Name VARCHAR(255),
    Website VARCHAR(255),
    PRIMARY KEY (ID)
);

CREATE TABLE  IF NOT EXISTS Deklarationen(
    Zeichen VARCHAR(2) CHECK (Zeichen BETWEEN 1 and 2),
    Beschriftung VARCHAR(32),
    PRIMARY KEY (Zeichen)
);
-- N:M Relationen...

CREATE  TABLE IF NOT EXISTS dek_braucht_mahlzeit(
    Zeichen_ID VARCHAR(2) CHECK (Zeichen_ID BETWEEN 1 and 2),
    Mahlzeiten_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY (Zeichen_ID) REFERENCES `Deklarationen`(Zeichen),
    FOREIGN KEY (Mahlzeiten_ID) REFERENCES  `Mahlzeiten`(ID)

);

CREATE TABLE IF NOT EXISTS befreundet_mit(
        User1 INT UNSIGNED NOT NULL,
        User2 INT UNSIGNED NOT NULL,
        FOREIGN KEY (User1) REFERENCES `Benutzer`(Nummer),
        FOREIGN KEY (User2) REFERENCES `Benutzer`(Nummer)

);

CREATE TABLE IF NOT EXISTS FHAng_gehoertzu_Fachbereich(
    Benutzer_ID INT UNSIGNED NOT NULL,
    Fachbereiche_ID INT UNSIGNED AUTO_INCREMENT,
    FOREIGN KEY (Benutzer_ID) REFERENCES `Benutzer`(Nummer),
    FOREIGN KEY (Fachbereiche_ID) REFERENCES `Fachbereiche`(ID)
);

CREATE TABLE IF NOT EXISTS Mahl_enthaelt_zutat(
    Mahlzeit_ID INT UNSIGNED,
    Zutat_ID INT(5) UNSIGNED NOT NULL,
    CONSTRAINT fk_mahlZeitenID_zutat FOREIGN KEY(Mahlzeit_ID) REFERENCES `Mahlzeiten`(ID),
    FOREIGN KEY (Zutat_ID) REFERENCES `Zutaten`(ID)
);

CREATE TABLE IF NOT EXISTS Mahlzeit_hat_Bild(
    Mahlzeiten_ID INT UNSIGNED NOT NULL,
    Bild_ID INT UNSIGNED NOT NULL,
    FOREIGN KEY (Mahlzeiten_ID) REFERENCES `Mahlzeiten`(ID),
    FOREIGN KEY (Bild_ID) REFERENCES  `Bilder`(ID)
);

CREATE TABLE IF NOT EXISTS Bestellung_enthaelt_Mahlzeit (
      Bestell_ID INT UNSIGNED NOT NULL,
      Mahlzeit_ID INT UNSIGNED NOT NULL,
      Anzahl INT UNSIGNED NOT NULL,
      FOREIGN KEY (Bestell_ID) REFERENCES `Bestellungen`(Nummer),
      FOREIGN KEY (Mahlzeit_ID) REFERENCES `Mahlzeiten`(ID)
);
-- Create tables m�ssen ebenfalls die richtige reihenfolge besitzen...
-- ALTER Anweisungen

ALTER TABLE Preise
DROP FOREIGN KEY fk_mahlZeitenID_preise;

ALTER TABLE Preise -- Preise l�schen
ADD CONSTRAINT fk_mahlZeitenID_preise FOREIGN KEY (Mahlzeiten_ID) REFERENCES Mahlzeiten(ID) ON DELETE CASCADE;

ALTER TABLE Kommentare
DROP FOREIGN KEY fk_mahlZeitenID_kommentare;

ALTER TABLE Kommentare -- Preise l�schen
ADD CONSTRAINT fk_mahlZeitenID_kommentare FOREIGN KEY (Mahlzeiten_ID) REFERENCES Mahlzeiten(ID) ON DELETE SET NULL;

ALTER TABLE Mahl_enthaelt_zutat
DROP FOREIGN KEY  fk_mahlZeitenID_zutat;

ALTER TABLE Mahl_enthaelt_zutat
ADD CONSTRAINT fk_mahlZeitenID_zutat FOREIGN KEY (Mahlzeit_ID) REFERENCES Mahlzeiten(ID) ON DELETE SET NULL;


ALTER TABLE Kategorien
DROP FOREIGN KEY  fk_mahlZeitenID_kate;

ALTER TABLE Kategorien
ADD CONSTRAINT fk_mahlZeitenID_kate FOREIGN KEY (Kategorie_ID) REFERENCES Kategorien(ID) ON DELETE SET NULL;

ALTER TABLE Kategorien
DROP FOREIGN KEY  fk_kateID_Bild;

ALTER TABLE Kategorien
ADD CONSTRAINT fk_kateID_bild FOREIGN KEY(Bild_ID) REFERENCES Bilder(ID) ON DELETE SET NULL;

-- INSERTS
INSERT INTO `Benutzer`(vorname, nachname, geburtsdatum, nutzername, `E-Mail`, hash) VALUES ('Max', 'Mustermann', '1975-01-01', 'Nutzer1', 'nutzer1@gmx.de', 'dhdazusadas');
INSERT INTO `Benutzer`(vorname, nachname, geburtsdatum, nutzername, `E-Mail`, hash) VALUES ('Alex', 'Leis', '1972-02-05', 'Nutzer2', 'nutzer2@gmx.de', 'dhdazusadas');
INSERT INTO `Benutzer`(vorname, nachname, geburtsdatum, nutzername, `E-Mail`, hash) VALUES ('Uwe', 'Kowalski', '1999-03-01', 'Nutzer3', 'nutzer3@gmx.de', 'dhdazusadas');
INSERT INTO `Benutzer`(vorname, nachname, geburtsdatum, nutzername, `E-Mail`, hash) VALUES ('Ralf', 'Schmidt', '2000-01-01', 'Nutzer4', 'nutzer4@gmx.de', 'dhdazusadas');

INSERT INTO FH_Angehoerige VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer1@gmx.de'
    ));
INSERT INTO FH_Angehoerige VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer2@gmx.de'
    ));
INSERT INTO FH_Angehoerige VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer3@gmx.de'
    ));

INSERT INTO `Studenten`VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer1@gmx.de'
    ),12345678,'INF');

INSERT INTO `Studenten`VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer2@gmx.de'
    ),12345677,'ET');

INSERT INTO `Mitarbeiter`VALUES ((
    SELECT nummer FROM `Benutzer` WHERE `E-Mail` = 'nutzer3@gmx.de'
    ),'E113','+49100');