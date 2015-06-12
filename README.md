# briefkastenwaechter-mit-temp-sensor-uhrzeit-und-ipcam-event
NodeMCU Briefkastenwaechter mit DS18B20 Temperatur Sensor, Uhrzeit und IP Cam Event trigger.

Hier handelt es sich um eine für das unten erwähnte Projekt erweiterte Version des "einfachen" Briefkastenwächters: https://github.com/8n1/briefkastenwaechter

## Features / Ablauf:
* Verbindet sich mit dem WLAN
* Löst ein bestimmtes Event auf einer IP Cam aus. (Schickt z.B. ein Foto)
* Aktiviert ein Pushingbox Szenario und übergibt dabei Datum, Uhrzeit und Temperatur. Diese Werte können mit den Schlüsselworten $date$ , $time$ und $temperatur$ in die Nachricht(Message) die dann von Pushingbox an euch verschickt wird eingebaut werden.
* Legt sich wieder schlafen (-> DeepSleep). Nach einem Reset wiederholt sich die ganze Prozedur. 

Datum und Uhrzeit werden von einem beliebigen Webserver geholt, Die Temperatur kommmt von einem DS18B20.

## Geplante Erweiterungen:
* Batterieüberwachung

## Konfiguration:

* **devid = "xxxxx"**
-> Hier muss die Pushingbox Device ID des Szenarios eingetragen werden das aktviert werden soll.

* **tempsensor_pin = 4**
-> Der Pin an dem der DS18B20 angeschlossen ist entsprechend dem NodeMCU I/O Index. Der I/O Index 4 entspricht GPIO2.

* **precision = 1**
-> Anzahl der Nachkommastellen des Temperaturwertes.

* **time_server_ip = "192.168.1.123"**
-> Der WebServer von dem die Zeit geholt wird. (Siehe Quelle 2)

* **time_offset = 0**
-> Die Anzahl der Stunden die dazugerechnet werden sollen falls die ermittelte Zeit von der tatsächlichen abweicht. 


## Installation:

Die ganzen Lua Skripte auf dem ESP Modul speichern und alle bis auf die init.lua komplieren. 

.:.

### Das erwähnte Projekt findet man hier:

RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108

.:.

## Resourcen / Quellen:

1. https://github.com/8n1/briefkastenwaechter
2. http://benlo.com/esp8266/esp8266Projects.html (-> Ask Google for the Time)
3. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en

### Tags: ESP8266, NodeMCU, Lua, Pushingbox, Axis IP Cam, DeepSleep
