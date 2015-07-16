## nodemcu-briefkastenwaechter
NodeMCU Briefkastenwaechter mit DS18B20 Temperatur Sensor, Uhrzeit, IP Cam Event + Batterieüberwachung


## Update(s)
Changelog - 15.07.2015
* Gesamte konfiguration über eine einzige Datei (config.lua)
* Batterieüberwachung mittels Spannungsteiler
* Alles umfangreicher konfigurierbar; Neue Pushingbox Variablen ($vbat$, $ip$, ...)
* Wahlweise Statische oder dynamische IP
* Wifi Signalstärke wird mitgeschickt: $rssi$, $quality$ (erst ab nodemcu_float_0.9.6-dev_20150627)


## Intro
Eine inzwischen sehr umfangreich erweiterte Version des einfachen Briefkastenwächters (https://github.com/8n1/NodeMCU-Briefkastenwaechter). 
...


## Ablauf/Features:
* Verbindet sich nach dem anlegen der Batteriespannung oder einem Reset automatisch mit dem gespeicherten WLAN Netzwerk (Wahlweise mit Statischer oder Dynamischer IP)


* Ermittelt die Wlan Signalstärke (RSSI) (Erst ab nodemcu_float_0.9.6-dev_20150627 verfügbar !) (**optional**)
* Ermittelt die Batteriespannung mit einem Spannungsteiler und dem internen ADC (**optional**)
* Liest die akutelle Temperatur von einem DS18B20 Temperatursensor aus (**optional**)
* Löst ein frei definierbares Event auf einer (mittels HTTP Basic Authentifizierung gesicherten) Axis IP Cam aus. Schickt z.B. ein Foto. (**optional**)


* Aktiviert ein Pushingbox Szenario entsprechend der Konfiguration. Dabei werden auch die gesammelten Informationen in Form von Variablen mit an Pushingbox übertragen. Diese Variablen können dann in die Nachricht die von Pushingbox an euch bzw. den hinterlegten Service(Verfügbare services: http://i.imgur.com/xr65rBj.png) verschickt wird eingebaut werden. (https://www.pushingbox.com/api.php)


* Legt sich wieder schlafen (DeepSleep).


## Geplante Erweiterungen:
* Batterieüberwachung mittels internem ADC (**FERTIG - 15.07.2015**)
* Konfiguration und Test über eine einfache Weboberfläche
* Kleines Skript um alle Dateien auf den ESP hochzuladen
* Verbindung mit dem WLAN nicht mehr per Timer Alarm sonder per eventMonReg()
* Alternativen für Pushingbox

### Bugs:
* Winter/Sommerzeit wird noch nicht berücksichtigt

## Konfiguration: config.lua
Die gesamte Konfiguration erfolgt jetzt über die config.lua. Es muss also nur diese Datei angepasst werden.
...

##### SET FEATURES
-> Um ein bestimmtes Feature zu aktivieren muss es auf true gesetzt. Anschließend müssen die zum Feature gehörenden Variablen angepasst werden.

* **use_static_ip		= false**	-> Statt einer Dynamischen eine Statische IP verwenden

* **use_battery_check 	= true**	-> Batterieüberwachung aktivieren
* **use_temp_sensor 	= true**	-> Temperatursensor (DS18B20) verwenden
* **use_date_time 		= true**	-> Datum und aktuelle Uhrzeit ermitteln (siehe Quelle 2)
* **use_ipcam_event 	= false**	-> Event auf einer (AXIS) IP Camera auslösen

* **use_single_devid 	= true**	-> Ein einziges Scenarios/Device ID verwenden. Oder mehrere (devid, warn_devid1, warn_devid2) die abhänig von den festgelegten Warnspannungen ausgelöst/aktiviert werden.

* **use_wifi_strength = false**		-> Wlan Signalstärke ermitteln. Erst ab der Version nodemcu_float_0.9.6-dev_20150627 verfügbar!


##### WIFI configuration
**--wifi.sta.config("SSID", "PASSWD")**	-> Wlan Zugansdaten. 


##### Pushingbox device id
* **devid = "xxxxx"**	-> Die Pushingbox DeviceID des Szenarios eingetragen werden das aktviert werden soll wenn die ermittelte Batteriespannung über der ersten Warnspannung liegt. Die Batterie also OK ist.


##### Wenn use_static_ip
* **sensor_ip 		= "192.168.0.126"**	-> IP Addresse
* **sensor_netmask 	= "255.255.255.0"**	-> Netzmaske
* **sensor_gateway	= "192.168.0.1"**	-> Standard Gateway

##### Wenn use_battery_check
* **vref = 0.985**	-> Referenzspannung des internen ADC. Muss ermittelt werden. Todo: beschreiben wie


* **r1 	= 33000**
* **r2 	= 10000**   -> Widerstandswerte für den Spannungsteiler (r1, r2). Die aktuelle konfiguration ist auf einen Lipo Akku ausgelegt (ca. 3.0V(leer) - 4.2V(voll)).


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

##### Wenn  use_temp_sensor
* **tempsensor_pin = 4**
-> Der Pin an dem der DS18B20 angeschlossen ist entsprechend dem NodeMCU I/O Index. Der I/O Index 4 entspricht dem GPIO2. (GPIO TABLE: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#gpio-new-table--build-20141219-and-later)
* **precision = 1**
-> Anzahl der Nachkommastellen auf den der Temperaturwert begrenzt werden soll.

##### Wenn use_date_time
* **time_server_ip = "192.168.0.123"**
-> Der Webserver von dem die Zeit geholt wird.
* **time_offset = 1**
-> Die Anzahl der Stunden die dazugerechnet werden sollen falls die ermittelte Zeit abweicht. (TODO: Winter/Sommerzeit beachten)

##### Wenn use_ipcam_event
* **cam_ip = "192.168.0.18"**	-> IP Addresse
* **cam_port = 8001** 	-> Port (Darf kein String sein!)
* **event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"** 	-> Event URL die aufgerufen werden soll
* **base64_pass = "am9oOmpvaA=="** 	-> Die base64 codierten Zugangsdaten (benutzer:passwort) für die HTTP Basic Authentifizierung


##### dev stuff
* **dhcp_startup_time 	= 1000**
-> Zeitkonstante für den Timer Alarm mit dem geprüft wird ob wird eine IP haben (use_static_ip != true)
* **static_startup_time = 500**
 -> Zeitkonstante für den Timer Alarm bei verwendung einer Statischen IP. (use_static_ip == true)
* **timout = 10**
 -> Die Anzahl der Sekunden dem ESP maximal gelassen wird um sich mit dem WLAN zu verbinden und das Scenario auszulösen bevor er wieder in den Tiefschlaf versetzt wird. Falls z.B. der AP nicht erreichbar ist.
* **DEBUG = false**
 -> Trockenlauf. Es wird kein Pushingbox Scenario ausgelöst.



## Installation:

* NodeMCU Firmware flashen (Um alle Features verwenden zu können muss diese verwendet werden:  https://github.com/nodemcu/nodemcu-firmware/releases/tag/0.9.6-dev_20150627 - bei der neuesten(0.9.6-dev_20150704) gibt es noch Probleme. Alternativ kann auch die letzte 0.9.5 verwendet werden: https://github.com/nodemcu/nodemcu-firmware/releases/tag/0.9.5_20150318. Dann fällt allerdings die Wlan Signalstärke weg.)
* config.lua anpassen
* Alle Lua Skripte auf den ESP übertragen und auch bis auf die init.lua und die config.lua komplieren. 


## Verfügbare Pushingbox Variablen:

Folgende Variablen lassen sich je nach konfiguration (aktivierte Features in der config.lua) in die Nachricht die von Pushingbox an euch bzw. den hinterlegten Service verschickt wird einbauen.

##### Immer Verfügbar
* **$ip_time$**		-	Die Zeit die es gedauert hat eine IP zu bekommen: 0.00
* **$ip$**			-	IP Addresse

##### Erst ab nodemcu_float_0.9.6-dev_20150627 !
* **$rssi$**		-	WLAN Signalstärke in dBm: -44
* **$quality$**		-	Signalstärke (dBm) umgerechnet in Prozent ( quality=2*(rssi+100) )

##### Nur wenn use_battery_check
* **$vbat$**		-	Batteriespannung: 0.00
* **$bat_info$**	-	Der zu der Batteriespannung passende InfoText

##### Nur wenn use_temp_sensor
* **$temperatur$**	-	Aktuelle Temperatur: 0.0 (Nachkommstellen abhängig von 'precision')

##### Nur wenn use_date_time
* **$date$**		-	Datum: Wed 15 Jul 2015
* **$time$**		-	Uhrzeit: 00:00:00
* **$time_n$**		-	Uhrzeit: 00:00
* **$seconds$**		- 	Sekunden: 00


.:.
#### Das erwähnte Beispiel Projekt findet man hier:
RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108

#### Weitere Einsatzmöglichkeiten:
* Twitternde-, Email versendende-, Push aufs Smartphone -Dinge (Katzentür, Raumüberwachung/Alarmanlage z.B. durch kopplung mit einem PIR Sensor, Türklingel, ...)

.:.

## Resourcen / Quellen:

1. https://github.com/8n1/briefkastenwaechter
2. http://benlo.com/esp8266/esp8266Projects.html (-> Ask Google for the Time)
3. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en
4. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#wifistagetap (-> get RSSI for currently configured AP)
5. https://www.pushingbox.com/api.php

##### Tags: ESP8266, NodeMCU, Lua, Pushingbox, Axis IP Cam, DeepSleep, Battery Voltage, Voltage Divider
