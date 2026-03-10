# Wizualizacja danych The Eras Tour w Shiny

## O projekcie
Projekt realizowany w ramach przedmiotu Wstęp do Eksploracji danych na kierunku Matematyka i Analiza Danych na Politechnice Warszawskiej.
Miał na celu stworzenie interaktywnej aplikacji w R Shiny, służącej do wizualizacji danych na temat trasy koncertowej The Eras Tour.

## Podgląd aplikacji
<img width="1918" height="1017" alt="app1" src="https://github.com/user-attachments/assets/9b416809-03b2-47a6-b207-f20086ef7955" />
<img width="1918" height="1020" alt="app3" src="https://github.com/user-attachments/assets/8bbd299d-eb34-4116-89f0-049c971e7ff7" />
<img width="1918" height="1017" alt="app4" src="https://github.com/user-attachments/assets/4a0c1181-a057-4ea4-8264-bfb21514deb1" />
<img width="1918" height="1017" alt="app5" src="https://github.com/user-attachments/assets/74c89070-0c8f-40c4-8e64-7381888b58a4" />

## Mój wkład w projekt
Projekt był wykonany w zespole trzyosobowym. Mój wkład był następujący:
* **Eksploracja danych**: Poszukiwania oraz wybór danych do projektu
**Analiza i wizualizacja** w R (dplyr, ggplot2, shiny):
* **Wykres kafelkowy** przedstawiający liczbę piosenek z poszczególnych albumów dla wybranej daty koncertu
* **Wykres punktowy** przedstawiający analizę wybranej cechy (np. energia  (energy), akustyczność (acousticness)) dla kolejnych piosenek z setlisty koncertu. Możliwa jest opcja wyświetlenia linii trendu dla każdej z cech.

## Zawartość repozytorium
* `app_final.R` - plik z całością kodu, który umożliwia uruchomienie interaktywnego dashboardu Shiny
* `setlist.csv` - plik z danymi o setliście koncertowej wraz z cechami poszczególnych piosenk
* `ts_df.csv` - plik z danymi o trasie koncertowej

## Technologie
* Język programowania: R
* Pakiety: shiny, dplyr, ggplot2

## Źródła danych
1. [Setlista koncertowa (Kaggle)](https://www.kaggle.com/datasets/yukawithdata/taylor-swift-the-eras-tour-official-setlist-data)
2. [Dane o trasie koncertowej (Kaggle)](https://www.kaggle.com/datasets/tymonbot/taylor-swift-eras-toure)
3. Dane o popularnosci poszczególnych tras:
   [Reputation](https://en.wikipedia.org/wiki/Reputation_Stadium_Tour#Records)
   [1989](https://touringdata.wordpress.com/2023/11/19/taylor-swift-1989-tour/)
   [Speak Now](https://en.wikipedia.org/wiki/Speak_Now_World_Tour)
   [Red](https://en.wikipedia.org/wiki/The_Red_Tour)
   [Eras Tour](https://time.com/7199590/taylor-swift-eras-tour-final-numbers/)
