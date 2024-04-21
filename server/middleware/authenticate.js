const jwt = require('jsonwebtoken');

// Middleware to authenticate user
const authenticate = (req, res, next) => {
  try {
    const token = req.header('Authorization').replace('Bearer ', '');
    const decoded = jwt.verify(token, 'pwKey');
    req.userId = decoded.id;
    req.userRole = decoded.role;
    next();
  } catch (e) {
    res.status(401).json({ msg: 'Please authenticate.' });
  }
};


module.exports = authenticate;
