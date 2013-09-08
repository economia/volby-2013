window.SquareAdmin = class SquareAdmin implements Dimensionable
    ({width, height})->
        @computeDimensions width, height
        @projection = d3.geo.mercator!
            ..precision 0
            ..scale @height * 15
            ..translate [@width / 2, @height / 2]
            ..center [15.3 49.86]
        @path = d3.geo.path!
            ..projection @projection
        @svg = d3.select \body .append \svg
            ..attr \class \squares
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        (err, kraje) <~ d3.json '../data/kraje.geojson'
        @squares = @svg.append \g
            .attr \class \squares
        @map = @svg.append \g
            ..attr \class \map
        # @map.selectAll \path
        #     .data kraje.features
        #     .enter!append \path
        #         ..attr \class \boundary
        #         ..attr \d @path
        @drawSquares 330

    drawSquares: (count) ->
        svgArea = @width * @height
        squareArea = svgArea / count
        squareSide = Math.sqrt squareArea
        squaresInRow = Math.floor @width / squareSide
        squaresInCol = Math.floor @height / squareSide
        squares = []
        for x in [0 to squaresInRow]
            for y in [0 to squaresInCol]
                squares.push {x, y}
        squares = [{"x":0,"y":0,"off":true,"kraj":null},{"x":0,"y":1,"off":true,"kraj":null},{"x":0,"y":2,"off":true,"kraj":null},{"x":0,"y":3,"off":true,"kraj":null},{"x":0,"y":4,"off":true,"kraj":null},{"x":0,"y":5,"active":true,"kraj":13},{"x":0,"y":6,"off":true,"kraj":null},{"x":0,"y":7,"off":true,"kraj":null},{"x":0,"y":8,"off":true,"kraj":null},{"x":0,"y":9,"off":true,"kraj":null},{"x":0,"y":10,"off":true,"kraj":null},{"x":0,"y":11,"off":true,"kraj":null},{"x":0,"y":12,"off":true,"kraj":null},{"x":0,"y":13,"off":true,"kraj":null},{"x":1,"y":0,"off":true,"kraj":null},{"x":1,"y":1,"off":true,"kraj":null},{"x":1,"y":2,"off":true,"kraj":null},{"x":1,"y":3,"off":true,"kraj":null},{"x":1,"y":4,"kraj":13},{"x":1,"y":5,"kraj":13},{"x":1,"y":6,"kraj":13},{"x":1,"y":7,"kraj":14},{"x":1,"y":8,"kraj":14},{"x":1,"y":9,"off":true,"kraj":null},{"x":1,"y":10,"off":true,"kraj":null},{"x":1,"y":11,"off":true,"kraj":null},{"x":1,"y":12,"off":true,"kraj":null},{"x":1,"y":13,"off":true,"kraj":null},{"x":2,"y":0,"off":true,"kraj":null},{"x":2,"y":1,"off":true,"kraj":null},{"x":2,"y":2,"off":true,"kraj":null},{"x":2,"y":3,"off":true,"kraj":null},{"x":2,"y":4,"kraj":5},{"x":2,"y":5,"kraj":13},{"x":2,"y":6,"kraj":14},{"x":2,"y":7,"kraj":14},{"x":2,"y":8,"kraj":14},{"x":2,"y":9,"kraj":14},{"x":2,"y":10,"off":true,"kraj":null},{"x":2,"y":11,"off":true,"kraj":null},{"x":2,"y":12,"off":true,"kraj":null},{"x":2,"y":13,"off":true,"kraj":null},{"x":3,"y":0,"off":true,"kraj":null},{"x":3,"y":1,"off":true,"kraj":null},{"x":3,"y":2,"off":true,"kraj":null},{"x":3,"y":3,"kraj":5},{"x":3,"y":4,"kraj":5},{"x":3,"y":5,"kraj":2},{"x":3,"y":6,"kraj":2},{"x":3,"y":7,"kraj":2},{"x":3,"y":8,"kraj":14},{"x":3,"y":9,"kraj":14},{"x":3,"y":10,"kraj":14},{"x":3,"y":11,"off":true,"kraj":null},{"x":3,"y":12,"off":true,"kraj":null},{"x":3,"y":13,"off":true,"kraj":null},{"x":4,"y":0,"off":true,"kraj":null},{"x":4,"y":1,"off":true,"kraj":null},{"x":4,"y":2,"kraj":5},{"x":4,"y":3,"kraj":5},{"x":4,"y":4,"kraj":5},{"x":4,"y":5,"kraj":2},{"x":4,"y":6,"kraj":2},{"x":4,"y":7,"kraj":2},{"x":4,"y":8,"kraj":2},{"x":4,"y":9,"kraj":2},{"x":4,"y":10,"kraj":14},{"x":4,"y":11,"kraj":14},{"x":4,"y":12,"off":true,"kraj":null},{"x":4,"y":13,"off":true,"kraj":null},{"x":5,"y":0,"off":true,"kraj":null},{"x":5,"y":1,"off":true,"kraj":null},{"x":5,"y":2,"kraj":5},{"x":5,"y":3,"kraj":5},{"x":5,"y":4,"kraj":5},{"x":5,"y":5,"kraj":1},{"x":5,"y":6,"kraj":1},{"x":5,"y":7,"kraj":2},{"x":5,"y":8,"kraj":2},{"x":5,"y":9,"kraj":2},{"x":5,"y":10,"kraj":6},{"x":5,"y":11,"kraj":6},{"x":5,"y":12,"off":true,"kraj":null},{"x":5,"y":13,"off":true,"kraj":null},{"x":6,"y":0,"off":true,"kraj":null},{"x":6,"y":1,"kraj":5},{"x":6,"y":2,"kraj":5},{"x":6,"y":3,"kraj":5},{"x":6,"y":4,"kraj":1},{"x":6,"y":5,"kraj":1},{"x":6,"y":6,"kraj":1},{"x":6,"y":7,"kraj":1},{"x":6,"y":8,"kraj":2},{"x":6,"y":9,"kraj":2},{"x":6,"y":10,"kraj":6},{"x":6,"y":11,"kraj":6},{"x":6,"y":12,"kraj":6},{"x":6,"y":13,"off":true,"kraj":null},{"x":7,"y":0,"off":true,"kraj":null},{"x":7,"y":1,"kraj":5},{"x":7,"y":2,"kraj":5},{"x":7,"y":3,"kraj":1},{"x":7,"y":4,"kraj":1},{"x":7,"y":5,"kraj":1},{"x":7,"y":6,"kraj":1},{"x":7,"y":7,"kraj":1},{"x":7,"y":8,"kraj":1},{"x":7,"y":9,"kraj":2},{"x":7,"y":10,"kraj":2},{"x":7,"y":11,"kraj":6},{"x":7,"y":12,"kraj":6},{"x":7,"y":13,"kraj":6},{"x":8,"y":0,"kraj":12},{"x":8,"y":1,"kraj":12},{"x":8,"y":2,"kraj":12},{"x":8,"y":3,"kraj":1},{"x":8,"y":4,"kraj":1},{"x":8,"y":5,"kraj":1},{"x":8,"y":6,"kraj":1},{"x":8,"y":7,"kraj":1},{"x":8,"y":8,"kraj":1},{"x":8,"y":9,"kraj":2},{"x":8,"y":10,"kraj":2},{"x":8,"y":11,"kraj":6},{"x":8,"y":12,"kraj":6},{"x":8,"y":13,"kraj":6},{"x":9,"y":0,"off":true,"kraj":null},{"x":9,"y":1,"kraj":12},{"x":9,"y":2,"kraj":12},{"x":9,"y":3,"kraj":2},{"x":9,"y":4,"kraj":1},{"x":9,"y":5,"kraj":1},{"x":9,"y":6,"kraj":1},{"x":9,"y":7,"kraj":1},{"x":9,"y":8,"kraj":2},{"x":9,"y":9,"kraj":2},{"x":9,"y":10,"kraj":2},{"x":9,"y":11,"kraj":6},{"x":9,"y":12,"kraj":6},{"x":9,"y":13,"off":true,"kraj":null},{"x":10,"y":0,"kraj":12},{"x":10,"y":1,"kraj":12},{"x":10,"y":2,"kraj":12},{"x":10,"y":3,"kraj":2},{"x":10,"y":4,"kraj":2},{"x":10,"y":5,"kraj":1},{"x":10,"y":6,"kraj":1},{"x":10,"y":7,"kraj":1},{"x":10,"y":8,"kraj":9},{"x":10,"y":9,"kraj":9},{"x":10,"y":10,"kraj":9},{"x":10,"y":11,"kraj":9},{"x":10,"y":12,"off":true,"kraj":9},{"x":10,"y":13,"off":true,"kraj":null},{"x":11,"y":0,"off":true,"kraj":null},{"x":11,"y":1,"kraj":11},{"x":11,"y":2,"kraj":11},{"x":11,"y":3,"kraj":11},{"x":11,"y":4,"kraj":2},{"x":11,"y":5,"kraj":10},{"x":11,"y":6,"kraj":10},{"x":11,"y":7,"kraj":9},{"x":11,"y":8,"kraj":9},{"x":11,"y":9,"kraj":9},{"x":11,"y":10,"kraj":9},{"x":11,"y":11,"kraj":9},{"x":11,"y":12,"off":true,"kraj":null},{"x":11,"y":13,"off":true,"kraj":null},{"x":12,"y":0,"off":true,"kraj":null},{"x":12,"y":1,"off":true,"kraj":11},{"x":12,"y":2,"kraj":11},{"x":12,"y":3,"kraj":11},{"x":12,"y":4,"kraj":11},{"x":12,"y":5,"kraj":10},{"x":12,"y":6,"kraj":10},{"x":12,"y":7,"kraj":10},{"x":12,"y":8,"kraj":3},{"x":12,"y":9,"kraj":3},{"x":12,"y":10,"kraj":3},{"x":12,"y":11,"kraj":3},{"x":12,"y":12,"off":true,"kraj":null},{"x":12,"y":13,"off":true,"kraj":null},{"x":13,"y":0,"off":true,"kraj":null},{"x":13,"y":1,"off":true,"kraj":null},{"x":13,"y":2,"kraj":11},{"x":13,"y":3,"kraj":11},{"x":13,"y":4,"kraj":11},{"x":13,"y":5,"kraj":10},{"x":13,"y":6,"kraj":10},{"x":13,"y":7,"kraj":10},{"x":13,"y":8,"kraj":3},{"x":13,"y":9,"kraj":3},{"x":13,"y":10,"kraj":3},{"x":13,"y":11,"kraj":3},{"x":13,"y":12,"kraj":3},{"x":13,"y":13,"off":true,"kraj":null},{"x":14,"y":0,"off":true,"kraj":null},{"x":14,"y":1,"off":true,"kraj":null},{"x":14,"y":2,"off":true,"kraj":null},{"x":14,"y":3,"kraj":11},{"x":14,"y":4,"kraj":10},{"x":14,"y":5,"kraj":10},{"x":14,"y":6,"kraj":7},{"x":14,"y":7,"kraj":7},{"x":14,"y":8,"kraj":3},{"x":14,"y":9,"kraj":3},{"x":14,"y":10,"kraj":3},{"x":14,"y":11,"kraj":3},{"x":14,"y":12,"kraj":3},{"x":14,"y":13,"off":true,"kraj":null},{"x":15,"y":0,"off":true,"kraj":null},{"x":15,"y":1,"off":true,"kraj":null},{"x":15,"y":2,"off":true,"kraj":null},{"x":15,"y":3,"off":true,"kraj":null},{"x":15,"y":4,"off":true,"kraj":null},{"x":15,"y":5,"kraj":7},{"x":15,"y":6,"kraj":7},{"x":15,"y":7,"kraj":7},{"x":15,"y":8,"kraj":3},{"x":15,"y":9,"kraj":3},{"x":15,"y":10,"kraj":3},{"x":15,"y":11,"kraj":3},{"x":15,"y":12,"kraj":3},{"x":15,"y":13,"off":true,"kraj":null},{"x":16,"y":0,"off":true,"kraj":null},{"x":16,"y":1,"off":true,"kraj":null},{"x":16,"y":2,"off":true,"kraj":null},{"x":16,"y":3,"off":true,"kraj":null},{"x":16,"y":4,"off":true,"kraj":null},{"x":16,"y":5,"active":true,"kraj":7},{"x":16,"y":6,"kraj":7},{"x":16,"y":7,"kraj":7},{"x":16,"y":8,"kraj":7},{"x":16,"y":9,"kraj":8},{"x":16,"y":10,"kraj":3},{"x":16,"y":11,"kraj":3},{"x":16,"y":12,"kraj":3},{"x":16,"y":13,"kraj":3},{"x":17,"y":0,"off":true,"kraj":null},{"x":17,"y":1,"off":true,"kraj":null},{"x":17,"y":2,"off":true,"kraj":null},{"x":17,"y":3,"off":true,"kraj":null},{"x":17,"y":4,"kraj":4},{"x":17,"y":5,"active":true,"kraj":4},{"x":17,"y":6,"kraj":4},{"x":17,"y":7,"kraj":7},{"x":17,"y":8,"kraj":7},{"x":17,"y":9,"kraj":8},{"x":17,"y":10,"kraj":8},{"x":17,"y":11,"kraj":8},{"x":17,"y":12,"kraj":8},{"x":17,"y":13,"off":true,"kraj":null},{"x":18,"y":0,"off":true,"kraj":null},{"x":18,"y":1,"off":true,"kraj":null},{"x":18,"y":2,"off":true,"kraj":null},{"x":18,"y":3,"off":true,"kraj":null},{"x":18,"y":4,"kraj":4},{"x":18,"y":5,"kraj":4},{"x":18,"y":6,"kraj":4},{"x":18,"y":7,"kraj":4},{"x":18,"y":8,"kraj":7},{"x":18,"y":9,"kraj":8},{"x":18,"y":10,"kraj":8},{"x":18,"y":11,"kraj":8},{"x":18,"y":12,"off":true,"kraj":null},{"x":18,"y":13,"off":true,"kraj":null},{"x":19,"y":0,"off":true,"kraj":null},{"x":19,"y":1,"off":true,"kraj":null},{"x":19,"y":2,"off":true,"kraj":null},{"x":19,"y":3,"off":true,"kraj":null},{"x":19,"y":4,"off":true,"kraj":null},{"x":19,"y":5,"kraj":4},{"x":19,"y":6,"kraj":4},{"x":19,"y":7,"kraj":4},{"x":19,"y":8,"kraj":4},{"x":19,"y":9,"kraj":8},{"x":19,"y":10,"kraj":8},{"x":19,"y":11,"kraj":8},{"x":19,"y":12,"off":true,"kraj":null},{"x":19,"y":13,"off":true,"kraj":null},{"x":20,"y":0,"off":true,"kraj":null},{"x":20,"y":1,"off":true,"kraj":null},{"x":20,"y":2,"off":true,"kraj":null},{"x":20,"y":3,"off":true,"kraj":null},{"x":20,"y":4,"off":true,"kraj":null},{"x":20,"y":5,"off":true,"kraj":null},{"x":20,"y":6,"kraj":4},{"x":20,"y":7,"kraj":4},{"x":20,"y":8,"kraj":4},{"x":20,"y":9,"kraj":4},{"x":20,"y":10,"kraj":8},{"x":20,"y":11,"off":true,"kraj":null},{"x":20,"y":12,"off":true,"kraj":null},{"x":20,"y":13,"off":true,"kraj":null},{"x":21,"y":0,"off":true,"kraj":null},{"x":21,"y":1,"off":true,"kraj":null},{"x":21,"y":2,"off":true,"kraj":null},{"x":21,"y":3,"off":true,"kraj":null},{"x":21,"y":4,"off":true,"kraj":null},{"x":21,"y":5,"off":true,"kraj":null},{"x":21,"y":6,"kraj":4},{"x":21,"y":7,"kraj":4},{"x":21,"y":8,"kraj":4},{"x":21,"y":9,"kraj":4},{"x":21,"y":10,"off":true,"kraj":null},{"x":21,"y":11,"off":true,"kraj":null},{"x":21,"y":12,"off":true,"kraj":null},{"x":21,"y":13,"off":true,"kraj":null},{"x":22,"y":0,"off":true,"kraj":null},{"x":22,"y":1,"off":true,"kraj":null},{"x":22,"y":2,"off":true,"kraj":null},{"x":22,"y":3,"off":true,"kraj":null},{"x":22,"y":4,"off":true,"kraj":null},{"x":22,"y":5,"off":true,"kraj":null},{"x":22,"y":6,"off":true,"kraj":null},{"x":22,"y":7,"kraj":4},{"x":22,"y":8,"kraj":4},{"x":22,"y":9,"off":true,"kraj":null},{"x":22,"y":10,"off":true,"kraj":null},{"x":22,"y":11,"off":true,"kraj":null},{"x":22,"y":12,"off":true,"kraj":null},{"x":22,"y":13,"off":true,"kraj":null},{"x":23,"y":0,"off":true,"kraj":null},{"x":23,"y":1,"off":true,"kraj":null},{"x":23,"y":2,"off":true,"kraj":null},{"x":23,"y":3,"off":true,"kraj":null},{"x":23,"y":4,"off":true,"kraj":null},{"x":23,"y":5,"off":true,"kraj":null},{"x":23,"y":6,"off":true,"kraj":null},{"x":23,"y":7,"off":true,"kraj":null},{"x":23,"y":8,"kraj":4},{"x":23,"y":9,"off":true,"kraj":null},{"x":23,"y":10,"off":true,"kraj":null},{"x":23,"y":11,"off":true,"kraj":null},{"x":23,"y":12,"off":true,"kraj":null},{"x":23,"y":13,"off":true,"kraj":null}]
        count = squares
            .filter -> it.off != true
            .length
        window.currentKraj = 1
        window.alternateKraj = 2
        squareMargin = 10
        @squares.selectAll \rect
            .data squares
            .enter!append \rect
                ..attr \x -> it.x * squareSide + squareMargin
                ..attr \y -> it.y * squareSide + squareMargin
                ..attr \width squareSide - 2 * squareMargin
                ..attr \height squareSide - 2 * squareMargin
                ..attr \data-coords -> "#{it.x}-#{it.y}"
                ..attr \class -> if it.kraj then "kraj-#{it.kraj}" else ""
                ..classed \inactive -> it.off
                ..classed \active -> !it.off
                ..on \click ->
                    ele = d3.select @
                    switch
                    | d3.event.altKey
                        ele.attr \class ''
                        it.kraj = null
                    | d3.event.ctrlKey
                        it.kraj = alternateKraj
                        ele.attr \class "kraj-#alternateKraj"
                    | otherwise
                        it.kraj = currentKraj
                        ele.attr \class "kraj-#currentKraj"
                    counts = {}
                    total = 0
                    for i in [1 to 14]
                        counts[i] = squares
                            .filter -> it.kraj == i
                            .length
                        total += counts[i]
                    console.log counts[currentKraj], counts[alternateKraj], counts, total


        window.foo = ->
            console.log JSON.stringify squares

