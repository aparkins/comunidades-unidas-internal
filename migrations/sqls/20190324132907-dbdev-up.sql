/* Replace with your SQL commands */
CREATE TABLE IF NOT EXISTS users (
  userId int AUTO_INCREMENT PRIMARY KEY,
  googleId varchar(64) NOT NULL UNIQUE,
  firstName varchar(64) NOT NULL,
  lastName varchar(64) NOT NULL,
  accessLevel ENUM('Administrator','Manager','Staff') NOT NULL
);

/*Create person.person table */
CREATE TABLE IF NOT EXISTS person (
  personId int AUTO_INCREMENT PRIMARY KEY,
  firstName nvarchar(255) NOT NULL,
  lastName nvarchar(255) NOT NULL,
  dob date,
  gender varchar(64),  /*Gender constraint at front end */
  dateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
  dateModified DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  addedBy int NOT NULL /*Self Reference to User ID*/,
  modifiedBy int NOT NULL /*Self Reference to User ID*/,
  FOREIGN KEY (addedBy) REFERENCES users(userId),
  FOREIGN KEY (modifiedBy) REFERENCES users(userId)
);
/*Insert test data into person table*/

/*Create person Contanct table-Contact M:1 Person*/
CREATE TABLE IF NOT EXISTS contact (
  personId int NOT NULL, /*Foreign key reference to person table */
  contactId int AUTO_INCREMENT PRIMARY KEY,
  primaryPhone varchar(32),
  textMessages ENUM('Yes','No'), /*Would client like to recieve text messages from CU*/
  email varchar(128),
  address varchar(128),
  city varchar(64),
  zip varchar(32),
  state varchar(2),
  dwellingType ENUM('Renter','Homeowner','WithFamilyOrFriends'), /*Dwelling ownership type, rent or owned(Y/N)*/
  dateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
  addedBy int NOT NULL, /*Foreign key reference to person table */
  FOREIGN KEY (personId) REFERENCES person(personId),
  FOREIGN KEY (addedBy) REFERENCES users(userId)
);
/*Create Demographics Table M:1 Person*/
CREATE TABLE IF NOT EXISTS demographics (
  personId int NOT NULL, /*Foreign key reference to person table*/
  demographicId int AUTO_INCREMENT PRIMARY KEY,
  originCountry varchar(2),
  languageHome varchar(32), /* Primary language spoken at home */
  englishProficiency varchar(32), /*English Proficiency of Person*/
  dateUSArrival date, /*date of us arrival, day can be and estimation if client does not remember*/
  employed ENUM('Yes', 'No', 'NotApplicable', 'Unknown'), /*employed, not applicable for age < 16*/
  employmentSector varchar(128), /*Can be null if not employed*/
  payInterval varchar(64),
  weeklyAvgHoursWorked ENUM("0-20","21-35","36-40","41+"), /*Can be null if not employed*/  
  householdSize tinyint, 
  dependents tinyint, /*Replace people under 18 in house hold question*/
  maritalStatus varchar(128), /*Not applicable for children age < 17*/
  householdIncome int, /*Annual income estimate for household*/
  dateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
  addedBy int NOT NULL,
  FOREIGN KEY (personId) REFERENCES person(personId),
  FOREIGN KEY (addedBy) REFERENCES users(userId)
);

/*
Create Programs: We will create initial list of programs based on intake form pages 2 to 3
*/
CREATE TABLE IF NOT EXISTS programs (
  programId int AUTO_INCREMENT PRIMARY KEY,
  programName varchar(32) NOT NULL,
  description varchar(128),
  programManager int,
  createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  programStatus varchar(32),
  FOREIGN KEY (programManager) REFERENCES users(userId)
);
/*
Create Services Table: Services are in turn adminstered by a program. Pogram 1:M Services
*/
CREATE TABLE IF NOT EXISTS services (
  serviceId int AUTO_INCREMENT PRIMARY KEY,
  programId int NOT NULL,
  serviceName varchar(64),
  serviceDesc varchar(128),
  FOREIGN KEY (programId) REFERENCES programs(programId)
);

/*
Create IntakeData Table: Intake data is collected on client inital visits along with person, contact and demographic data*/
CREATE TABLE IF NOT EXISTS intakeData (
  intakeDataId int AUTO_INCREMENT PRIMARY KEY,
  personId int NOT NULL,
  dateOfIntake date NOT NULL, /*Not time stap because it maybe different*/
  clientSource varchar(64), /*how did person hear of CU*/
  registeredVoter varchar(5), /*Y N*/
  registerToVote varchar(5), /*Y N, does client want to register to vote..*/
  volunteering varchar(5), /*Y N*/
  caseNotes varchar(5000),
  intakeServicesId int NOT NULL, /*1:1:M intakeData:intakeServices:Services*/
  dateAdded DATETIME DEFAULT CURRENT_TIMESTAMP,
  addedBy int NOT NULL,
  FOREIGN KEY (addedby) REFERENCES users(userId),
  FOREIGN KEY (personId) REFERENCES person(personId)
);

/*Intake Services is a 1:M intakeData:IntakeServices*/
CREATE TABLE IF NOT EXISTS intakeServices (
  intakeServicesId int AUTO_INCREMENT PRIMARY KEY,
  intakeDataId int NOT NULL,
  serviceId int NOT NULL,
  FOREIGN KEY (intakeDataId) REFERENCES intakeData(intakeDataId),
  FOREIGN KEY (serviceId) REFERENCES services(serviceId)
)
