
## 創建新專案
![[Pasted image 20240611141258.png]]


![[Pasted image 20240611141614.png]]

## 專案設定
### 創建index.js
```javascript!=
const sum = (a, b) => a + b;

module.exports = sum;
```

### 設定package.json

``` json
{
  "name": "@cheche14/package",
  "version": "1.0.0",
  "description": "To make it easy for you to get started with GitLab, here's a list of recommended next steps.",
  "main": "index.js",
  "files": [
    "index.js"
  ],
  "publishConfig": {
    "@cheche14:registry": "https://gitlab.com/api/v4/projects/58715584/packages/npm/"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "git+https://gitlab.com/cheche14/package.git"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "bugs": {
    "url": "https://gitlab.com/cheche14/package/issues"
  },
  "homepage": "https://gitlab.com/cheche14/package#readme"
}
```

### 建立YML檔案
.gitlab-ci.yml
```yml
image: node:latest

stages:
  - develop

develop:
  stage: develop
  script:
  - echo "//${CI_SERVER_HOST}/api/v4/projects/${CI_PROJECT_ID}/packages/npm/:_authToken=${CI_JOB_TOKEN}" > .npmrc
  - npm publish 

  environment: production
```

## gitlab 設定

### TOKEN

![[Pasted image 20240611142251.png]]


![[Pasted image 20240611142339.png]]
### CICD
![[Pasted image 20240611143031.png]]

## 發布

```bash
git commit -am "publish"
git push
```

![[Pasted image 20240611143433.png]]

![[Pasted image 20240611143457.png]]

## 安裝

### 增加設定黨

.npmrc
```
@cheche14:registry=https://gitlab.com/api/v4/packages/npm/
//gitlab.com/api/v4/packages/npm/:_authToken=gldt-ztJkCWXXr54sXX-BfaJk
```

```bash
npm install @cheche14/package
```

### 使用

```javascript
const sum = require("@cheche14/package");

console.log(sum(1, 2));
```