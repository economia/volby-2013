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
                vysledky_subset = if @sides.0.0 == 'Nevoliči'
                    vysledky
                else
                    vysledky.slice 1

                total = vysledky_subset.reduce do
                    (acc, curr) -> acc + curr
                    0
                mapSide = (side) ~>
                    side.map ~>
                        party = @parties.get it
                        pocet = vysledky[party[@year]]
                        abbr    = party.zkratka
                        percent = pocet / total
                        count   = pocet
                        {abbr, percent, count}
                partyResults = if @sides.length > 1
                    @sides.map mapSide
                else
                    mapSide @sides.0


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
                    str = "<b>#{name} #id</b>, rok #{year}<br />"
                    if partyResults
                        if @sides.length > 1
                            partyResults.forEach (side, index) ->
                                str += "Strana #index<br />"
                                side.forEach ({abbr, percent, count}) ->
                                    str += "#{abbr}: #{(percent * 100).toFixed 2}%  (#{count} hlasů)<br />"
                        else
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
            @color.range <[ #0571B0 #92C5DE #F7F7F7 #F4A582 #CA0020 ]>
            @color.domain [0, 0.25, 0.5, 0.75, 1]
        else
            @color.range <[#F7FCF5 #E5F5E0 #C7E9C0 #A1D99B #74C476 #41AB5D #238B45 #006D2C #00441B ]>
            scores .= filter -> not isNaN it
            scores .= sort (a, b) -> b - a
            extreme = scores[0]
            max = scores[Math.round scores.length / 10]
            console.log max, extreme
            # [max, extreme] = [0.028 0.152]
            @color.domain do
                *   max * 0
                    max * 0.14
                    max * 0.28
                    max * 0.42
                    max * 0.56
                    max * 0.7
                    max * 0.84
                    max * 1
                    extreme
            console.log @color.domain!
            domain = [0 til scores.length by Math.round scores.length / 10].map -> scores[it]
        # console.log domain

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
