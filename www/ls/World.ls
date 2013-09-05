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
        @color = d3.scale.linear!
            ..domain [0 0.25 0.5 0.75 1]
            ..range <[ #CA0020 #F4A582 #F7F7F7 #92C5DE #0571B0 ]>
        (err, okresy) <~ d3.json "../data/2010_obce.json"
        (err, obce) <~ d3.json "../data/obce.json"
        features = topojson.feature obce, obce.objects.obce .features
        @svg.selectAll \path.country
            .data features
            .enter!
            .append \path
                ..attr \class \country
                ..attr \d @path
                ..attr \data-tooltip ->
                    vysledky = okresy[it.properties.id]
                    return "#{it.properties.id}" if not vysledky
                ..attr \fill ~>
                    vysledky = okresy[it.properties.id]
                    return \#aaa if not vysledky
                    opo = vysledky[6] + vysledky[9]
                    koa = vysledky[4] + (vysledky[15] || 0) + (vysledky[26] || 0)
                    return \#aaa if 0 == opo + koa
                    @color koa / (opo+koa)

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
