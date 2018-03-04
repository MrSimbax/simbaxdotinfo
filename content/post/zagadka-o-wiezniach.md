---
title: "Zagadka o więźniach, co już nigdy tęczy mieli nie zobaczyć"
tags: [Math, Polish, Puzzle]
date: 2016-07-16T18:17:45+02:00
bigimg: [{src: "/img/kolorowe-okna.jpg", desc: ""}]
---

> Zostajesz zamknięty w jednym pomieszczeniu razem z sześcioma nieznajomymi. Do
> pokoju wchodzi uzbrojony strażnik i informuje was, że wkrótce zostaniecie
> przeniesieni do osobnych izolowanych cel i od tego momentu nie będziecie już
> mogli się ze sobą komunikować. Następnie każdemu z was zostanie przydzielony
> jeden z siedmiu kolorów tęczy (czerwony, pomarańczowy, żółty, zielony,
> niebieski, indygo, fioletowy). Potem każdy z was zostanie poinformowany, jakie
> kolory zostały przydzielone pozostałym sześciu osobom, w porządku losowym.
> 
> Jeśli ktokolwiek z was odgadnie swój kolor, to wszyscy zostaną wypuszczeni
> wolno. Jeśli jednak żaden z was nie odgadnie swojego koloru, to wszyscy
> zostaniecie wrzuceni do ciemnej celi i nikt z was już nigdy nie zobaczy żadnej
> tęczy. Każdy z was będzie miał tylko jedną szansę na odgadnięcie swojego
> koloru.
> 
> Po wyjściu strażnika w waszej grupie zaczyna się dyskusja.
> 
> Pierwsza osoba proponuje, aby spróbować obezwładnić strażnika, gdy wróci.
> 
> Druga osoba zwraca uwagę, że na zewnątrz może być więcej strażników i
> zamkniętych drzwi, poza tym ktoś na pewno zostanie ranny (lub gorzej).
> 
> Trzecia osoba proponuje, aby każdy po prostu podał inny kolor, ale po chwili
> się reflektuje i zamiast tego sugeruje, aby każdy podał ten sam kolor.
> 
> Czwarta osoba krytykuje plan trzeciej mówiąc, że nic w wypowiedzi strażnika
> nie sugeruje, że wszystkie siedem kolorów tęczy zostanie przyznanych, więc
> pewnie będą duplikaty, inaczej każdy mógłby z łatwością podać swój kolor przy
> pomocy wiedzy o pozostałych sześciu. Poza tym żadne z was nie będzie znało
> odpowiedzi pozostałych w momencie zgadywania swojego koloru.
> 
> Piąta osoba jest przekonana, że wśród was może być szpieg, który będzie
> działał niezgodnie z jakąkolwiek strategią, jaką wymyślicie, więc sytuacja
> jest beznadziejna.
> 
> Szósta osoba stwierdza, że nie możecie myśleć w ten sposób i musicie założyć,
> że każdemu z was można ufać.
> 
> Wszyscy zwracają się teraz w twoją stronę, gdyż jesteś ostatnią osobą, która
> się jeszcze nie włączyła do dyskusji.
> 
> Czy istnieje strategia (zgodna z zasadami podanymi przez strażnika), która
> gwarantuje wam przeżycie? Jeśli nie, to jaka jest najlepsza strategia, którą
> możecie zastosować?

## Wskazówki

**Wskazówka 1:** Istnieje idealna strategia.

**Wskazówka 2:** Rzeczona idealna strategia wymaga wszystkich siedmiu osób do
działania.

**Wskazówka 3:** Zagadkę można rozwiązać matematycznie, jeśli przypiszemy
każdemu kolorowi liczbę z zakresu 0-6 (czerwony = 0, pomarańczowy = 1, i tak
dalej).

## Rozwiązanie

Umawiacie się ze sobą w następujący sposób: każdemu kolorowi przyporządkowujecie
liczbę zgodnie z kolejnością na tęczy, od czerwonego ($0$) do fioletowego ($6$),
oraz każdy z was zapamiętuje swój jeden unikalny numerek z zakresu od $0$ do $6$
(na przykład pierwsza osoba w dyskusji dostaje numerek $1$, druga numerek $2$, i
tak dalej, a ty dostajesz numerek $0$).

Po otrzymaniu informacji o przydzielonych $6$ kolorach, sumujcie razem liczby je
reprezentujące (na przykład kombinacja czerwony, czerwony, żółty, niebieski,
fioletowy, indygo to $0 + 0 + 2 + 4 + 6 + 5 = 17$). Do otrzymanej sumy dodajcie
taką najmniejszą liczbę, aby reszta z dzielenia nowej sumy przez siedem dała
wasz unikalny numerek (ty musisz w tym przykładzie dodać $4$, aby otrzymać
liczbę $21$, bo przy dzieleniu przez $7$ daje ona resztę $0$, czyli twój
numerek). Liczba, którą musieliście dodać, reprezentuje kolor, który wskazujecie
strażnikowi.

Tym sposobem dokładnie jeden z was poda właściwy kolor i wszyscy będziecie
wolni.

## Dowód

Rozwiązanie działa nie tylko w przypadku $7$ kolorów i więźniów. Można je
uogólnić na sytuację przy dowolnej liczbie kolorów i $n$ więźniów, gdzie $n$
jest liczbą naturalną.

Niech $p\_0, p\_1, \ldots, p\_{n-1}$ (gdzie $i$ oznacza numer więźnia) będą
liczbami naturalnymi (kolorami) przydzielonymi poszczególnym więźniom. Wtedy $S
= p\_0 + p\_1 + \cdots + p\_{n-1}$.

Zdefiniujmy sumę częściową $s\_i = S - p\_i$. Jest to suma wszystkich kolorów
oprócz koloru więźnia o numerze $i$.

Ułóżmy $n$ równań:

$s\_0 + p\_0 \equiv 0 \pmod n$  
$s\_1 + p\_1 \equiv 1 \pmod n$  
$\ldots$  
$s\_{n-1} + p\_{n-1} \equiv n - 1 \pmod n$,

gdzie $p\_i$ w każdym równaniu jest szukaną niewiadomą.

Z definicji $s\_i + p\_i = S$, więc tym bardziej $s\_i + p\_i \equiv S \pmod n$.
$S \pmod n$ może dać jedną z $n$ możliwości ($0$ lub $1$ lub ... lub $n-1$).
Wobec tego dokładnie jedno z powyższych równań po rozwiązaniu względem $p\_i$ da
dobrą odpowiedź. $\blacksquare$

Inne wytłumaczenia rozwiązania (bardziej obrazowe) można znaleźć
[tutaj](https://www.quora.com/What-are-some-funny-nice-intelligent-and-mind-boggling-tricky-math-questions-to-ask/answer/Sean-Lucent).

<small>Cover photo credit: <a href="http://www.flickr.com/photos/36655009@N05/8696581956">University of Rochester, Interfaith Chapel 1</a> via <a href="http://photopin.com">photopin</a> <a href="https://creativecommons.org/licenses/by-sa/2.0/">(license)</a></small>
