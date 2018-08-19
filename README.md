# vectR

## Getting started

### Installation

Die neueste Version von vectR lässt sich mit folgenden Anweisungen installieren.

> **Wichtig**
>
> Um sicher zu gehen das die Package auf die neueste Version geupdatet wird sollte `force = TRUE` im `install_github` Befehl genutzt werden. 



```R
install.packages("devtools")
library(devtools)
# package installieren
devtools::install_github("helderheit/vectR", force = TRUE)
# package laden
library(vectR)
```



> **Hinweis:**
>
> Informationen zur aktuellen Version und zu neuen  Features finden sich [hier](https://homepages.uni-regensburg.de/~alf17802/).

### 

### Zugang

```R
VectR("https://vecter.org",username="your.username")
```

### 

### Tweets abrufen

```R
tweets <- getTweets("Your Collection", start_date = "2017-12-31", end_date = "2018-05-01")
```

