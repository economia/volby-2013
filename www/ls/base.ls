new Tooltip!watchElements!

$window = $ window
width  = $window .width!
height = $window .height!

year = 2002
# new SquareAdmin {width, height}
parties =
    [ \ČSSD \KSČM ]
    [ \ODS 'TOP 09' \VV \SZ 'KDU-ČSL' ]
worldmap = new ElectionResultsMap year, parties, {width, height}
# $window.on \resize ->
#     width  = $window .width!
#     height = $window .height!
#     worldmap.resize {width, height}
