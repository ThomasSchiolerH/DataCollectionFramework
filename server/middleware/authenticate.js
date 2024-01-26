const jwt = require('jsonwebtoken');

const authenticate = (req, res, next) => {
  try {
    const token = req.header('Authorization').replace('Bearer ', '');
    const decoded = jwt.verify(token, 'pwKey');
    req.userId = decoded.id;
    next();
  } catch (e) {
    res.status(401).json({ msg: 'Please authenticate.' });
  }
};

module.exports = authenticate;
