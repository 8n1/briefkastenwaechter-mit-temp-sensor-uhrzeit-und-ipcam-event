# briefkastenwaechter-mit-temp-sensor-uhrzeit-und-ipcam-event
Briefkastenwaechter mit DS18B20 Temperatur Sensor, Uhrzeit und IP Cam Event trigger.

Hier handelt es sich um eine für das unten erwähnte Projekt erweiterte Version des "einfachen" Briefkastenwächters: https://github.com/8n1/briefkastenwaechter

Features / Ablauf:
* Verbindet sich mit dem WLAN
* Löst ein bestimmtes Event auf einer IP Cam aus. (Schickt z.B. ein Foto)
* Aktiviert ein Pushingbox Szenario und übergibt dabei Datum, Uhrzeit und Temperatur. Diese Werte können mit den Schlüsselworten $date$ , $time$ und $temperatur$ in die Nachricht(Message) die über Pushingbox verschickt werden soll eingebaut werden.

Datum und Uhrzeit werden von einem beliebigen Webserver geholt, Die Temperatur kommmt von einem DS18B20.

Konfiguration:
TODO

Installation:
TODO

Resourcen / Quellen:
TODO

.:.

Ein Beispielprojekt findet man hier:

RasPiPo(st) 2 - Der Briefkasten verschickt E-Mails - http://www.forum-raspberrypi.de/Thread-hardware-automatisierung-raspipo-st-2-der-briefkasten-verschickt-e-mails?pid=159108#pid159108
