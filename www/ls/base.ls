new Tooltip!watchElements!

$window = $ window
width  = $window .width!
height = $window .height!

year = 2010
# new SquareAdmin {width, height}
parties =
    [ 'TOP 09' ]
    ...
    # [ \ODS 'TOP 09' \VV \SZ 'KDU-ČSL' ]
worldmap = new ElectionResultsMap year, parties, {width, height}
# $window.on \resize ->
#     width  = $window .width!
#     height = $window .height!
#     worldmap.resize {width, height}
