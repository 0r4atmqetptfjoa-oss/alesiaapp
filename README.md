# Muzica Magica (Demo UI)

Acesta este un prototip al aplicației "Muzica Magica" pentru copii, construit
în Flutter. Proiectul cuprinde o temă vizuală și patru ecrane principale
conform specificațiilor discutate:

* **Home** – meniul principal cu trei butoane: instrumente, sunete și povești/jocuri.
* **Xylophone** – xilofon colorat; fiecare bară se animă la apăsare.
* **Drums** – set de tobe circulare care se animă la apăsare.
* **Sounds** – grilă de carduri pentru sunete; fiecare card afişează un număr şi o pictogramă.

Pachetul nu include logică audio sau baze de date, ci servește ca schelet
grafic pentru a extinde ulterior aplicația. Pentru a rula aplicația pe
dispozitiv, asigurați-vă că aveți Flutter instalat și lansați:

```bash
flutter run
```

Modificările viitoare pot adăuga:

* Integrarea `just_audio` și `soundpool` pentru playback audio.
* Persistența progresului și setărilor folosind `drift`.
* Ecrane suplimentare pentru animale, jocuri educative și povești.
* Mecanismul de monetizare descris anterior (fereastră de 40 de minute fără reclame, IAP Remove Ads).

Enjoy building!