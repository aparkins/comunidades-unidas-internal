const {
  app,
  databaseError,
  pool,
  invalidRequest,
  notFound
} = require("../../../server");

const mysql = require("mysql");

const {
  checkValid,
  validId,
  validEnum,
  nonEmptyString,
  validDate,
  validTime
} = require("../../utils/validation-utils");

const {
  modifiableInteractionTypes,
  createResponeInteractionObject
} = require("./interaction-log.utils");

app.post("/clients/:clientId/interactions", (req, res) => {
  const validationErrors = [
    ...checkValid(req.params, validId("clientId")),
    ...checkValid(req.params, validId("serviceId")),
    ...checkValid(
      req.body,
      validEnum("title"),
      validEnum("interactionType"),
      nonEmptyString("description"),
      validDate("dateOfInteraction"),
      validTime("duration"),
      validEnum("location")
    )
  ];

  if (validationErrors.length > 0) {
    return invalidRequest(res, validationErrors);
  }

  const user = req.session.passport.user;

  const sql = mysql.format(
    `
			INSERT INTO clientInteractions
			(clientId, serviceId, title, interactionType, description, dataOfInteraction, duration, location, createdBy)
			VALUES
			(?, ?, ?, ?, ?, ?, ?, ?, ?)
		`,
    [
      req.params.clientId,
      req.body.title,
      req.params.serviceId,
      req.body.interactionType,
      req.body.description,
      req.body.dataOfInteraction,
      req.body.duration,
      req.body.location,
      user.id
    ]
  );

  pool.query(sql, (err, result) => {
    if (err) {
      return databaseError(req, res, err);
    }

    res.send(
      createResponseIntereactionObject({
        id: result.id,
        title: req.body.title,
        serviceId: req.body.serviceId,
        interactionType: req.body.interactionType,
        description: req.body.description,
        dateOfInteraction: req.body.dateOfInteraction,
        duration: req.body.duration,
        location: req.body.location,
        isDeleted: false,
        createdById: user.id,
        createdByFirstName: user.firstName,
        createdByLastName: user.lastName,
        dateAdded: new Date()
      })
    );
  });
});
