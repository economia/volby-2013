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
        @svg.selectAll \path
            .data kraje.features
            .enter!append \path
                ..attr \class \boundary
                ..attr \d @path
