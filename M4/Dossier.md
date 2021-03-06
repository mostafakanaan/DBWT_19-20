# DBWT 19/20 - Dossier

## Meilenstein 1:
### ✎ Vorbereitung:
    System	Windows NT DESKTOP-MSEBHU6 10.0 build 17763 (Windows 10) AMD64
    Apache Version	Apache/2.4.41 (Win64) OpenSSL/1.1.1c PHP/7.3.9
    Server Root	C:/xampp/apache

### ✎  Beschreiben Sie im Dossier stichpunktartig, wie Sie mit der bisher erlernten Technik (statisches HTML) den Shop umsetzen müssten, wenn vom Kunden zu allen acht Mahlzeiten die zugehörigen Detail-Seiten gefordert werden
Für jede Mahlzeit eine Details.html anlegen um dort die Informationen abzulegen.
Ich würde für jedes Produkt eine .html anlegen und jede richtig verlinken.


### ✎ Notieren Sie im Dossier, wie Ihre SQL Query für die Kategorien abgeändert werden muss, wenn dort nur noch Kategorien mit mindestens einer verfügbaren Mahlzeit zu finden sein werden
```sql
SELECT Kategorien.ID, Kategorien.Bezeichnung, Kategorien.Kategorie_ID AS Oberkategorie
FROM Kategorien
WHERE Kategorien.ID IN (SELECT Kategorie_ID FROM Mahlzeiten) OR Kategorien.Kategorie_ID IS NULL
```

### ✎ Fragen die mir bei der Programmierung gekommen sind:
- Die Tags von verschiedenen CSS Styles und Attributen
- Warum Fehler bei der Absenden der Form kam -> falscher Name bei den Attribute
- Warum meine Textarea und select nach oben aufgehen und nicht nachunten
- Was für eine Grid aufteilung bei den Seiten am schlausten ist
- Was genau Position Absolute macht etc
- Wie ich mein Footer und meine Navbar auslagern kann -> PHP Include


## Meilenstein 2:
### ✎ was das Semikolon am Ende einer Anweisung bewirkt
Schließt eine SQL Anweisung ab,  aber macht eigentlich keinen unterschied.

### ✎ wie Sie die binären Relationstypen (1:1, 1:N, N:M) abgebildet haben
1:1 -> 1 kommt zu 1
1:N -> N kommt zu 1
N:M -> eigene Tabelle

### ✎ den Unterschied zwischen Tabellen- und Spalten-Constraints und wann welche Art sinnvoll ist
Spalten Constraints -> Sind die Attribut werte, wenn man die Prüft.
Tabellen Constrains -> Primary Key, Foreinkey Cascade etc.

### ✎ wie Sie den Aufzählungsdatentyp ENUM, den MariaDB unterstützt, per CHECK Constraint auch in anderen DBMS nachbilden könnten
```sql
     CONSTRAINT checkstudiengang CHECK(
        studiengang = 'INF' OR
        studiengang = 'ET' OR
        studiengang = 'MCD' OR
        studiengang = 'ISE' OR
        studiengang = 'WI'
        )
```

### ✎ welche Constraints in MariaDB welchem Zweck dienen
checkstudiengang -> überprüft ob der Studiengang der eingegeben wurde valide ist.
fk_mahlZeitenID_kommentare -> Name sagt alles (CONSTRAINT deshalb um es später mit alter table zuändern siehe aufgaben stellung)

### ✎ wieso Sie die Datenbank information_schema sehen
Weil dort die ganze DB Logik hinterlegt sind wie Metadaten, Informationen über den Server, datentypen etc.
Und jeder User darauf lesenden zugriff haben MUSS.
### ✎  Paket 3 Anzahl der Zutaten neben überschrift. Welche Möglichkeiten für diese Umsetzung kennen Sie
 	 Alle Rows in einem Array speichern und die Array länge ausgeben.
 	Mit einer While fetch_assoc machen und eine zähl variable hochzählen
 	Oder eine SQL Query und die Rows zählen lassen

### ✎ Backup der Zutaten Tabelle  Notieren Sie die dazu erforderliche SQL-Queries im Dossier
```sql
REPLACE INTO Zutaten
SELECT *
FROM public.zutaten;
```
## Meilenstein 3: 

### ✎ ... weshalb Sie plötzlich einen Cookie gesetzt bekommen nachdem Sie Werte in die Session schreiben. Lassen Sie sich den Cookie einmal anzeigen im Browser (Entwickler-Tools).
Wenn man Session_Start benutzt legt PHP Automatisch einen Cookie an mit dem Namen -> PHPSESSID (Standartmäßig) und speichert dort die 32-stellige Zeichenkette bzw Informationen aus dem HTTP Header.


### ✎ ... die Situation auf Serverseite, wenn Sie den Cookie löschen und einen weiteren Request absenden.
- Cookie wird Serverseitig nicht mehr gefunden und der User ausgeloggt.

### ✎ ... wie eine Anmeldung auch ohne Verwendung von Cookies realisiert werden könnte. Recherchieren Sie.
- Über die IP Adresse.
- Canvas Fingerprint
- ETAG
https://www.kompyte.com/blog/5-ways-to-identify-your-users-without-using-cookies/

### ✎ ... wie die Stored Procedure aussieht, die Ihnen den korrekten Preis zu einer genannten Nutzer-Nummer und einer Mahlzeiten-ID zurückgibt. (oder verwenden Sie sie direkt in der Anwendung).
```sql
create
    procedure UserRole(IN user int, OUT role varchar(10))
BEGIN
    DECLARE s INT;
    DECLARE g INT;
    DECLARE m INT;
    SELECT count(Nummer) INTO s FROM Studenten WHERE Nummer = user;
    SELECT count(Nummer) INTO g FROM Gaeste WHERE Nummer = user;
    SELECT count(Nummer) INTO m FROM Mitarbeiter WHERE Nummer = user;
    IF s = 1 THEN
        SET role = 'Student';
    ELSEIF m = 1 THEN
        SET role = 'Gast';
    ELSEIF g = 1 THEN
        SET role = 'Mitarbeiter';
    END IF;
```


### ✎ Notieren Sie im Dossier, welche verschiedenen Fehler durch Ihre Constraints entstehen können. Erzeugen Sie diese Fehler per SQL einmal und notieren Sie sich die Fehlermeldung im Dossier. Es geht vorrangig um das Anlegen von Studierenden
```sql
Out of range value for column 'Matrikelnummer' at row 1
```

```sql
Duplicate entry '12345678' for key 'Matrikelnummer'
```
```sql
Data truncated for column 'Studiengang' at row 1
```


### ✎ ... welche Probleme Ihnen aufgefallen sind bei der Umsetzung des MVC-Pattern.
- Sehr verwirrend fürs erste den überblick zu behalten.
- kein Routing (bei uns) die umsetzung war verwirrend.
- Erst in Views und dann in MVC umschreiben war sehr Zeitintensiv..
- Konzept muss 100%ig verinnerlicht werden

### ✎ ... welche Situationen es geben kann, wenn wirklich viele Benutzer gleichzeitig diese Art von Registrierung durchführen.
- Datenbank Server wird überlastet wegen der Procedure.
- laggs wegen keinem load balancing
- Fehler in der Datenbank

### ✎ ... welcher Aspekt in der E-Mensa sich noch für Transaktionen anbieten könnte.
- Berechnung des Warenkorbs






## Meilenstein 4: 

### ✎ Probleme:
- @csrf token bei den Forms vergessen.
- Einige Funktionen mussten angepasst werden.
- Funktionsaufruf via Route mit Parameterübergabe
- Andere Methoden zum Session handeling :
```php
Session::get(); Session::all(); Session::forget();..
```
- app.blade musste angepasst werden
- andere Ordnerstruktur CSS/JS/Bilder mussten in den Public Ordner.
- Bilder mussten via Console per Syslink an den Public/Storage Ordner gebunden werden.
- Vendor Ordner musste in die Git Ignore..

### End
