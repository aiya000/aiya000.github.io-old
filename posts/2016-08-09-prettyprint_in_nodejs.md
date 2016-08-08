---
title: Node.jsでprettyprintする
tags: プログラミング, JavaScript, Node.js
---
# Node.jsでprettyprintする
　これ使う。  
[prettyprint](https://github.com/scottrabin/prettyprint)

現在、README.mdには
```javascript
var prettyprint = require('prettyprint').prettyprint;
prettyprint.prettyprint(obj);
```

しろと書いてあるけど、実際は

```javascript
const prettyprint = require('prettyprint').prettyprint;
prettyprint(obj);
```

で動作した。  
注意。
