---
title: "Jak wyciąć fragment filmu bez utraty jakości używając ffmpeg?"
date: 2018-03-04T11:23:52+01:00
tags: [Polish, Linux, Bash, Batch]
---

Zdarza mi się czasami oglądać jakiś film i zobaczyć scenę, która wywołuje u mnie
taki zachwyt, że aż chcę udostępnić dany fragment koledze lub na jakimś czacie.
Udostępnienie to nie jest problem, wystarczy chmura typu
[Dropbox](https://dropbox.com/). Problemem okazało się znalezienie narzędzia,
które pozwoliłoby na wycięcie fragmentu z jak najmniejszą stratą jakości.

<!--more-->

## Rozwiązania spartańskie

Najprostsze rozwiązania w tym przypadku wcale nie są najlepsze.

1. **Nagrać**. Idea jest taka: włączyć nagrywanie (np. w [VLC
   Media Player](https://www.videolan.org/vlc/index.html) lub przy pomocy
   programu do przechwycenia pulpitu), odtworzyć fragment i zapisać wynik.
   Oczywistą wadą jest to, że trzeba obejrzeć daną scenę w całości i
   pilnować, aby zatrzymać nagrywanie w dobrym momencie, co może być uciążliwe,
   szczególnie jeśli ten fragment jest dłuższy niż kilka sekund.
1. **Użycie jakiegoś standardowego konwertera lub edytora filmów**. Konwertery
   czasami pozwalają na wybór, do której klatki przetworzyć dany plik.
   Wada tego rozwiązania jest oczywista: mało który konwerter ma opcję
   kopiowania (w zasadzie takiego nie znalazłem wśród darmowych), więc tracimy
   tutaj na jakości z powodu kompresji do innego formatu zwykle już i tak
   skompresowanego stratnie pliku.

Na szczęście istnieją porządne, uniwersalne (i otwarte) programy takie jak
[`ffmpeg`](https://www.ffmpeg.org/). Niestety, nie jest on najprostszy w użyciu
(brak GUI jest już wystarczająco odstraszający dla większości ludzi), ale raz
przemyślana i sprawdzona komenda może być wsadzona do parametryzowanego skryptu
do ponownego użycia w przyszłości.

Sam nie jestem znawcą `ffmpeg` więc napotkałem na drodze do celu kilka
problemów, których się nie spodziewałem. Jeśli interesuje cię tylko gotowy
działania skrypt, to przejdź od razu do [ostatniej sekcji](#ostateczna-komenda).

## Wariant najprostszy, ale niewygodny

Pierwsza, najprostsza wersja komendy, która, zdaje się, powinna działać
bezproblemowo:

    ffmpeg -ss 0:10 -i "not_cut.mp4" -codec copy -t 0:05 "cut.mp4"

* `-ss [czas]` ustala znacznik czasowy, od którego chcemy wczytywać plik
  wejściowy. `ffmpeg` często nie może precyzyjnie wyciąć fragmentu przed tym
  znacznikiem z uwagi na budowę pliku wideo, więc w rzeczywistości wczytuje
  wejście od punktu nie później, niż podany znacznik.
* `-i [wejście]` ustala nazwę (ścieżkę do) pliku wejściowego.
* `-codec copy` chcemy oczywiście zachować oryginalną jakość, więc mówimy
  `ffmpeg`, aby pominął proces kodowania i dekodowania.
* `-t [czas]` ustala *długość* klipu wyjściowego.

**Uwaga.** Kolejność parametrów w poleceniu `ffmpeg` ma znaczenie! Parametry
przed `-i` dotyczą pliku wejściowego, a po `-i` dotyczą pliku wyjściowego.

<video width="320" height="180" style="display: block; margin-left: auto; margin-right: auto;" controls>
  <source src="/download/examples/cut1.mp4" type="video/mp4">
</video>

I na tym można by zakończyć ten wpis, ale zauważmy, że sama komenda nie jest
zbyt wygodna w użyciu, gdyż musimy obliczyć czas trwania fragmentu, który chcemy
wyciąć. Nie jest to trudne, ale zdecydowanie mniej wygodne niż podanie po prostu
czasu "od tej sekundy do tej sekundy".

Chociaż z powyższym klipem nie ma zbyt wielu problemów, to z doświadczenia wiem,
że powyższa komenda nie działa idealnie w każdym przypadku i może spowodować
pojawienie się dziwnych błędów graficznych na początku klipu, oraz przedłużyć
się o mniej więcej sekundę czarnego obrazu. Nie mam pojęcia, z czego takie błędy mogą
wynikać, ale z [ostateczną](#ostateczna-komenda) wersją już takie problemy się
nie pojawiały. Dlatego nie zalecam używania tej prostej wersji polecenia, chyba
że chcecie jej się uczyć na pamięć.

## Próba poprawienia wygody polecenia

Zdawałoby się, że `ffmpeg` powinien mieć opcję podania pozycji zamiast długości
trwania. Istotnie, możemy użyć parametru `-to`, który przyjmuje *pozycję* do
której będziemy przetwarzać plik wyjściowy.

    ffmpeg -ss 0:10 -i "not_cut.mp4" -codec copy -to 0:15 "cut.mp4"

<video width="320" height="180" style="display: block; margin-left: auto; margin-right: auto;" controls>
  <source src="/download/examples/cut2.mp4" type="video/mp4">
</video>

Otwieramy [`cut.mp4`](/download/examples/cut2.mp4) i... klip trwa piętnaście
sekund! Niektórzy zapewne już wiedzą gdzie jest błąd. Otóż powyższa komenda
wykonuje następujące czynności w tej kolejności:

1. Ignoruje wejście do punktu nie później niż znacznik 0:10.
2. Pomija proces kodowania i dekodowania (`-codec copy`).
3. Przetwarza wyjście do znacznika 0:15.

Problem jest taki, że przed punktem 3. `ffmpeg` resetuje znaczniki czasu, więc
komenda `-to` dostaje klip od 0:10 do końca oryginalnego pliku, ale ze
znacznikami czasu liczonymi od 0:00. Wobec tego nasza komenda
zadziałała tak jak przy użyciu parametru `-t`.

## Próba druga

Rozwiązanie to dodać parametr `-copyts` przed parametrem `-to`. Jak sama nazwa
wskazuje, spowoduje on "skopiowanie" znaczników czasu do wyjścia. Dzięki temu
pozycja podana `-to` rzeczywiście będzie odpowiadała odpowiedniej minucie w
oryginalnym pliku.

    ffmpeg -ss 0:10 -i "not_cut.mp4" -codec copy -copyts -to 0:15 "cut.mp4"

<video width="320" height="180" style="display: block; margin-left: auto; margin-right: auto;" controls>
  <source src="/download/examples/cut3.mp4" type="video/mp4">
</video>

Po otwarciu pliku [`cut.mp4`](/download/examples/cut3.mp4) zauważamy, że...
Chociaż klip jest wycięty tak, jak tego chcieliśmy, to znaczniki czasowe są
zachowane, i większość odtwarzaczy zapewne w tym momencie nieco wariuje, bo
wideo trwające 5 sekund zaczyna się od minuty 0:10 i kończy w 0:15...

## Próba ostatnia

Po skopiowaniu znaczników czasu i wycięciu odpowiedniego fragmentu chcielibyśmy
zresetować czas do zera. Na pomoc przychodzi nam parametr `-avoid_negative_ts`,
który przesuwa znaczniki czasu w zależności od parametru. W tym przypadku
interesuja nas opcja `make_zero`.

<video width="320" height="180" style="display: block; margin-left: auto; margin-right: auto;" controls>
  <source src="/download/examples/cut4.mp4" type="video/mp4">
</video>

    ffmpeg -ss 0:10 -i "not_cut.mp4" -codec copy -copyts -to 0:15 -avoid_negative_ts make_zero "cut.mp4"

Teraz [`cut.mp4`](/download/examples/cut4.mp4) jest dokładnie taki, jaki
chcieliśmy!

## Ostateczna komenda

    ffmpeg -hide_banner -ss $begin -i "$input" -codec copy -copyts -to $end -avoid_negative_ts make_zero "$output"

W miejsca zaczynające się od `$` oczywiście należy wstawić odpowiednie wartości.

`-hide_banner` zostało dodane, aby pozbyć się z wyjścia niepotrzebnych zwykle
informacji.

## Wygodne skrypty

Miało być wygodniej, a ostateczne polecenie jest długie i stosunkowo
skomplikowane. Cóż, można usprawnić jej używanie przez napisanie odpowiedniego
skryptu z odpowiednimi parametrami. Najlepiej jakby ten skrypt od razu wrzucał
wycięty klip do chmury.

Postanowiłem więc powtórzyć sobie Basha oraz Batcha* i napisać odpowiednie skrypty.

**Uwaga.** Poniższe skrypty zakładają, że `ffmpeg` jest zainstalowany poprawnie
oraz że polecenie `ffmpeg` działa w konsoli (tzn. binarka `ffmpeg[.exe]` jest
umieszczona w folderze ze ścieżką umieszczoną w zmiennej środowiskowej `PATH`).

<small>* W przypadku Batcha w zasadzie
się nauczyć... Wydawało mi się, że to Bash ma okropną składnię, ale Batch jest
dużo mniej przyjemnym językiem, szczególnie że Windows nie ma dużo przydatnych
narzędzi w linii poleceń.</small>

### Skrypt Bash (Linux)

<script src="https://gist.github.com/MrSimbax/44c2ed466c82893f2119fd4bfad37bb7.js"></script>

### Skrypt Batch (Windows)

<script src="https://gist.github.com/MrSimbax/68712fd63fe85e7842e55edfed66f3dc.js"></script>

### Użycie

Ogólny schemat polecenia:

    ffmpeg-cut {ścieżka_do_pliku_wejściowego} {czas_od} {czas_do} [{ścieżka_do_pliku_wyjściowego}]

* Czas podaje się w [formacie akceptowanym przez `ffmpeg`] (https://www.ffmpeg.org
/ffmpeg-all.html#Time-duration).
* Ścieżka do pliku wyjściowego jest opcjonalna i domyślnie prowadzi do folderu w
  [Dropboxie](https://dropbox.com/). Można łatwo zmodyfikować skrypt, aby
  zmienić tę domyślną ścieżkę.

Pamiętać o ustawieniu uprawnień do wykonywania! (`chmod +x ffmpeg-cut.sh`)

#### Przykład (Linux):

    ./ffmpeg-cut.sh "movie.mp4" 0:10 0:15 "fragment.mp4"

#### Przykład (Windows):

    ffmpeg-cut.bat "movie.mp4" 0:10 0:15 "fragment.mp4"

## Podsumowanie

Przy okazji rozwiązywania tego problemu dowiedziałem się nieco o tym, jak działa
`ffmpeg`, a taka wiedza z pewnością nie zaszkodzi. Lubię zresztą takie
minimalistyczne i uniwersalne podejście jak skrypty do tego typu czynności.
Jestem zdziwiony, że nie ma dużo takich minimalistycznych aplikacji, ale może po
prostu słabo szukałem. Mam nadzieję, że mój wpis pomoże również komuś innemu niż
mi. Dla wirtuozów linii poleceń i `ffmpeg` zapewne nie ma tu nic szczególnego.

<small>Klipy pochodzą z filmu krótkometrażowego Big Buck Bunny (c) copyright
2008, Blender Foundation / <a href="https://www.bigbuckbunny.org/">www.bigbuckbunny.org</a></small>
