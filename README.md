
## Despre

 - [Vector Editor](https://vector-editor.netlify.app/) este o aplicatie web ce are ca scop crearea de imagini svg intr-un mod intuitiv si rapid.
 - Aplicatia nu este recomandata pentru folosirea in productie, ci pentru crearea de prototipuri de catre client pentru un profesionist care va incerca sa ii satisfaca nevoile.
 - Aplicatia este open source sub licenta MIT asa ca atat timp cat cineva nu incearca sa o vanda sub propriul nume, codul sursa este disponibil si poate fi modificat in functie de nevoile utilizatorului.
 

## Functionalitati

 - La momentul actual [Vector Editor](https://vector-editor.netlify.app/) dispune de functionalitati drag and drop si campuri de input pentru crearea de forme geometrice si pentru modificarea proprietatilor acestora.
 - Aplicaitia este formata din o **zona de editare** a formelor si o **bara laterala** cu multiple meniuri.
 - **Zona de editare**
	 - Spatiul de desfasurare a crearii si editarii de forme geometrice prin drag and drop.
- **Bara laterala**
	- Este folosita pentru a schimba intre meniurile aplicatiei
	- Aceasta contine urmatoarele file:
		1. Fila zonei de editare - folosita pentru a editata proprietatiile zonei de editare prin campuri de input.
		2. Fila de unelte - folosita pentru a alege unealta potrivita situatiei.
		3. Fila de proprietati - folosita pentru a modifica proprietatiile formei gemoetrice selectate.
		4. Fila de salvare - folosita pentru descarcarea proiectelor sub forma de imagini svg, pentru salvarea lor sub format json sau pentru incarcarea proiectelor editate in trecut.
	 - Uneltele de creare sau editare a formelor prezente sunt urmatoarele:
		 1. Selector - aceasta unealta poate fi folosita pentru selectarea formelor si editarea lor prin drag and drop.
		 2. Rect - unealta pentru crearea de dreptunghiuri
		 3. Ellipse - unealta pentru crearea de elipse
		 4. Polyline - unealta pentru creare de linii simple sau linii frante deschise
		 5. Polygon - unealta pentru crearea de poligoane

## Ghid de instalare
Instalarea se face prin descarcarea acestui repository si rularea comenzii urmatoare in folderul radacina.

    elm make src/Main.elm --output=static/build/index.js
   
   Pentru a rula aplicatia se deschide fisierul **index.html** din folderul **static** intr-un browser precum Chrome sau Firefox actualizat la o versiune relativ recenta.
 
## Tehnologii alese

 - Logica din spatele aplicatiei este scrisa in limbajul de programare pur functional [Elm](https://elm-lang.org/) ce a fost ales pentru motivele care pot fi gasite pe site-ul principal.
 
 
