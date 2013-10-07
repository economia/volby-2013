window.ElectionResultsMap = class ElectionResultsMap implements Dimensionable
    (@year, @sides, {width, height}) ->
        @computeDimensions width, height
        @projection = d3.geo.mercator!
            ..precision 0
        @svg = d3.select \body .append \svg
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
        bounds = @getBounds features
        @project bounds
        @annotateSvg bounds
        @path = d3.geo.path!
            ..projection @projection
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

    getBounds: (features) ->
        north = -Infinity
        west  = +Infinity
        south = +Infinity
        east  = -Infinity
        features.forEach (feature) ->
            [[w,s],[e,n]] = d3.geo.bounds feature
            if n > north => north := n
            if w < west  => west  := w
            if s < south => south := s
            if e > east  => east  := e

        console.log west
        [[west, south], [east, north]]

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
        [0 til scores.length by Math.round scores.length / 8].forEach -> console.log it, scores[it]
        domains =
            1998: [0 0.10 0.125 0.138 0.150 0.163 0.178 0.2 0.42]
            2002: [0 0.08 0.098 0.112 0.124 0.138 0.157 0.189 0.7]
            2006: [0 0.044 0.059 0.070 0.08 0.091 0.104 0.124 0.52]
            2010: [0 0.287 0.323 0.349 0.374 0.398 0.426 0.465 0.692]
        @color.domain domains[@year]

    sumParties: (zkratky, results) ->
        zkratky.reduce do
            (sum, zkratka) ~>
                index = @parties.get zkratka .[@year]
                sum += (results[index] || 0)
            0
    sumAll: (sum, currentCount) -> sum + (currentCount || 0)

    project: ([[west, south], [east, north]]:bounds) ->
        displayedPercent = (Math.abs west - east) / 360
        @projection
            ..scale @width / (Math.PI * 2 * displayedPercent)
            ..center [west, north]
            ..translate [0 0]

        @projection

    annotateSvg: ([[west, south], [east, north]]:bounds) ->
        [x0, y0] = @projection [west, north]
        [x1, y1] = @projection [east, south]
        width = (x1 - x0)
        height = (y1 - y0)
        @svg
            ..attr \width width
            ..attr \height height
            ..attr \data-bounds [north, west, south, east].join ','

    resize: ({width, height})->
        @computeDimensions width, height
        @svg
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        @project @visiblePart
        @svg.selectAll \path
            .attr \d @path
