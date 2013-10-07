new Tooltip!watchElements!

$window = $ window
width  = 1920 #$window .width!
height = 1080 #$window .height!

year = 2010
document.title = "Protesty #year"
# new SquareAdmin {width, height}
sides =
    1998: [[ \ČSNS \NEZ \DEU \SZ \MoDS \OKPK \DŽJ \US ]]
    2002: [[ "ČSNS" "SZR" "BPS" "ČP" "SNK ED" "PB" "SZ" "NDS" "DL" "VPB" "HA" "AZSD" "N" "NH" "RMS" "CZ" "ROI" "SV SOS" "ČSDH" "REP" "ODA" "MoDS" "DŽJ"]]
    2006: [[ "SZR" "ČHNJ" "BPS" "LiRA" "PaS" "NEZ" "ČP" "KČ" "SNK ED" "US-DEU" "HOB" "PB" "4 VIZE 4" "ČSNS2005" "M" "SZ" "HS" "Koal_ČR" "NS" "FiS" "NEZ/DEM" "SRŠ" ]]
    2010: [[ "Občané" "LIB" "VV" "KONS" "ČSNS" "NP" "SPR-RSČ" "SPOZ" "STOP" "TOP 09" "ES" "Suveren" "ČPS" "DSSS" "Svobodní" "KH" "KČ" "PB" "ČSNS2005" "M" "HS" ]]
sides = sides[year]
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
[2010,2006,2002,1998,1996].forEach ->
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
    $ \svg .remove!
    worldmap = new ElectionResultsMap year, sides, {width, height}
worldmap = new ElectionResultsMap year, sides, {width, height}
# $window.on \resize ->
#     width  = $window .width!
#     height = $window .height!
#     worldmap.resize {width, height}
