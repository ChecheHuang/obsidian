API
```javascript =
const jwt = require("jsonwebtoken");
require("dotenv").config();

module.exports.login = async (req, res) => {
  try {
    const token = jwt.sign({ username, password }, config['JWT_SIGN_SECRET']);
    res.status(200).json({ token });
  } catch (error) {
    console.log(error);
    res.status(500).json({ msg: 'err' });
  }
};
```
tokenMIddleware.js
``` javascript =
var jwt = require('jsonwebtoken');
require('dotenv').config();

const tokenMiddleware = (req, res, next) => {
  let token;
  try {
    token = req.headers['authorization'].split(' ')[1];
  } catch (e) {
    token = '';
  }
  jwt.verify(token, process.env.TOKEN_SECRET, function (err) {
    if (err) {
      return res.status(401).json({ message: 'Unauthorized!' });
    } else {
	  req.user = decoded;
 	  next();
    }
  });
};
module.exports = tokenMiddleware;
```
使用middleware
``` javascript !=
const express = require('express');
const router = express.Router();
const tokenMiddleware = require('../middleware/tokenMiddleware');

router.get('/test', tokenMiddleware, (req, res) => {
  console.log(req.user);
  res.send('api/test');
});
module.exports = router;
```