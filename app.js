const express = require("express");
var paypal = require('paypal-rest-sdk');

const bodyParser = require("body-parser")
const ToDoRoute = require('./routes/todo.router');
const exerciseController = require('./controller/exerciseController');
const exerciseController1 = require('./controller/getintermediate.controller');
const exerciseController2 = require('./controller/getAdvanced.controller');
const exerciseController3 = require('./controller/getYoga.controller');
const getClasses = require('./controller/getClasses.controller');
const getallSub = require('./controller/getallSubscribtion.controller');

const admin = require('./firebaseAdmin');

const app = express();

app.use(bodyParser.json())

 app.use("/",ToDoRoute);
 app.use('/beginnerexercises', exerciseController);
 app.use('/intermediateexercises', exerciseController1);
 app.use('/Advancedexercises', exerciseController2);
 app.use('/yogaexercises', exerciseController3);
 app.use('/getClasses', getClasses);
 app.use('/getallSub', getallSub);


 app.use("/uploads", express.static("uploads"));

 const userRoute = require("./routes/user");
app.use("/user", userRoute);
const profileRoute = require("./routes/profile");
app.use("/profile", profileRoute);
const employeeRoute = require("./routes/employee");
app.use("/employee", employeeRoute);
const blogRoute = require("./routes/blogpost");
app.use("/blogPost", blogRoute);


app.post('/send-notification', (req, res) => {
    const { token, title, body } = req.body;
  
    const message = {
        notification: {
          title: 'Notification Title',
          body: 'Notification Body',
        },
        token: 'YOUR_DEVICE_TOKEN',
      };
      
      admin.messaging().send(message)
        .then((response) => {
          console.log('Notification sent:', response);
        })
        .catch((error) => {
          console.error('Error sending notification:', error);
        });
      
  });
 
module.exports = app;