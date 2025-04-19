const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendAnnouncementNotification = functions.firestore
  .document('announcement/{id}')
  .onCreate((snap, context) => {
    const newAnnouncement = snap.data().announcement;

    const payload = {
      notification: {
        title: 'New Announcement',
        body: newAnnouncement,
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        screen: 'home',
      },
      topic: 'allUsers',
    };

    return admin.messaging().send(payload);
  });
