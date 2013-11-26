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
veznice.forEach (veznica) -> veznica.line = years.map (year) -> (parseFloat veznica[year]) || -0.1
tooltipGenerator = (point, index) ->
    if point >= 0
        escape "Propuštěných v roce #{years[index]}: <strong>#{Math.floor point * 100}%</strong>"
    else
        escape "Propuštěných v roce #{years[index]}: věznice data neposkytla"
content = d3.select \tbody#content
d3.select \select .on \change ->
    classString = @value
    if Modernizr.svg
        classString += " svg"
    content.attr \class classString

content
    .classed \svg Modernizr.svg
    .selectAll \tr
    .data veznice
    .enter!append \tr
        ..attr \class -> it.kategorie?toLowerCase!split " " .0.split "" .join " "
        ..append \td
            ..attr \class \group
            ..html (.kategorie)
        ..append \td
            ..attr \class \name
            ..html -> it["věznice"]
        ..append \td
            ..attr \class \spark
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
            ..append \svg
                ..attr \width 300
                ..attr \height 30
                ..append \path
                    ..datum (.line)
                    ..attr \d line

