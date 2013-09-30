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
        @color = d3.scale.linear!

        @decorateWithResults obce
        if @sides
            allParties = @sides.0.slice 0
            if @sides.1 then allParties ++= @sides.1
            allParties .= map ~> @parties.get it
        filename = if @year > 1998 then "obce_medium" else "obce_98"
        (err, obceTopo) <~ d3.json "../data/#filename.topojson"
        obceTopo.objects.obce.geometries ++= obceTopo.objects.mesta.geometries
        features = topojson.feature obceTopo, obceTopo.objects.obce .features
        tooltip = ~>
            vysledky = obce[it.properties.id]
            str = "<b>#{it.properties.name || it.properties.namemc}</b><br />"
            if not vysledky
                console?log it.properties.id
                return escape str
            total = vysledky.reduce do
                (acc, curr) -> acc + curr
                0
            allParties.forEach ~>
                pocet = vysledky[it[@year]]
                str += "Volební výsledek #{it.zkratka} v roce #{@year}: #{(pocet / total * 100).toFixed 2}%  (#{pocet} hlasů)<br />"
            str

        @svg.selectAll \path.country
            .data features
            .enter!
            .append \path
                ..attr \class \country
                ..attr \d @path
                ..attr \data-export ~>
                    JSON.stringify tooltip it
                ..attr \data-tooltip ~>
                    escape tooltip it
                ..attr \fill ~>
                    if obce[it.properties.id] then @color that.score else \#aaa

    decorateWithResults: (obce) ->
        max = -Infinity
        for id, results of obce
            obce[id].score = switch @sides.length
            | 1
                green = @sumParties @sides[0], results
                all = results.reduce @~sumAll, 0
                result = green / all
                if result > max
                    max = result
                result
            | 2
                red = @sumParties @sides[0], results
                blue = @sumParties @sides[1], results
                blue / (red + blue)
        if @sides.length == 2
            max = 1
            @color.range <[ #CA0020 #F4A582 #F7F7F7 #92C5DE #0571B0 ]>
        else
            @color.range <[ #FFF5F0 #FEE0D2 #FCBBA1 #FC9272 #FB6A4A #EF3B2C #CB181D #A50F15 #67000D ]>
        scores .= filter -> not isNaN it
        @color.domain ss.jenks scores, 8

    sumParties: (zkratky, results) ->
        zkratky.reduce do
            (sum, zkratka) ~>
                index = @parties.get zkratka .[@year]
                sum += results[index]
            0
    sumAll: (sum, currentCount) -> sum + (currentCount || 0)

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
