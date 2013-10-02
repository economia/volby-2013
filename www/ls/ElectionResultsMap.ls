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
        if @sides and @sides.length
            allParties = @sides.0.slice 0
            if @sides.1 then allParties ++= @sides.1
            allParties .= map ~> @parties.get it
        filename = if @year > 1998 then "obce_medium" else "obce_98"
        (err, obceTopo) <~ d3.json "../data/#filename.topojson"
        obceTopo.objects.obce.geometries ++= obceTopo.objects.mesta.geometries
        features = topojson.feature obceTopo, obceTopo.objects.obce .features
        tooltip = ~>
            id      = it.properties.id
            name    = it.properties.name || it.properties.namemc
            year    = @year
            partyResults = null
            vysledky = obce[it.properties.id]
            if vysledky
                total = vysledky.reduce do
                    (acc, curr) -> acc + curr
                    0
                partyResults = allParties.map ~>
                    pocet = vysledky[it[@year]]

                    abbr    = it.zkratka
                    percent = pocet / total
                    count   = pocet
                    {abbr, percent, count}

            {id, name, year, partyResults}

        @svg.selectAll \path.country
            .data features
            .enter!
            .append \path
                ..attr \class \country
                ..attr \d @path
                ..attr \data-tooltip ~>
                    it.properties.name || it.properties.namemc

                ..attr \fill ~>
                    obec = obce[it.properties.id]
                    if obec and not isNaN obec.score
                        @color obec.score
                    else
                        \#aaa

    decorateWithResults: (obce) ->
        max = -Infinity
        scores = for id, results of obce
            obce[id].score = switch @sides.length
            | 0
                winningIndex = null
                winningValue = -Infinity
                results.forEach (value, index) ->
                    if value > winningValue
                        winningValue := value
                        winningIndex := index
                winningIndex
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
        if @sides.length > 0
            @color = d3.scale.linear!
            @color.range switch @sides.length
                | 2 => <[ #CA0020 #F4A582 #F7F7F7 #92C5DE #0571B0 ]>
                | 1 => <[ #FFFFE5 #FFF7BC #FEE391 #FEC44F #FE9929 #EC7014 #CC4C02 #993404 #662506 ]>
            scores .= filter -> not isNaN it
            scores .= sort (a, b) -> b - a
            [0 til scores.length by Math.round scores.length / 10].forEach -> console.log it, scores[it]
            smallDomain = [0 0.025 0.05 0.075 0.1 0.125 0.15 0.175 0.7]
            bigDomain = [0 0.075 0.15 0.225 0.3 0.375 0.45 0.525 0.7]
            @color.domain if @year is 2010 then bigDomain else smallDomain
        else
            @color = d3.scale.ordinal!
            @color.domain [0 to 27]
            range = [0 to 27].map -> \#aaa
            range[9] = \#006ab3
            range[10] = \#f29400
            range[11] = \#015641
            range[18] = \#00AD00
            range[20] = \#e3001a
            range[24] = \#000000

            @color.range range

    sumParties: (zkratky, results) ->
        zkratky.reduce do
            (sum, zkratka) ~>
                index = @parties.get zkratka .[@year]
                sum += (results[index] || 0)
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
