const fs = require("fs");
const jsdom = require("jsdom");

const inputHtml = fs.readFileSync("input.html", "utf-8");

const dom = new jsdom.JSDOM(inputHtml, { includeNodeLocations: true });
const document = dom.window.document;

const tables = document.getElementsByTagName("table");
for (var i = 0; i < tables.length; i++) {
  processTable(tables[i]);
  changeColGroup(tables[i]);
}
const outputHtml = dom.serialize();
fs.writeFileSync("input.html", outputHtml, "utf-8");

  function changeColGroup(table) {
    const tr = table.getElementsByTagName("tr")[0];
    const ths = tr.getElementsByTagName("th");
    let styleArr = [];
    let styleTotalNumber = 0;
    const addStyleArr = (number) => {
      styleArr.push(number);
      styleTotalNumber += number;
    };
    const regex = /\((R\d+)\)/;
    for (let i = 0; i < ths.length; i++) {
      const text = ths[i].innerHTML;
      const match = text.match(regex);
      if (match) {
        const number = parseInt(match[1].substring(1));
        const newText = text.replace(regex, "");
        ths[i].innerHTML = newText;
        addStyleArr(number);
      } else {
        addStyleArr(1);
      }
    }
    const colWidthArr = styleArr.map(
      (number) => ((number / styleTotalNumber) * 100).toFixed(1) + "%"
    );
    const colgroup = table.getElementsByTagName("colgroup")[0];
    if (colgroup) {
      const cols = colgroup.getElementsByTagName("col");
      for (let j = 0; j < cols.length; j++) {
        const col = cols[j];
        const style = col.style;
        style.width = colWidthArr[j];
      }
    } else {
      const colGroup = document.createElement("colgroup");
      for (let width of colWidthArr) {
        const col = document.createElement("col");
        col.style.width = width;
        colGroup.appendChild(col);
        table.appendChild(colGroup);
      }
    }
  }

  function processTable(table) {
    const head = table.tHead;
    const body = table.tBodies[0];
    if (head) {
      const parent = head.parentNode;
      while (head.rows.length > 0) {
        parent.insertBefore(head.rows[0], head);
      }
      parent.removeChild(head);
    }

    if (body) {
      const parent = body.parentNode;
      while (body.rows.length > 0) {
        parent.insertBefore(body.rows[0], body);
      }
      parent.removeChild(body);
    }

    for (let j = 0; j < table.rows.length; j++) {
      const row = table.rows[j];
      for (let k = 0; k < row.cells.length; k++) {
        const cell = row.cells[k];
        const content = cell.textContent.trim();

        //往右合併
        if (content === ">") {
          cell.style.display = "none";
          const nextIndex = (function findNextIndex(k) {
            return row.cells[k + 1].textContent.trim() !== ">"
              ? k + 1
              : findPrevIndex(k + 1);
          })(k);
          row.cells[nextIndex].colSpan = row.cells[nextIndex].colSpan + 1;
        }
        //往左合併
        if (content === "<") {
          cell.style.display = "none";
          const prevIndex = (function findPrevIndex(k) {
            return row.cells[k - 1].textContent.trim() !== "<"
              ? k - 1
              : findPrevIndex(k - 1);
          })(k);
          row.cells[prevIndex].colSpan = row.cells[prevIndex].colSpan + 1;
        }
        // 往上合併

        if (content.startsWith("^")) {
          function findTrIndex(j) {
            const cell = table.rows[j - 1]?.cells[k];
            if (
              !cell.textContent.startsWith("^") &&
              cell.style.display !== "none"
            )
              return j - 1;
            return findTrIndex(j - 1);
          }
          const index = findTrIndex(j);
          const originRowSpan = table.rows[index]?.cells[k]?.rowSpan;
          if (originRowSpan)
            table.rows[index].cells[k].rowSpan = originRowSpan + 1;
          const isAddBr =
            table.rows[index].cells[k].innerHTML.length !== 0 &&
            cell.textContent.replace(/\^/g, "").trim().length !== 0;
          table.rows[index].cells[k].innerHTML += isAddBr
            ? "</br>" + cell.textContent.replace(/\^/g, "")
            : cell.textContent.replace(/\^/g, "");
          cell.style.display = "none";
        }
      }
    }
  }
