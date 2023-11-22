``` typescript!=
/* eslint-disable no-extend-native */
import fs from 'fs'
import path from 'path'

export function serverLog(this: any, data?: any) {
  const filePath = path.join(__dirname, 'serverLog.json')
  const jsonString = JSON.stringify(data ? data : this, null, 2)

  fs.writeFile(filePath, jsonString, (err) => {
    if (err) {
      console.error('Error writing JSON to file:', err)
    } else {
      console.log('JSON written to file successfully.')
    }
  })
}
declare global {
  interface Object {
    serverLog: (data?: any) => void
  }
}
Object.defineProperty(Object.prototype, 'serverLog', {
  value: serverLog,
  writable: true,
  enumerable: false,
  configurable: true,
})

export function clientLog(this: any, data?: any): void {
  function replaceUndefined(obj?: any) {
    for (const key in obj) {
      if (
        Object.prototype.hasOwnProperty.call(obj, key) &&
        obj[key] === undefined
      ) {
        obj[key] = 'undefined'
      } else if (typeof obj[key] === 'object' && obj[key] !== null) {
        replaceUndefined(obj[key])
      }
    }
    return obj
  }

  const newWindow = window.open('', '_blank')
  const processedData = replaceUndefined(data ? data : this)
  const jsonData = JSON.stringify(processedData, null, 2)

  newWindow?.document.write(`
    <div style="display: flex; justify-content: center; gap: 10px;">
        <button onclick="copyToClipboard()">Copy</button>
        <button onclick="window.close()">Close Window</button>
    </div>
    <div style="display: flex; justify-content: center">
        <pre>${jsonData}</pre>
    </div>
    <script>
      function copyToClipboard() {
        const textArea = document.createElement('textarea');
        const jsonDataString =${JSON.stringify(jsonData)};
        const jsonDataStringWithoutUndefined = jsonDataString.replace(/"undefined"/g, undefined);
        textArea.value ="const copy = " + jsonDataStringWithoutUndefined;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        const result = window.confirm('複製成功!');
        if (result) {
          window.close()
        }
      }
      
    </script>
  `)
}

declare global {
  interface Object {
    clientLog: (data?: any) => void
  }
}
Object.defineProperty(Object.prototype, 'clientLog', {
  value: clientLog,
  writable: true,
  enumerable: false,
  configurable: true,
})

```