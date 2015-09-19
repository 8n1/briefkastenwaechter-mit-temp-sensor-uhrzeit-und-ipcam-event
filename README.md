# nodemcu-briefkastenwaechter

...
### Achtung: README wird noch überarbeitet (Aktueller Fortschritt: ~80%)
...


## Letzte Updates:
* Fehlererkennung überarbeitet (Nachrichten werden jetzt sehr viel zuverlässiger versendet)
* Logging verbessert (Logfiles können jetzt auch zurückgesetzt werden)
* Reset Signal (Um einem externen µc das zurücksetzen des "failsave" Timers zu signalisieren)
* Neue Firmware (Beseitigt verschiedenste Probleme die ich mit den "offiziellen" Releases hatte)
* Ausschalt Signal (Um einem externen µC das abschalten der Stromversorgung zu signalisieren)

## Ablauf/Features:
* Verbindet sich nach einem Reset (oder dem anlegen der Versorgungsspannung) automatisch mit dem gespeicherten Wlan Netzwerk


* Ermittelt die Batteriespannung (Spannungsteiler und interner ADC) (**optional**)
* Ermittelt die akutelle Temperatur (DS18B20) (**optional**)
* Holt sich die aktuelle Uhrzeit + Datum von einem beliebigen Webserver  (**optional**)
* Löst ein frei definierbares Event auf einer mittels HTTP Basic Authentifizierung gesicherten Axis IP Cam aus. Schickt z.B. ein Foto. (**optional**)


* Aktiviert ein Pushingbox Szenario entsprechend der Konfiguration.
  Die gesammelten Informationen (Uhrzeit, Temperatur, Signalstärke, ..) werden mit an Pushingbox übertragen und können in die Nachricht die von Pushingbox an euch bzw. den hinterlegten Service (Verfügbare Services: http://i.imgur.com/xr65rBj.png) verschickt wird nach belieben eingebaut werden.

* **NEU:** Wenn das aktivieren des Szenarios aus irgend einem Grund (z.b. Server kurzzeitig nicht erreichbar, ...) nicht klappt, wird es einfach beliebig oft weiter versucht. Wie oft und ob zusätzlich noch ein Reset (je nach konfiguration auch mit variabler Schlafzeit dazwischen) gemacht werden soll kann in der config.lua festgelegt werden. 


* Wenn das versenden der Nachricht geklappt hat oder alle Versuche (samt optionalem Reset) aufgebraucht sind legt sich der ESP wieder schlafen (DeepSleep).

  Mit einem Reset wiederholt sich die ganze Prozedur.


## Hardware
TODO Schaltplan

## Unterstzütze ESP Module
Getestet mit ESP-01, ESP-07 und ESP-12. Sollte aber auf allen laufen. 
Möchte man die Batteriespannung messen braucht man aber zugang zum ADC Pin "TOUT".
...


## Geplante Erweiterungen:
* Batterieüberwachung mittels internem ADC (**FERTIG - 15.07.2015**)
* Kleines Skript (Makefile) um beuqem die Firmware flashen und automatisch alle Lua Skripte auf den ESP hochzuladen zu können
* Konfiguration und Test über eine einfache Weboberfläche (nicht dringend)
* Verbindung mit dem WLAN nicht mehr per Timer Alarm sonder per wifi.sta.eventMonReg() (nicht dringend)
* Alternativen für Pushingbox (nicht dringend)


### Bugs:
* Winter/Sommerzeit wird noch nicht berücksichtigt. (Andere Länder?)
* In ganz seltenen Fällen kann es passieren das der ESP es nicht schafft die Nachricht zu verschicken. Durch das letzte Update ist die Wahrscheinlichkeit dafür aber sehr gering. Durch die eingebaute Logginfunktion sollte man aber zumindest alle Fehlversuche mitbekommen. 
* "Zombie mode" - Bei der Firmware Version 0.9.5 kann es vorkommen das der ESP nach dem node.dlseep() nicht ordentlich bootet.



## Konfiguration: config.lua
Die gesamte Konfiguration erfolgt über die config.lua. Es muss nur diese Datei angepasst werden.

Was mindestens definiert werden muss sind die Wlan Zugangsdaten und die Pushingbox Device ID des Szenarios das aktiviert werden soll. 

Um weitere Features zu aktivieren müssen diese auf true gesetzt und die zugehörigen Variablen angepasst werden.


##### Wifi configuration
* wifi.setmode(wifi.STATION)
* wifi.sta.config("SSID", "PASSWD")
* wifi.sta.connect()


##### Pushingbox device id
* **devid = "xxxxx"**	-> Die DeviceID des Szenarios (Beispiel: "v59BD3A332OEN556") Die Pushingbox DeviceID des Szenarios eingetragen werden das aktviert werden soll wenn die ermittelte Batteriespannung über der ersten Warnspannung liegt. Die Batterie also "OK ist.


##### USE_TEMP_SENSOR -> Temperaturüberwachung (DS18B20) aktivieren

* **tempsensor_pin = 4**
-> Der Pin an dem der DS18B20 angeschlossen ist entsprechend dem NodeMCU I/O Index. Der I/O Index 4 entspricht dem GPIO2. (GPIO TABLE: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#gpio-new-table--build-20141219-and-later)
* **tempsensor_precision = 1**
-> Anzahl der Nachkommastellen auf den der Temperaturwert begrenzt werden soll

##### USE_BATTERY_CHECK -> Batterieüberwachung aktivieren

* **vref = 0.985**	-> Referenzspannung des internen ADC. (Muss zuerst für jedes Modul ermittelt werden. TODO: Beschreiben wie)

* **r1 	= 33000**
* **r2 	= 10000**   -> Widerstandswerte für den Spannungsteiler (r1, r2). Die Werte sind akutell so ausgelegt dass es möglich ist den gesamten Spannungsbereich eines Einzelligen Lipo Akkus zu erfassen. (ca. 3.0V(leer) - 4.2V(voll))

* **bat_info 	= "OK"**
-> Eine zusätzliche Info die in die Nachricht die man bekommt mit $bat_info$ eingebaut werden kann. Standardmäßig wird wenn mit der Batterie alles in Ordnung ist ein OK eingebaut. Also die erste Warnspannung noch nicht unterschritten wurde.

* **warn_volt1 	= 3.7** -> Erste Warnspannung
* **warn_devid1 = "xxxxx"** -> DeviceID des Scenarios das ausgelöst wird wenn die erste Warnspannung unterschritten ist.
* **warn_info1 	= "50%"** -> Inhalt von $bat_info$ wenn die erste Warnspannung unterschritten wurde
* **warn_volt2 	= 3.3** -> Zweite Warnspannung
* **warn_devid2 = "xxxxx"**
-> DeviceID des Scenarios das ausgelöst wird wenn die zweite Warnspannung unterschritten ist.
* **warn_info2 	= "20%"**
-> Inhalt von $bat_info$ wenn die zweite Warnspannung unterschritten wurde.


##### USE_DATE_TIME -> Datum und aktuelle Uhrzeit ermitteln (siehe Quelle 2)

* **time_server_ip = "192.168.1.123"**
-> Der Webserver von dem die Zeit geholt wird
* **time_offset = 1**
-> Die Anzahl der Stunden die dazugerechnet werden sollen falls die ermittelte Zeit abweicht. (TODO: Winter/Sommerzeit, andere Länder)
* **date_translate = true** -> Datum ins Deutsche Format übersetzten (Dec=Dez, Tue=Di,..)
  
##### USE_IPCAM_EVENT -> Zusätzlich ein Event auf einer Axis IP Camera auslösen

* **cam_ip = "192.168.1.18"**	-> IP Addresse (Muss ein String sein!)
* **cam_port = 8001** 	-> Port (Darf kein String sein!)
* **cam_event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"** 	-> Event URL die aufgerufen werden soll
* **cam_base64_pass = "am9oOmpvaA=="** 	-> Die base64 codierten Zugangsdaten ("benutzer:passwort") für die HTTP Basic Authentifizierung

##### USE_WIFI_STRENGTH -> Wlan Signalstärke ermitteln. (Wird diese Funktion aktiviert dauert das verbinden mit dem AP ca. 2-3 Sekunden länger.)
* **SSID = ""** -> SSID vom AccesPoint dessen Signalstärke ermittelt werden soll

#### USE_VREG_SHUTDOWN  -> Kann genutzt werden um einem externen µc das abschalten des Spannungsreglers zu signalisieren
  vreg_shutdown_pin = 2   -> Pin für das Signal (Wird vom ESP wenn er "fertig" ist für 1 Sekunde auf HIGH gesetzt)
  

#### FAILSAVE options

* **max_retries = 3** 	-> Wie oft versucht wird den Request hintereinander zu versenden
* **time_between_requests = 10**  -> Die Wartezeit zwischen den Versuchen
  
##### Reset konfiguration
* **DO_A_RESET = true**  -> Wenn alle Versuche verbraucht sind legt sich der ESP kurz schlafen und versucht es dann noch einmal. Hat es auch nach dem Reset und den ganzen versuchen wieder nicht geklappt legt er sich um Strom zu sparen komplett schlafen. 
* **DO_A_SOFT_RESET = true** -> Anstatt kurz in den Tiefschalf zu gehen direkt einen Software-Reset(node.restart()) machen. PIN32(RST) und PIN8(XPD_DCDC müssen nicht miteinander verbunden sein. Ist diese Option gesetzt kann "DO_A_RESET_SLEEPTIME" ignoriert werden.
* **DO_A_RESET_SLEEPTIME = 15** -> Anzahl der Sekunden die der ESP schläft(deepsleep) bevor er sich resettet und es noch einmal versucht. (Der ESP kann sich nach dem deepsleep nur selber resetten wenn PIN32(RST) und PIN8(XPD_DCDC aka GPIO16) miteinander verbunden sind. Ist das nicht der Fall bleibt er im Tiefschlaf.
* **RESET_SIGNAL_PIN = 1**  -> Dieser Pin wird vom ESP bevor er den Reset macht für 1.5 Sekunden auf HIGH gelegt (kann genutz werden um z.b. einem angeschlossenen µc den Reset mitzuteilen)

##### Logfiles
* **clear_logs_pin = 5** -> Wenn dieser Pin beim Start mit GND verbunden ist werden alle angelegten Logfiles gelöscht

## Installation:

* NodeMCU Firmware flashen (Am besten eine mit )
* Pushingbox Account erstellen, Service adden und Szenario erstellen
    Auf pushingbox.com gehen und anmelden. Dann auf "My Services" klicken und einen Service "adden". Dann unter "My Scenarios" ein neues Scenario erstellen und über "Add an Action" die Service auswählen über die man Benachrichtigt werden will. Nach dem klick auf "Add an action with this service" erscheint ein Eingabe-Fenster(Formular) mit dem die Nachricht die an den Service verschickt wird definiert werden muss. Durch die integration von Variablen lässt sich diese auch dynamisch gestalten.
* config.lua anpassen -> Konfiguration
* Alle Lua Skripte auf den ESP übertragen und auch bis auf die init.lua und die config.lua komplieren. 



## Verfügbare Pushingbox Variablen:

Folgende Variablen lassen sich je nach konfiguration (aktivierte Features in der config.lua) in die Nachricht die von Pushingbox an euch bzw. den/die hinterlegten Service(s) verschickt wird einbauen.

##### Immer Verfügbar
* **$ip$**		    -	Die per DHCP zugewiesene IP Addresse
* **$ip_time$**		-	Die Zeit die es gedauert hat eine IP zu bekommen: 0.00(s)
* **$req_time$**	-	Die Zeit bis die Nachricht verschickt wurde: 0.00(s)

##### Nur wenn USE_BATTERY_CHECK
* **$vbat$**		-	Batteriespannung: 0.00(V)
* **$bat_info$**	-	Der von der Batteriespannung abhängige Info Text (bat_info, warn_info1/2) 

##### Nur wenn USE_WIFI_STRENGTH
* **$rssi$**		-	WLAN Signalstärke in dBm: -44(dBm)
* **$quality$**		-	Signalstärke in Prozent umgerechnet (quality=2*(rssi+100) )

##### Nur wenn USE_TEMP_SENSOR
* **$temperatur$**	-	Aktuelle Temperatur: 0.0 (Die Anzahl der Nachkommstellen ist abhängig von der Variable 'precision')

##### Nur wenn USE_DATE_TIME
* **$date$**		-	Datum: Mi 15 Jul 2015
* **$time$**		-	Uhrzeit: 00:00:00
* **$time_n$**		-	Uhrzeit: 00:00


.:.
#### Ein schönes Beispiel Projekt findet man hier:
RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108

.:.

## Resourcen / Quellen:

1. https://github.com/8n1/briefkastenwaechter (-> Die ersten Versionen)
2. http://benlo.com/esp8266/esp8266Projects.html (-> Ask Google for the Time)
3. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en (-> NodeMCU API)
4. https://www.pushingbox.com/api.php (-> Variablen)
5. http://frightanic.com/nodemcu-custom-build/ (-> Hier kann man sich eine aktuelle Firmware erstellen lassen)

##### Tags: ESP8266, NodeMCU, Lua, Pushingbox, DeepSleep, Batterie, Spannung, Überwachung, Zustand, Spannungsteiler, ADC, DS18B20, Axis IP Cam Event, Pushnachricht,
