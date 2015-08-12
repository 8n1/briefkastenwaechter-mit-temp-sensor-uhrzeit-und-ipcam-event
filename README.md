## NodeMCU - Reset Briefkastenwaechter


## Intro
...


## Ablauf/Features:
* Verbindet sich nach einem Reset oder dem anlegen der Batteriespannung automatisch mit dem hinterlegten Wlan Netzwerk


* Ermittelt die Batteriespannung (Spannungsteiler und interner ADC) (**optional**)
* Liest die akutelle Temperatur aus einem DS18B20 aus (**optional**)
* Holt sich die aktuelle Uhrzeit und Datum von einem beliebigen Webserver (**optional**)
* Löst ein frei definierbares Event auf einer mittels HTTP Basic Authentifizierung gesicherten Axis IP Cam aus. Schickt z.B. ein Foto. (**optional**)


* Aktiviert ein Pushingbox Szenario entsprechend der Konfiguration
  Die gesammelten Informationen werden dabei als Paramter mit an Pushingbox übertragen. Diese Variablen können dann in die Nachricht die von Pushingbox an euch bzw. den hinterlegten Service (Verfügbare Services: http://i.imgur.com/xr65rBj.png) verschickt wird eingebaut werden. 


* Legt sich wieder schlafen (Infinite DeepSleep)
  Nach einem Reset wiederholt sich die ganze Prozedur.


## Hardware
TODO Schaltplan

## Unterstzütze ESP Module
Getestet mit ESP-01 und ESP-12. Sollte aber auf allen laufen.
Das einzige was man beachten muss ist das um die Batteriespannung messen zu können im besten Fall der ADC Pin TOUT auf dem Board das man verwenden will herausgeführt sein sollte.


## Geplante Erweiterungen:
* Batterieüberwachung mittels internem ADC (**FERTIG - 15.07.2015**)
* Kleines Skript um alle Dateien auf den ESP hochzuladen
* Konfiguration und Test über eine einfache Weboberfläche
* Verbindung mit dem WLAN nicht mehr per Timer Alarm sonder per wifi.sta.eventMonReg()
* Alternativen für Pushingbox


### Bugs:
* Winter/Sommerzeit wird noch nicht berücksichtigt
* In ganz seltenen Fällen kann es passieren das kein 


## Konfiguration: config.lua
Die gesamte Konfiguration erfolgt über die config.lua. Es muss nur diese Datei angepasst werden.

Was mindestens definiert werden muss sind die Wlan Zugangsdaten und die Pushingbox Device ID des Szenarios das aktiviert werden soll. 

Um ein weiteres Feature zu aktivieren muss es auf true gesetzt und die zugehörigen Variablen angepasst werden.


##### Wifi configuration
* **Wifi configuration**
SSID = ""
--wifi.setmode(wifi.STATION)
--wifi.sta.config(SSID, "PASSWD")
--wifi.sta.connect()


##### Pushingbox device id
* **devid = "xxxxx"**	-> Die DeviceID des Szenarios (Beispiel: "v59BD3A332OEN556") Die Pushingbox DeviceID des Szenarios eingetragen werden das aktviert werden soll wenn die ermittelte Batteriespannung über der ersten Warnspannung liegt. Die Batterie also OK ist.


##### USE_TEMP_SENSOR
* **USE_TEMP_SENSOR 	= false**	-> Temperatursensor (DS18B20) verwenden

* **tempsensor_pin = 4**
-> Der Pin an dem der DS18B20 angeschlossen ist entsprechend dem NodeMCU I/O Index. Der I/O Index 4 entspricht dem GPIO2. (GPIO TABLE: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#gpio-new-table--build-20141219-and-later)
* **precision = 1**
-> Anzahl der Nachkommastellen auf den der Temperaturwert begrenzt werden soll.

##### USE_BATTERY_CHECK
* **USE_BATTERY_CHECK 	= false**	-> Batterieüberwachung aktivieren und Batteriespannung ermitteln

* **vref = 0.985**	-> Referenzspannung des internen ADC. (Muss zuerst für jedes Modul ermittelt werden. TODO: Beschreiben wie)

* **r1 	= 33000**
* **r2 	= 10000**   -> Widerstandswerte für den Spannungsteiler (r1, r2). Die Werte sind akutell so ausgelegt dass sie  konfiguration ist auf einen Lipo Akku ausgelegt (ca. 3.0V(leer) - 4.2V(voll)).

* **bat_info 	= "OK"**
-> Eine zusätzliche Info die in die Nachricht die man bekommt mit $bat_info$ eingebaut werden kann. Standardmäßig wird wenn mit der Batterie alles in Ordnung ist ein OK eingebaut. Also die erste Warnspannung noch nicht unterschritten wurde.

* **warn_volt1 	= 3.7** -> Erste Warnspannung
* **warn_devid1 = "xxxxx"** -> DeviceID des Scenarios das ausgelöst wird wenn die erste Warnspannung unterschritten ist. 
* **warn_info1 	= "50%"** -> Inhalt von $bat_info$ wenn die erste Warnspannung unterschritten wurde
* **warn_volt2 	= 3.3**
-> Zweite Warnspannung
* **warn_devid2 = "xxxxx"**
-> DeviceID des Scenarios das ausgelöst wird wenn die zweite Warnspannung unterschritten ist. 
* **warn_info2 	= "20%"**
-> Inhalt von $bat_info$ wenn die zweite Warnspannung unterschritten wurde


##### USE_DATE_TIME
* **USE_DATE_TIME 	= false**	-> Datum und aktuelle Uhrzeit ermitteln (siehe Quelle 2)

* **time_server_ip = "192.168.1.123"**
-> Der Webserver von dem die Zeit geholt wird.
* **time_offset = 1**
-> Die Anzahl der Stunden die dazugerechnet werden sollen falls die ermittelte Zeit abweicht. (TODO: Winter/Sommerzeit beachten)

##### USE_IPCAM_EVENT
* **USE_IPCAM_EVENT 	= false**	-> Event auf einer Axis IP Camera auslösen

* **cam_ip = "192.168.1.18"**	-> IP Addresse (Muss ein String sein!)
* **cam_port = 8001** 	-> Port (Darf kein String sein!)
* **event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"** 	-> Event URL die aufgerufen werden soll
* **base64_pass = "am9oOmpvaA=="** 	-> Die base64 codierten Zugangsdaten (benutzer:passwort) für die HTTP Basic Authentifizierung

##### USE_WIFI_STRENGTH
* **USE_WIFI_STRENGTH = false**		-> Wlan Signalstärke ermitteln.



## Installation:


* NodeMCU Firmware flashen (Getestet und entwickelt mit: nodemcu_float_0.9.5_20150318.bin)
* Pushingbox Account erstellen, Service adden und Szenario erstellen
    Auf pushingbox.com gehen und anmelden. Dann auf "My Services" klicken und einen Service "adden". Dann unter "My Scenarios" ein neues Scenario erstellen und über "Add an Action" die Service auswählen über die man Benachrichtigt werden will. Nach dem klick auf "Add an action with this service" erscheint ein Eingabe-Fenster(Formular) mit dem die Nachricht die an den Service verschickt wird definiert werden muss. Durch die integration von Variablen lässt sich diese auch dynamisch gestalten.
* config.lua anpassen -> Konfiguration
* Alle Lua Skripte auf den ESP übertragen und auch bis auf die init.lua und die config.lua komplieren. 



## Verfügbare Pushingbox Variablen:

Folgende Variablen lassen sich je nach konfiguration (aktivierte Features in der config.lua) in die Nachricht die von Pushingbox an euch oder den hinterlegten Service verschickt wird einbauen.

##### Immer Verfügbar
* **$ip$**		-	Die per DHCP zugewiesene IP Addresse
* **$ip_time$**		-	Die Zeit die es gedauert hat eine IP zu bekommen: 0.00(s)
* **$req_time$**	-	Dauer bis zum Pushingbox Request: 0.00(s)

##### Nur wenn USE_BATTERY_CHECK
* **$vbat$**		-	Batteriespannung: 0.00(V)
* **$bat_info$**	-	Der zu der Batteriespannung passende InfoText

##### Nur wenn USE_WIFI_STRENGTH
* **$rssi$**		-	WLAN Signalstärke in dBm: -44(dBm)
* **$quality$**		-	Signalstärke in Prozent umgerechnet (quality=2*(rssi+100) )

##### Nur wenn USE_TEMP_SENSOR
* **$temperatur$**	-	Aktuelle Temperatur: 0.0 (Anzahl der Nachkommstellen ist abhängig von der Variable 'precision')

##### Nur wenn USE_DATE_TIME
* **$date$**		-	Datum: Wed 15 Jul 2015
* **$time$**		-	Uhrzeit: 00:00:00
* **$time_n$**		-	Uhrzeit: 00:00


.:.
#### Das erwähnte Beispiel Projekt findet man hier:
RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108

.:.

## Resourcen / Quellen:

1. https://github.com/8n1/briefkastenwaechter
2. http://benlo.com/esp8266/esp8266Projects.html (-> Ask Google for the Time)
3. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en
4. https://www.pushingbox.com/api.php (-> Variablen)

##### Tags: ESP8266, NodeMCU, Lua, Pushingbox, DeepSleep, Batterie, Spannung, Überwachung, Zustand, Spannungsteiler, ADC, DS18B20, Axis IP Cam Event,
