# I. Wstęp

**TMGraph** jest typowym programem malarskim, umożliwiającym przygotowanie
kolorowych obrazków. Dzięki zastąpieniu tradycyjnego menu tekstowego zestawem
ikonek symbolizujących poszczególne opcje staje się bardzo przyjemną praca z
programem, natomiast zapis grafiki w standardowym formacie graficznym BMP
(*BitMaP* - zaprojektowanym przez firmę Microsoft) umożliwia jej wykorzystanie
w innym programie graficznym (np. Paintbrush dla Windows tej samej firmy).
Program wykorzystuje tryb 256-kolorowy karty graficznej VGA, dzięki czemu
nadaje się również do obróbki zdjęć. Jedynym ograniczeniem jest zapis grafiki
o niezmiennej wielkości 320/200 punktów z wykorzystaniem pełnej palety 256
kolorów, co w pewnym stopniu ogranicza import grafiki z innych programów.
Jednak mimo to program jest godną polecenia pozycją dla początkujących
grafików (i nie tylko).

# II. Wymagania sprzętowe:

Program ten posiada niezbyt wygórowane wymagania sprzętowe. Aby instalacja
była możliwa zestaw komputerowy musi spełniać następujące wymagania:

- system operacyjny DOS w wersji 3.1 lub późniejszej
- komputer klasy IBM XT/AT lub zgodny
- minimum 300 kB wolnej pamięci RAM
- przynajmniej 300 kB wolnej pamięci na dysku
- zalecany dysk twardy lub ewentualnie napęd dysków elastycznych
- karta grafiki VGA lub SVGA
- mysz lub trackball ( praca bez myszy lub trackball'u jest niemożliwa ).
- zalecany kolorowy monitor.

# III. Użytkowanie programu

## 1. Uruchomienie

Program uruchamiamy poleceniem `TMGRAPH.EXE`. Możemy go uruchomić z następującymi
parametrami:
- `-I`, `-i` : program nie wyświetla informacji o autorze i dystrybutorach.
- `-P`, `-p` : wyświetlana jest pomoc kontekstowa podczas pracy u góry ekranu.

Podczas uruchomienia mogą wystąpić następujące błędy:

 - brak wolnej pamięci RAM. Należy w tym celu usunąć z pamięci zbędne programy
 rezydujące typu TSR.

 - Mysz nie zainstalowana lub zły typ myszy. Gdy sterownik myszy nie jest
 zainstalowany, to należy go przed uruchomieniem programu zainstalować.
 Gdy natomiast program nie chce się uruchomić po zainstalowaniu sterownika,
 to oznacza, że zainstalowany sterownik nie jest zgodny z wymaganym
 (np. DEXA).

 - błędny parametr wywołania. Można podać tylko dwa wyżej wymienione parametry
 wywołania (np. `TMGRAPH -i -p`)

## 2. Obsługa

Program obsługiwany jest wyłącznie przy pomocy myszy dwu- lub trzyklawiszowej.
Za pomocą lewego klawisza myszy możemy uruchomić daną opcję a za pomocą
prawego uzyskać informacje na temat wybranej opcji. Opcje wybieramy
w następujący sposób:

Ustawiamy kursor myszy na wybranej ikonie symbolizującej daną opcję a
następnie naciskamy prawy lub lewy klawisz myszy w zależności od tego, co
chcemy uzyskać. Nazwa opcji jest widoczna w górnej części ekranu przy
uruchomieniu programu z opcją `-p`.

## 3. Opcje programu

### Punkt 

Dzięki tej opcji możemy na ekranie postawić punkt w uprzednio przez nas
wybranym kolorze. Wyboru koloru dokonuje się za pomocą opcji **kolor rysowania**.
Zmianę rozmiaru punktu dokonuje się za pomocą opcji **grubość linii**. Przy
wybranej opcji **powtarzanie rysowania** rysowane są punkty do momentu
zwolnienia lewego klawisza myszy, a przy dodatkowo włączonej opcji **losowy
kolor rysowania** kolejne punkty rysowane są w innej barwie (losowo wybranej
przez program).

### Linia 

Opcja ta umożliwia narysowanie lini prostej w wybranym przez użytkownika
kolorze. Linię rysujemy w następujący sposób: Naciskamy lewy klawisz myszy
w punkcie, który ma stanowić jeden koniec linii i przy naciśniętym klawiszu
ustalamy punkt będący drugim końcem linii, a następnie zwalniamy lewy klawisz
myszy. Wyboru koloru rysowanej linii można dokonać za pomocą opcji **kolor
rysowania**. Zmianę grubości linii dokonać można za pomocą opcji **grubość
linii**. Przy włączonej opcji **losowy kolor rysowania** są rysowane linie o
losowo wybranym przez program kolorze.

### Prostokąt, słupek 

Opcja ta umożliwia narysowanie prostokąta w wybranym kolorze i z wybranym
wypełnieniem. Prostokąt rysujemy w następujący sposób: Naciskamy lewy klawisz
myszy w punkcie, który ma stanowić lewy górny wierzchołek prostokąta i przy
naciśniętym klawiszu ustawiamy kursor w punkcie będącym prawym dolnym
wierzchołkiem prostokąta, a następnie zwalniamy klawisz myszy. Wyboru koloru
rysowanego prostokąta można dokonać za pomocą opcji **kolor rysowania**. Przy
włączonej opcji **losowy kolor rysowania** są rysowane boki prostokąta w
losowo wybranym przez program kolorze. Przy wybranej opcji **wypełnianie**
prostokąt wypełniany jest zadanym wzorem w zadanym kolorze.

### Okrąg, koło

Opcja ta umożliwia narysowanie koła w wybranym kolorze i z wybranym
wypełnieniem. Koło rysujemy w następujący sposób: Naciskamy klawisz myszy
w wybranym punkcie i przy wciśniętym klawiszu określamy rozmiar ( promień )
rysowanego koła. Wyboru koloru rysowanego koła można dokonać za pomocą opcji
**kolor rysowania**. Przy włączonej opcji **losowy kolor rysowania** rysowany
jest okrąg w losowo wybranym przez program kolorze. Przy wybranej opcji
**wypełnianie** okrąg wypełniany jest zadanym wzorem w zadanym kolorze. 

### Elipsa

Opcja ta umożliwia narysowanie elipsy w wybranym kolorze i z wybranym
wypełnieniem. Elipse rysujemy w następujący sposób: Naciskamy klawisz myszy
w wybranym punkcie i przy wciśniętym klawiszu określamy rozmiar rysowanej
elipsy. Wyboru koloru rysowanej elipsy można dokonać za pomocą opcji **kolor
rysowania**. Przy włączonej opcji **losowy kolor rysowania** są rysowana jest
elipsa o losowo wybranym przez program kolorze. Przy wybranej opcji
**wypełnianie** elipsa wypełniana jest zadanym wzorem w zadanym kolorze. 

### Wypełnianie obszarów 

Opcja ta umożliwia wypełnienia obszarów zamkniętych wybranym kolorem. Kłopotu
mogą nastręczać obszary, które są wypełnione barwami składanymi z punktów o
innych barwach. Wypełniania obszaru daną barwą dokonujemy następująco:
Ustawiamy kursor myszy w wybranym przez nas punkcie i przyciskamy lewy
klawisz. Wtedy pokazywany jest obszar, który zostanie wypełniony. Po
zwolnieniu klawisza myszy obszar zostanie wypełniony. Wyboru koloru
wypełniania obszarów dokonujemy za pomocą opcji **kolor wypełniania**. Przy
włączonej opcji **losowy kolor wypełniania** wypełniany jest obszar losowo
wybranym przez program kolorze. Za pomocą tej opcji można również zmieniać
barwę narysowanych wcześniej linii. 

### Rysowanie ołówkiem

Narzędzie to służy do rysowania dowolnych linii i punktów. Ślad w wybranym
kolorze pozostawiany jest podczas ciągnięcia myszy z naciśniętym lewym
klawiszem. Aby zmienić grubość rysowanej ołówkiem linii należy załączyć opcję
**grubość linii**. Zmianę koloru dokonujemy za pomocą opcji **kolor rysowania**. 
Przy włączonej opcji **losowy kolor rysowania** jest rysowana krzywa
w różnych barwach. 

### Pisanie tekstów

Opcja ta umożliwia wprowadzanie tekstu w 2 różnych krojach pisma. Po wybraniu
tej opcji należy wprowadzić tekst, który będzie widoczny w górnej części
ekranu, a następnie zatwierdzić go lewym klawiszem myszy lub też klawiszem
<kbd>ENTER</kbd>. Rezygnacjujem z wprowadzenia danego tekstu na ekran odbywa się
za pomocą prawego przycisku mysz lub klawisza <kbd>ESC</kbd>. Polskie znaki należy
wprowadzać w kodach MAZOVII, np <kbd>Alt+A</kbd> → ą Po zatwierdzeniu tekstu
należy ustalić rozmiar czcionki za pomocą lewego przycisku myszy
(przytrzymując go). Przesuwanie tekstu odbywa się przy naciśniętym prawym
klawiszu myszy. Po zwolnieniu obu klawiszy tekst zostaje umieszczony
w wybranym miejscu. Zmiany czcionki dokonuje się za pomocą opcji **czcionka**.
Sterownik polskiej klawiatury w standardzie MAZOVII można otrzymać gratisowo
wraz z pełną wersją po dołączeniu do zamówienia własnych uwag i opinii
dotyczących programu.

### Powtarzanie rysowania

Opcja ta pozwala na 'powielanie' rysowanych obiektów. Przy użyciu tej opcji
możemy tworzyć bardzo ciekawe obrazy. Gdy opcja ta jest włączona - wciśnięty
prostokąt - przy rysowaniu dowolnego obiektu np. lini uzyskujemy jego
powielenie, które może mieć inne rozmiary w porównaniu do obiektu
macieżystego. Rozmiar regulowany jest za pomocą lewego przycisku myszy. Sposób
powielania jest charakterystyczny dla danego obiektu. Obiekty, które mogą być
powielane: punkt, linia, prostokąt, okrąg, elipsa, tekst.

### Grubość linii, wypełnianie, czcionka.

Opcja ta jest wielozadaniowa. Za jej pomocą możemy zmieniać grubość rysowanych
obrysów czy też linii, określić czy dane figury geometryczne mają być
wypełniane, czy też nie oraz możemy określać rodzaj czcionki. Opcja ta jest
aktywna, wtedy gdy ikona ją symbolizująca jest wciśnięta. Zmiany grubości
dokonujemy przy rysowaniu następujcych obiektów: punkt, linia, olówek. Przy
włączonej opcji rysowane linie są grubsze. Gdy chcemy aby obiekty takie, jak :
prostokąt, okrąg, elipsa były wypełnione zadanym wzorem ustalanym za pomocą
opcji **odczytanie wzorka wypełniania** i w wybranym kolorze musimy uczynić tą
opcję aktywną. Opcja ta pozwala także na zmianę kroju czcionki.Gdy opcja ta
jest aktywna uzyskujemy pogrubioną czcionkę.

### Losowy kolor rysowania

Opcja **losowy kolor rysowania** pozwala na dobieranie koloru, przez komputer,
rysowanych obiektów. Gdy opcja ta jest aktywna - wciśnięta ikona symolizująca
cienkie różnokolorowe linie - rysowane obiekty takie, jak: punkty, proste,
krzywe, tekst, obrys prostokąta, elipsy, koła będą miały kolor wybrany przez
komputer, niezależnie od ustawionego za pomocą opcji **kolor rysowania**.
Barwy są wybierane z zakresu barw palety ustawionego za pomocą opcji **zakres
koloru rysowania**. 

### Losowy kolor wypełniania

Opcja **losowy kolor wypełniania** pozwala na dobieranie koloru, przez
komputer, wypełnianych obiektów. Gdy opcja ta jest aktywna - wciśnięta ikona
symolizująca grube różnokolorowe linie - wypełniane obiekty takie, jak:
prostokąt, elipsa, koło będą miały kolor wybrany przez komputer,niezależnie
od ustawionego za pomocą opcji **kolor wypełniania**. Barwy są wybierane
z zakresu barw palety ustawionego za pomocą opcji **zakres koloru
wypełniania**.

### Następny kolor rysowania

Opcja **następny kolor rysowania** pozwala na dobieranie koloru rysowanych
obiektów przez komputer w taki sposób, że kolejny rysowany obiekt będzie miał
barwę kolejną z wybranego zakresu kolorów rysowania (opcja **zakres kolorów
rysowania**). Gdy opcja ta jest aktywna - wciśnięta ikona symolizująca opcję -
rysowane obiekty takie, jak: punkty, linie proste, krzywe, tekst, obrys
prostokąta, elipsy, koła będą miały kolor wybrany przez komputer, niezależnie
od ustawionego za pomocą opcji **kolor rysowania**. Opcja ta nie działa przy
włączonej opcji **losowy kolor rysowania**. 

### Poprzedni kolor rysowania

Opcja o działaniu przeciwnym do opcji (Następny kolor rysowania).

### Następny kolor wypełniania

Opcja o działaniu podobnym do opcji (Następny kolor rysowania) z tym, że
odnosi się do koloru wypełniania.

### Poprzedni kolor wypełniania

Opcja o działaniu przeciwnym do opcji (Następny kolor wypełniania).

### Do schowka 

Opcja ta pozwala na zachowanie danego obrazka w podręcznym schowku. Taki
obrazek można później wczytać ze schowka przy pomocy opcji **ze schowka**.

### Ze schowka

Opcja ta pozwala na odtworzenie obrazka zapamiętanego w podręcznym schowku za
pomocą opcji **do schowka**. Gdy nie ma żadnego obrazka w schowku aktualny
rysunek nie zostanie zmieniony. Natomiast gdy schowek zawierał już wcześniej
zapamientany rysunek, to aktualny rysunek zostanie zastąpiony tym zapisanym
w schowku. 

### Oglądanie obrazka 

Opcja ta pozwala na podgląd tworzonego przez nas rysunku. Po wybraniu tej
opcji wyświetlany jest rysunek do momentu naciśnięcia jednego z klawiszy myszy.

### Kolor rysowania 

Opcja ta pozwala na ustalanie koloru rysowanego obiektu. Po wybraniu tej opcji
ukazana będzie cała paleta barw z której to można wybrać barwę rysowanego
obiektu. Aktualnie wybrany kolor wyświetlany jest w postaci pasku poniżej
palety barw. Zatwierdzenie danego koloru odbywa się za pomocą lewego klawisza
myszy, natomiast rezygnacja za pomocą prawego klawisza myszy. Po zatwierdzeniu
danej barwy obiekty takie, jak: punkty, linie proste, krzywe, tekst, obrys
prostokąta, elipsy, koła będą miały kolor wybrany przez użytkownika. Aktualnie
rysowany obiekt może mieć inną barwę niż wybrana przez użytkownika, jedynie
w przypadku aktywnej opcji : **losowy kolor rysowania**, **następny kolor
rysowania**, **poprzedni kolor rysowania**. 

### Kolor wypełniania 

Opcja ta pozwala na ustalanie koloru wypełnianego przedmiotu (obiektu). Po
wybraniu tej opcji ukazana będzie cała paleta barw z której to można wybrać
barwę, którą ma być wypełniany obiekt. Aktualnie wybrany kolor wyświetlany
jest w postaci pasku poniżej palety barw. Zatwierdzenie danego koloru odbywa
się za pomocą lewego klawisza myszy, natomiast rezygnacja za pomocą prawego
klawisza myszy. Po zatwierdzeniu danej barwy obiekty takie, jak: prostokąt,
elipsa, koło będą miały kolor wypełnienia wybrany przez użytkownika
( w przypadku włączonej opcji **wypełnianie**). Aktualnie rysowany obiekt
może mieć inną barwę niż wybrana przez użytkownika jedynie w przypadku
aktywnej opcji : **losowy kolor wypełniania**, **następny kolor wypełniania**,
**poprzedni kolor wypełniania**. 

### Zakres kolorów rysowania

Opcja ta pozwala na wybranie zakresu barw z aktualnej palety barw. Z tego
zakresu barw będą wybierane barwy przy aktywnych opcjach **losowy kolor
rysowania**, **następny kolor rysowania**, **poprzedni kolor rysowania**. Po
wybraniu tej opcji ukazana będzie cała paleta barw. Należy wtedy wskazać
kursorem myszy barwę, która ma stanowić początek zakresu i wcisnąć lewy
klawisz myszy. Następnie przy wciśniętym lewym klawiszu należy wskazać barwę,
która ma stanowić koniec przedziału i zwolnić klawisz. Poniżej palety barw
cały czas wyświetlany jest aktualny zakres wybranych barw. Zatwierdzenie
danego zakresu odbywa się za pomocą lewego klawisza myszy, natomiast
rezygnacja za pomocą prawego klawisza myszy. 

### Zakres kolorów wypełniania

Opcja ta pozwala na wybranie zakresu barw z aktualnej palety barw. Z tego
zakresu barw będą wybierane barwy przy aktywnych opcjach **losowy kolor
wypełniania**, **następny kolor wypełniania**, **poprzedni kolor wypełniania**.
Po wybraniu tej opcji ukazana będzie cała paleta barw. Należy wtedy wskazać
kursorem myszy barwę, która ma stanowić początek zakresu i wcisnąć lewy
klawisz myszy. Następnie przy wciśniętym lewym klawiszu należy wskazać barwę,
która ma stanowić koniec przedziału i zwolnić klawisz. Poniżej palety barw
cały czas wyświetlany jest aktualny zakres wybranych barw. Zatwierdzenie
danego zakresu odbywa się za pomocą lewego klawisza myszy, natomiast
rezygnacja za pomocą prawego klawisza myszy. 

### Czyszczenie ekranu. 

Po wybraniu tej opcji następuje wyczyszczenie zawartości ekranu. Tak więc,
utworzony wcześniej rysunek zostanie zatracony, bez możliwości jego
odzyskania.

LaTeX Uwaga!!! Należy się ostrożnie posługiwać tą opcją, gdyż można w bardzo krótkim
czasie utracić efekt swojej długotrwałej pracy. 

### Zapisanie palety barw

Opcja ta pozwala na zapisanie palety kolorów. Każdy rysunek bowiem ma właściwą
sobie paletę barw. Po wybraniu tej opcji należy podać nazwę pliku, do którego
ma być zapisana paleta. Można zapisać paletę kolorów na innym dyku i w innym
katalogu niż bieżący. Należy najpierw nacisnąć lewy przyciskiem myszy na ikonę
z nazwą napędu. Jeśli napęd będzie gotowy do pracy to zostanie on uczyniony
aktualnym. Aby dokonać zmiany katalogu, należy ustawić kursor myszy na ikonie
z nazwą katalogu a następnie nacisnąć lewy klawisz myszy. Wtedy możemy
wprowadzić jego nazwę. Jeśli katalog o podanej przez nas nazwie nie istnieje,
to program przywróci pierwotne ustawienia. Taki sam efekt można uzyskać po
wybraniu ikony Standard. Decyzję naszą o wybranym pliku i katalogu
zatwierdzamy po wybraniu ikony OK. Rezygnację z wczytania danych uzyskamy po
wybraniu ikony Anuluj.

### Wczytanienie palety 

Opcja ta pozwala na wczytanie palety kolorów. Po wybraniu tej opcji należy
wybrać plik z zapisaną paletą barw. Wybierając ikonę z nazwą pliku palety
ukazuje się nam nazwa kolejnego pliku. Można wczytać paletę kolorów z innego
dyku i z innego katalogu niż bieżący. Należy najpierw nacisnąć lewy przycisk
myszy na ikonę z nazwą napędu. Jeśli napęd będzie gotowy do pracy to zostanie
on uczyniony aktualnym. Aby dokonać zmiany katalogu, należy ustawić kursor
myszy na ikonie z nazwą katalogu a następnie nacisnąć lewy klawisz myszy.
Wtedy możemy wprowadzić jego nazwę. Jeśli katalog o podanej przez nas nazwie
nie istnieje, to program przywróci pierwotne ustawienia. Taki sam efekt można
uzyskać po wybraniu ikony Standard. Decyzję naszą o wybranym pliku i katalogu
zatwierdzamy po wybraniu ikony OK. Rezygnujemy z wczytania palety za pomocą
ikony Anuluj.

### Zapisanie wzorka wypełniania

Opcja ta pozwala na zapisanie wzorka wypełniania. Po wybraniu tej opcji można
dokonać edycji wzorka Wzorek edytujemy w następujący sposób :
Istnieje pole 8x8 punktów. Gdy chcemy aby dany punkt był aktywny naciskamy
lewy klawisz myszy. Wtedy aktywny (kolor różowy) punkt staje się nieaktywny
(kolor szary) i na odwrót. W górny prawym rogu jest widoczna cały czas
ikonka z edytowanym wzorkiem. Po jej naciśnięciu przywrócony zostaje pierwotny
wzór. Po zatwierdzeniu jego kształtu za pomocą ikony OK można zapisać go na
dysku pod podaną nazwą Możliwy jest zapis na innym dyku i w innym katalogu,
niż bieżący. Należy najpierw nacisnąć lewy przyciskiem myszy na ikonę z nazwą
napędu. Jeśli napęd będzie gotowy do pracy to zostanie on uczyniony aktualnym.
Dokonując zmiany katalogu, należy ustawić kursor myszy na ikonie z nazwą
katalogu a następnie nacisnąć lewy klawisz myszy. Wtedy możemy wprowadzić jego
nazwę. Jeśli katalog o podanej przez nas nazwie nie istnieje, to program
przywróci pierwotne ustawienia. Taki sam efekt można uzyskać po wybraniu ikony
Standard. Decyzję naszą o wybranym pliku zatwierdzamy ikoną OK. 

### Wczytanienie wzorka wypełniania

Opcja ta pozwala na wczytanie wzoru wypełniania. Po wybraniu tej opcji należy
wybrać nazwę plik z zapisanym wzorkiem. Wybierając ikonę z nazwą pliku wzorku
ukazuje się nam nazwa kolejnego pliku. Można wczytać wzorek z innego dyku i
z innego katalogu niż bieżący. Należy w tym celu najpierw nacisnąć lewy
przyciskiem na ikonie z nazwą napędu. Jeśli napęd będzie gotowy do pracy to
zostanie on uczyniony aktualnym. Aby dokonać zmiany katalogu, należy ustawić
kursor myszy na ikonie z nazwą katalogu a następnie nacisnąć lewy klawisz
myszy. Wtedy możemy wprowadzić jego nazwę. Jeśli katalog o podanej przez nas
nazwie nie istnieje, to program przywróci pierwotne ustawienia. Taki sam efekt
można uzyskać po wybraniu ikony Standard. Decyzję naszą o wybranym pliku
i katalogu zatwierdzamy po wybraniu ikony OK.

### Zapisanie rysunku 

Opcja ta pozwala na zapisanie opracowanego rysunku. Po wybraniu tej opcji
należy podać nazwę pliku, pod którą ma być zapisany rysunek. Można zapisać
rysunek na innym dyku i w innym katalogu niż bieżący. Należy najpierw nacisnąć
lewy przyciskiem myszy na ikonie z nazwą napędu. Jeśli napęd będzie gotowy do
pracy to zostanie on uczyniony aktualnym. Aby dokonać zmiany katalogu, należy
ustawić kursor myszy na ikonie z nazwą katalogu a następnie nacisnąć lewy
klawisz myszy. Wtedy możemy wprowadzić jego nazwę. Jeśli katalog o podanej
przez nas nazwie nie istnieje, to program przywróci pierwotne ustawienia. Taki
sam efekt można uzyskać po wybraniu ikony Standard. Decyzję naszą o wybranym
pliku i katalogu zatwierdzamy po wybraniu ikony OK. 

### Odczytanienie rysunku

Opcja ta pozwala na wczytanie wcześniej utworzonego rysunku. Po wybraniu jej
należy ustalić nazwę pliku. Wybierając ikonę z nazwą pliku rysunku ukazuje się
nam nazwa kolejnego pliku. Można wczytać rysunek z innego dyku i z innego
katalogu niż bieżący. Należy najpierw nacisnąć lewy przyciskiem myszy na ikonę
z nazwą napędu. Jeśli napęd będzie gotowy do pracy to zostanie on uczyniony
aktualnym. Aby dokonać zmiany katalogu, należy ustawić kursor myszy na ikonie
z nazwą katalogu a następnie nacisnąć lewy klawisz myszy. Wtedy możemy
wprowadzić jego nazwę. Jeśli katalog o podanej przez nas nazwie nie istnieje,
to program przywróci pierwotne ustawienia. Taki sam efekt można uzyskać po
wybraniu ikony Standard. Decyzję naszą o wybranym pliku i katalogu
zatwierdzamy po wybraniu ikony OK. 

### Informacja

Opcja ta pozwala na wyświetlenie informacji o programie. Po jej wybraniu
wyświetlana jest informacja, ta którą można obejrzeć po uruchomieniu programu
bez podania parametru -i. 

### Koniec

Opcja ta pozwala na opuszczenie programu. Po jej wybraniu praca z programem
zostaje zakończona. Gdy nie zostaną zapisane modyfikacje rysunku przy pomocy
opcji **zapisanie rysunku** to zmiany w rysunku nie zostaną zapamiętane.

# IV. Informacja

> Autor			:	Mariusz Terebecki  
> Kod, Miejscowość	:	64-100 Leszno  
> Ulica			:	~~Różana 3/3~~ Jana Poplińskiego 1a/14  
> Telefon			:	~~0605-524-292~~ +48 601 900 632
