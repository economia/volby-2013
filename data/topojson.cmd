topojson -o okresy.json okresy_wgs84.shp -q 1e4 -s 1.5e-8 -p nuts=KODNUTS
topojson -o obce.topojson mesta=./mc/mestskeCasti_wgs84_UTM33.shp obce=./obce/obce.shp -q 1e4 -s 1e-9 -p id=ICZUJ -p name=NAZOB -p namemc=NAZMC --shapefile-encoding=cp1250
topojson -o obce_98.topojson mesta=./mc98/mestskeCasti_wgs84_UTM33.shp obce=./obce98/obce.shp -q 1e4 -s 1e-9 -p id=ICZUJ -p name=NAZOB -p namemc=NAZMC --shapefile-encoding=cp1250
