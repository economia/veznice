years = [2000 to 2012].map -> it.toString!
(err, veznice) <~ d3.tsv "../data/propusteni_pulky.tsv"
width = 300
height = 30
x = d3.scale.linear!
    ..domain [0 years.length]
    ..range [0 width]
y = d3.scale.linear!
    ..domain [0 1]
    ..range [height, 0]
line = d3.svg.line!
    ..x (point, index) -> x index
    ..y y

d3.select \table#content .selectAll \tr
    .data veznice
    .enter!append \tr
        ..append \td
            ..attr \class \group
            ..html (.kategorie)
        ..append \td
            ..attr \class \name
            ..html -> it["věznice"]
        ..append \td
            ..attr \class \spark
            ..append \svg
                ..attr \width 300
                ..attr \height 30
                ..append \path
                    ..datum (veznica) -> years.map (year) -> (parseFloat veznica[year]) || 0
                    ..attr \d ->
                        ll = line it
                        console.log it
                        ll

console.log veznice
