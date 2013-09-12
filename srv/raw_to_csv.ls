require! fs
obce = {}
(err, content) <~ fs.readFile "#__dirname/../data/2002_obce.raw.csv"
throw err if err
content .= toString!
lines = content.split "\n"
lines.forEach (line) ->
    [obec, strana, pocet] = line.split ","
    return if obec == \obec
    strana = parseInt strana, 10
    pocet = parseInt pocet, 10
    obce.[][obec][strana] = pocet

out = ""
for obecId, hlasy of obce
    out += "#obecId,#{hlasy.join ','}\n"
fs.writeFile "#__dirname/../data/2002_obce.csv", out
fs.writeFile "#__dirname/../data/2002_obce.json", JSON.stringify obce
