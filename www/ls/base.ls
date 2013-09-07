new Tooltip!watchElements!

$window = $ window
width  = $window .width!
height = $window .height!

year = 2010
worldmap = new ElectionResultsMap year, {width, height}
$window.on \resize ->
    width  = $window .width!
    height = $window .height!
    worldmap.resize {width, height}
