require! fs
obce = {}
year = 1996
(err, content_nevolici) <~ fs.readFile "#__dirname/../data/#{year}_volici.raw.csv"
nevolici_by_obec = {}
content_nevolici .= toString!
lines = content_nevolici.split "\n"
lines.forEach (line) ->
    [obec,volici,vydane,odevzdane,platne] = line.split ","
    return if obec == \obec
    nevolici_by_obec[obec] = +volici - +vydane
(err, content) <~ fs.readFile "#__dirname/../data/#{year}_obce.raw.csv"
throw err if err
content .= toString!
lines = content.split "\n"
lines.forEach (line) ->
    [obec, strana, pocet] = line.split ","
    return if obec == \obec
    strana = parseInt strana, 10
    pocet = parseInt pocet, 10
    obce.[][obec][strana] = pocet
    obce[obec][0] = nevolici_by_obec[obec]

out = ""
for obecId, hlasy of obce
    out += "#obecId,#{hlasy.join ','}\n"
fs.writeFile "#__dirname/../data/#{year}_obce.csv", out
fs.writeFile "#__dirname/../data/#{year}_obce.json", JSON.stringify obce
