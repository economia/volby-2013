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
            ..attr \width @fullWidth
            ..attr \height @fullHeight
        (err, kraje) <~ d3.json '../data/kraje.geojson'
        @squares = @svg.append \g
            .attr \class \squares
        @map = @svg.append \g
            ..attr \class \map
        @map.selectAll \path
            .data kraje.features
            .enter!append \path
                ..attr \class \boundary
                ..attr \d @path
        @drawSquares 300

    drawSquares: (count) ->
        svgArea = @width * @height
        squareArea = svgArea / count
        squareSide = Math.sqrt squareArea
        squaresInRow = Math.floor @width / squareSide
        squaresInCol = Math.floor @height / squareSide
        squares = []
        for x in [0 to squaresInRow]
            for y in [0 to squaresInCol]
                squares.push [x, y]
        @squares.selectAll \rect
            .data squares
            .enter!append \rect
                ..attr \x -> it.0 * squareSide
                ..attr \y -> it.1 * squareSide
                ..attr \width squareSide - 2
                ..attr \height squareSide - 2


