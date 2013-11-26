new Tooltip!watchElements!
years = [2000 to 2012].map -> it.toString!
(err, veznice) <~ d3.tsv "../data/propusteni_pulky.tsv"
width = 300
height = 30
x = d3.scale.linear!
    ..domain [0 years.length]
    ..range [0 width]
yearWidth = (x 1) - (x 0)
y = d3.scale.linear!
    ..domain [0 1]
    ..range [height, 0]
line = d3.svg.line!
    ..x (point, index) -> (yearWidth / 2) + x index
    ..y y
veznice.forEach (veznica) -> veznica.line = years.map (year) -> (parseFloat veznica[year]) || 0
tooltipGenerator = (point, index) ->
    escape "Propuštěných v roce #{years[index]}: <strong>#{Math.floor point * 100}%</strong>"

d3.select \table#content
    .classed \svg Modernizr.svg
    .selectAll \tr
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
                    ..datum (.line)
                    ..attr \d line
            ..selectAll \div.year
                .data (.line)
                .enter!append \div
                    ..attr \class \year
                    ..style \width "#{yearWidth}px"
                    ..style \left (point, index) -> "#{x index}px"
                    ..attr \data-tooltip tooltipGenerator
                    ..style \height "#{height}px"
                    ..append \div
                        ..attr \data-tooltip tooltipGenerator
                        ..style \height -> "#{height - y it}px"

