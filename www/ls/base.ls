new Tooltip!watchElements!

$window = $ window
width  = 1920 #$window .width!
height = 1080 #$window .height!
years = [2013, 2010,2006,2002,1998,1996]
year = years.0
party = "Úsvit"
# new SquareAdmin {width, height}
sides = [[ party ]]
document.title = "koalice #year"
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
years.forEach ->
    $ "<option value='#{it}'>#{it}</option>" .appendTo $selectR
parties.forEach ->
    $ "<option value='#{it.zkratka}'>#{it.zkratka} #{it.nazev}</option>" .appendTo $select1
    $ "<option value='#{it.zkratka}'>#{it.zkratka} #{it.nazev}</option>" .appendTo $select2
[$select1, $select2, $selectR].forEach -> it.chosen!
$ document .on \click 'input#submit' ->
    sides = []
    sides.0 = $select1.val!
    sides.1 = $select2.val!
    if !sides.1 || !sides.1.length
        sides.pop!
    year = $selectR.val!
    document.title = "koalice #year"
    $ \svg .remove!
    worldmap = new ElectionResultsMap year, sides, {width, height}
worldmap = new ElectionResultsMap year, sides, {width, height}
# $window.on \resize ->
#     width  = $window .width!
#     height = $window .height!
#     worldmap.resize {width, height}
