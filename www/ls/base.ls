new Tooltip!watchElements!

$window = $ window
width  = $window .width!
height = $window .height!

year = 2006
# new SquareAdmin {width, height}
parties =
    [ 'PB' ]
    ...
    # [ \ODS 'TOP 09' \VV \SZ 'KDU-ČSL' ]
(err, parties) <~ d3.csv "../data/strany_ids.csv"
$body = $ \body
$selects = $ "<div id='selects' />"
    ..appendTo $body
$select1 = $ "<select name='party1' multiple='multiple' />"
    ..appendTo $selects
$select2 = $ "<select name='party2' multiple='multiple' />"
    ..appendTo $selects
$selectR = $ "<select name='rok'/>"
    ..appendTo $selects
$ "<input type='submit' value='Zobrazit' id='submit' />"
    ..appendTo $selects
[2010,2006,2002].forEach ->
    $ "<option value='#{it}'>#{it}</option>" .appendTo $selectR
parties.forEach ->
    $ "<option value='#{it.zkratka}'>#{it.nazev}</option>" .appendTo $select1
    $ "<option value='#{it.zkratka}'>#{it.nazev}</option>" .appendTo $select2
[$select1, $select2, $selectR].forEach -> it.chosen!
$ document .on \click 'input#submit' ->
    parties = []
    parties.0 = $select1.val!
    parties.1 = $select2.val!
    if !parties.1 || !parties.1.length
        parties.pop!
    year = $selectR.val!
    $ \svg .remove!
    worldmap = new ElectionResultsMap year, parties, {width, height}
worldmap = new ElectionResultsMap year, parties, {width, height}
# $window.on \resize ->
#     width  = $window .width!
#     height = $window .height!
#     worldmap.resize {width, height}
