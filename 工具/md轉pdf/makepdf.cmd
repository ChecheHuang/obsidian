pandoc input.md -o input.html --pdf-engine=C:/Users/LT10s/AppData/Local/Programs/Python/Python311/Scripts/weasyprint.exe --lua-filter=./pandoc/weasyprint-filter.lua --css=./pandoc/mycss.css --standalone --toc --toc-depth=4 --template=./pandoc/myTemplate -F mermaid-filter.cmd 

node ./pandoc/changeHtml.js

weasyprint input.html output.pdf

rm input.html
rm mermaid-filter.err