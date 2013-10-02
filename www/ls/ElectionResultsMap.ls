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
                ..attr \data-export ~>
                    JSON.stringify tooltip it
                ..attr \data-tooltip ~>
                    {year, id, name, partyResults} = tooltip it
                    str = "<b>#{name}</b>, rok #{year}<br />"
                    if partyResults
                        partyResults.forEach ({abbr, percent, count}) ->
                            str += "#{abbr}: #{(percent * 100).toFixed 2}%  (#{count} hlasů)<br />"
                    else
                        str += "kdo ví"
                    escape str

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
            @color.range <[ #FFFFE5 #FFF7BC #FEE391 #FEC44F #FE9929 #EC7014 #CC4C02 #993404 #662506 ]>
        scores .= filter -> not isNaN it
        scores .= sort (a, b) -> b - a
        [0 til scores.length by Math.round scores.length / 10].forEach -> console.log it, scores[it]
        @color.domain do
            *   0
                0.04
                0.08
                0.12
                0.18
                0.22
                0.24
                0.4
                0.7

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
