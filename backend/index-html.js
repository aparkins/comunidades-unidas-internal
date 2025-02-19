const { app } = require("./server");
const btoa = require("btoa");

// Any routes not handled will serve up the HTML file
app.use(
  "*",
  (req, res, next) => {
    if (req.session.passport && req.session.passport.user.id) {
      return next();
    } else if (req.url.includes("/api")) {
      res.status(401).send({ error: "You must be logged in to call this API" });
    } else {
      return res.redirect("/login");
    }
  },
  (req, res) => {
    res.cookie(
      "user",
      btoa(
        JSON.stringify({
          fullName: req.session.passport.user.fullName,
          firstName: req.session.passport.user.firstName,
          lastName: req.session.passport.user.lastName,
          email: req.session.passport.user.email
        })
      ),
      {
        secure: process.env.RUNNING_LOCALLY ? false : true
      }
    );
    res.setHeader("cache-control", "no-store");
    res.render("index", {
      jsMainFile: process.env.RUNNING_LOCALLY
        ? "http://localhost:9018/comunidades-unidas-internal.js"
        : require("../static/manifest.json")["comunidades-unidas-internal.js"]
    });
  }
);
