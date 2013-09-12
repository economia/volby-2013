window.ElectionResultsMap = class ElectionResultsMap implements Dimensionable
    (@year, @sides, {width, height}) ->
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
        (err, obce) <~ d3.json "../data/#{@year}_obce.json"
        (err, parties) <~ d3.csv "../data/strany_ids.csv"
        @parties = d3.map!
        parties.forEach ~> @parties.set it.zkratka, it
        @decorateWithResults obce
        (err, obceTopo) <~ d3.json "../data/obce.topojson"
        features = topojson.feature obceTopo, obceTopo.objects.obce .features
        @svg.selectAll \path.country
            .data features
            .enter!
            .append \path
                ..attr \class \country
                ..attr \d @path
                ..attr \data-tooltip ->
                    vysledky = obce[it.properties.id]
                    return "#{it.properties.id}" if not vysledky
                ..attr \fill ->
                    if obce[it.properties.id] then  that.color else \#aaa

    decorateWithResults: (obce) ->
        color = d3.scale.linear!
            ..range <[ #CA0020 #F4A582 #F7F7F7 #92C5DE #0571B0 ]>
            ..domain [0 0.25 0.5 0.75 1]

        for id, results of obce
            obce[id].color = switch @sides.length
            | 1
                \#aaa
            | 2
                red = @sumParties @sides[0], results
                blue  = @sumParties @sides[1], results
                color blue / (red + blue)

    sumParties: (zkratky, results) ->
        zkratky.reduce do
            (sum, zkratka) ~>
                index = @parties.get zkratka .[@year]
                sum += results[index]
            0

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
