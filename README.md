# Data IHNED.cz

[Datablog](http://ihned.cz/data/) portálu [IHNED.cz](http://ihned.cz/) vydavatelství [e.conomia](http://economia.ihned.cz/)
ve spolupráci s oddělením vývoje redakčních technologií [IHNED.cz](http://ihned.cz/)

## Vizualizace volebních výsledků

http://datasklad.ihned.cz/volebni-mapa/www/

Vizualizace volebních výsledků libovolné strany do SVG mapy ČR s přesností na obce. Dynamická barevná škála podle maximálního výsledku strany, lineární do cca 9. percentilu, s extrémy v poslední desetině (pro ukázku měřítka viz [článek](http://data.blog.ihned.cz/c1-61086960-jak-se-zmenila-politicka-mapa-republiky-vysledky-snemovnich-voleb-v-kazde-obci-od-roku-1996-do-vcerejska)). Umožňuje sčítat výsledky více stran a porovnávat výsledky N:M stran (užitečné pro rozdělení voličů pravice/levice nebo koalice/opozice).

Generuje SVG s každou obcí ČR a tooltipem jejího výsledku, což je cca 9MB dat. Chvíli tedy trvá, než se mapa vykreslí. Netestováno na obskurních prohlížečích jako IE.

SVG je anotováno hraničními souřadnicemi (tedy nejzápadnější/nejsevernější/nejvýchodněší/nejjižnější bod), takže se dá použít s [SVG Mapperem](https://github.com/economia/svg-mapper), ať už pro jednu hi-res print bitmapu nebo pro rozřezání do mapových dlaždic. Na export se hodí výtečný [SVG Crowbar](http://nytimes.github.io/svg-crowbar/).

Ve složce /srv je ještě pár skriptů na scrape XML z [OpenData ČSÚ](http://volby.cz/opendata/opendata.htm) a jejich přetavení do CSV a JSONů využívaných v této a dalších aplikacích. Ve složce /data už jsou takto zpracované volby od roku 1996 do 2013 (přičemž roky 1996, 1998 a 2002 byly získány scrapem přímo z HTML [volby.cz](http://www.volby.cz)). CSV má vždy následující strukturu:

*   ID obce
*   počet nevoličů (rozdíl mezi registrovanými voliči a vydanými obálkami)
*   počet voličů jednotlivých stran podle volebního čísla té které strany. V roce 2013 tedy postupně ČSSD, Svobodní, Piráti atd.

Stejné pořadí je v JSONu, kde je jako klíč objektu použito ID obce, obsahující pole výsledků. Zde jsou čísla stran indexem daného pole, nultý index jsou nevoliči. Čísla stran napříč volbami jsou v souboru /data/strany_ids.csv.

### Instalace

    npm install -g LiveScript
    npm install
    slake build

S dotazy a přípomínkami se obracejte na e-mail marcel.sulek@economia.cz.

Obsah je uvolněn pod licencí CC BY-NC-SA 3.0 CZ (http://creativecommons.org/licenses/by-nc-sa/3.0/cz/), tedy vždy uveďte autora, nevyužívejte dílo ani přidružená data komerčně a zachovejte licenci.
