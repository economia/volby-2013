new Tooltip!watchElements!

$window = $ window
width  = $window .width!
height = $window .height!

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
    ({width, height}) ->
        @computeDimensions width, height
        @projection = d3.geo.mercator!
            ..precision 0
        @project @visiblePart
        @path = d3.geo.path!
            ..projection @projection
        @svg = d3.select \body .append \svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        (err, okresy) <~ d3.json "../data/okresy.json"
        boundaries = topojson.feature okresy, okresy.objects.okresy_wgs84 .features
        @svg.selectAll \path.country
            .data boundaries
            .enter!
            .append \path
                ..attr \class \country
                ..attr \d @path
                ..attr \fill ~>
                    \#ccc
        @svg.append \path
            .datum topojson.mesh okresy, okresy.objects.okresy_wgs84, (a, b) -> a isnt b
            .attr \class \boundary
            .style \stroke-width \2px
            .attr \d @path
        (err, obce) <~ d3.json "../data/obce.json"
        @svg.append \path
            .datum topojson.mesh obce, obce.objects.obce, (a, b) -> a isnt b
            .attr \class \boundary
            .attr \d @path


    project: (area) ->
        @projection
            ..scale @width * 8
            ..translate [@width / 2, @height / 2]
            ..center [15.3 49.86]
    resize: ({width, height})->
        @computeDimensions width, height
        @svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        @project @visiblePart
        @svg.selectAll \path
            .attr \d @path

worldmap = new Worldmap {width, height}
$window.on \resize ->
    width  = $window .width!
    height = $window .height!
    worldmap.resize {width, height}
