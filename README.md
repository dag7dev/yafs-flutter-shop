# yafs_flutter_shop
YAFS - Yet Another Flutter Shop - un piccolo store costruito in Flutter

## Descrizione
Un piccolo shop realizzato interamente con il framework [Flutter](https://github.com/flutter/flutter) PWA.
Live demo disponibile qui: [https://dag7.it/yafslive](dag7.it/yafslive)

## Requisiti
Il progetto è stato realizzato mediante l'IDE "Android Studio", opportunamente configurato per utilizzare il plugin "Flutter".

Versione di Flutter utilizzata: dev, 1.26.0-1.0.pre

#### Piccola nota su Flutter
Flutter è un framework realizzato da Google con l'obiettivo di costruire applicazioni cross-platform per Android e iOS in maniera semplice e senza troppo sforzo.

Flutter PWA è la parte del framework che viene utilizzata per la realizzazione di applicazioni che possono essere eseguite da browser.

La filosofia utilizata è "un codice, molte piattaforme".

(Flutter PWA è disponibile unicamente su tutti i canali tranne quello 'stable', sarà sufficiente scaricare la versione di Flutter più recente che non appartenga al branch stable).

#### Informazioni sull'ambiente di testing
L'ambiente di sviluppo utilizzato è Linux.

Per testare il sito in locale è stato utilizzato Python http.server

Il sito non è stato testato "come app" ma solo come sito web: testato su Android con Brave Browser e Firefox e da Iphone con Safari, oltre all'ovvio test da desktop mediante Chromium e Firefox.

## Istruzioni
0. Installare AndroidStudio o avere Android SDK installato e configurato.
1. Installare Flutter da un canale diverso dalla stable (istruzioni [qui](https://flutter.dev/docs/get-started/install))
2. Lanciare da terminale: ```flutter config --enable-web```
3. Clonare la repo: ```git clone git@github.com:dag7dev/yafs_flutter_shop.git```
4. Lanciare da terminale nella root del progetto: ```flutter build web```

Il risultato dell'elaborazione sarà disponibile nella cartella `PATH/TO/YAFS/yafs_flutter_shop/build/web/`

#### Testing
Per testare il sito in locale sarà sufficiente avere il modulo http.server di Python3 (incluso con le più recenti versioni di Python) e digitare da `PATH/TO/YAFS/yafs_flutter_shop/build/web/` il comando `python3 -m http.server`

Se si desidera testare il sito su un server, ricordarsi di modificare il file `PATH/TO/YAFS/yafs_flutter_shop/build/web/index.html` e sostituire l'href con la cartella di deployment del vostro sito (in caso fosse diversa dalla root).

## Descrizione UI
L'applicazione esattamente come da richiesta implementa le funzioni "Prodotti" e "Carrello" utilizzando l'API messa a disposizione da FakeAPIStore.

Siccome quella particolare API non salva le modifiche fatte nel carrello ecc, ho provveduto ad implementare da zero un carrello funzionante (all'atto pratico finale basterà cambiare e fare in modo che funzioni "backend").

All'avvio dell'applicazione, verrà mostrata la pagina relativa ai prodotti con le relative informazioni: titolo, categoria, immagine, prezzo e il bottone che permetterà di aggiungere al carrello quel particolare prodotto.

Ogni qualvolta che si farà click su "aggiungi al carrello" verrà mostrata una modale, a seconda se il prodotto era già stato aggiunto oppure no.

Nota sui prodotti: se si clicca su tutto il prodotto, ad eccezione del pulsante "aggiungi al carrello", la card si girerà di 180 gradi sull'asse orizzontale e mostrerà la descrizione.

Il pulsante carrello invece è posizionato in alto a destra: quando si farà click su di esso verranno mostrati gli articoli precedentemente aggiunti, un + e - con una casella di testo (SpinBox) che permetterà di aggiungere o rimuovere eventuali articoli dal carrello, una box relativa al totale e due pulsanti incolonnati: "paga ora" e "svuota carrello".

Facendo click sul secondo, verrà azzerato il carrello ed eventuali modifiche andranno perse (esse andranno comunque perse a seguito del ricaricamento della pagina).
