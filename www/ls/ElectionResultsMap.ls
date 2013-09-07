Dimensionable =
    margin:
        top: 10
        right: 0
        bottom: 22
        left: 39
    computeDimensions: (@fullWidth, @fullHeight) ->
        @width = @fullWidth - @margin.left - @margin.right
        @height = @fullHeight - @margin.top - @margin.bottom
window.ElectionResultsMap = class ElectionResultsMap implements Dimensionable
    (@year, {width, height}) ->
        @computeDimensions width, height
        @projection = d3.geo.mercator!
            ..precision 0
        @project @visiblePart
        @path = d3.geo.path!
            ..projection @projection
        @svg = d3.select \body .append \svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        @drawElectionResults!
    drawElectionResults: ->
        @color = d3.scale.linear!
            ..domain [0 0.25 0.5 0.75 1]
            ..range <[ #CA0020 #F4A582 #F7F7F7 #92C5DE #0571B0 ]>
        (err, okresy) <~ d3.json "../data/#{@year}_obce.json"
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
                    if @year == 2010
                        opo = vysledky[6] + vysledky[9]
                        koa = vysledky[4] + vysledky[15] + vysledky[26]
                    else
                        opo = vysledky[10] + vysledky[20]
                        koa = vysledky[9] + vysledky[18] + vysledky[24]
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
