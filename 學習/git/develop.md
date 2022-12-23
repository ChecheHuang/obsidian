## develop分支
在gitflow中為長期分支
一開始有[[master]] 與 develop並存
此分支主要是所有開發的基礎分支，當要新增功能時，開啟的[[feature]]分支都是從此分支切出去的，當[[feature]]功能完成後會再合併回來
```
(develop)git branch feature
(develop)git checkout feature
// 當feature 功能完成
(feature)git checkout develop
(develop)git merge feature --no-ff
```
[[release]]也會合併回develop