new Tooltip!watchElements!
countriesById = d3.map!
fillColorsByType = d3.map!
settings = d3.map!
worldTopojson = null

d3.json "../data-private/world.json" (err, world) ->
    worldTopojson := world
    draw!

loadCounter = 0
somethingLoaded = ->
    if ++loadCounter >= 2 then draw!
draw = ->
    $window = $ window
    width  = $window .width!
    height = $window .height!
    display = settings.get \display
    worldmap = new Worldmap worldTopojson, display, countriesById, fillColorsByType, {width, height}
    $window.on \resize ->
        width  = $window .width!
        height = $window .height!
        worldmap.resize {width, height}


Dimensionable =
    margin:
        top: 10
        right: 0
        bottom: 22
        left: 39
    computeDimensions: (@fullWidth, @fullHeight) ->
        @width = @fullWidth - @margin.left - @margin.right
        @height = @fullHeight - @margin.top - @margin.bottom


class Worldmap implements Dimensionable
    (world, @visiblePart, @data, @fillColors, {width, height}) ->
        @computeDimensions width, height
        @projection = d3.geo.mercator!
            ..precision 0
        @project @visiblePart
        @path = d3.geo.path!
            ..projection @projection
        @svg = d3.select \body .append \svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight

        @svg.append \path
            .datum topojson.mesh world, world.objects.countries, (a, b) -> a isnt b
            .attr \class \boundary
            .attr \d @path

    project: (area) ->
        @projection
            ..scale @width * 8
            ..translate [@width / 2, @height / 2]
            ..center [15.3 49.8]
    resize: ({width, height})->
        @computeDimensions width, height
        @svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        @project @visiblePart
        @svg.selectAll \path
            .attr \d @path
