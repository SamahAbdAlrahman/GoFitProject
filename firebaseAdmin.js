const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert('./gofit-d2356-firebase-adminsdk-etym5-608804b394.json'),
});
