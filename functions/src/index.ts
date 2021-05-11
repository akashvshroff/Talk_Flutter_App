import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

admin.initializeApp();
const fcm = admin.messaging();

export const showNotificationOnNewMessage = functions.firestore
    .document("Conversations/{conversationId}")
    .onWrite((change, context) => {
      const conversationData = change.after.data();
      if (conversationData && conversationData.messages.length != 0) {
        console.log(conversationData.messages);
        const messages = conversationData.messages;
        const lastMessage = messages[messages.length-1];
        console.log(lastMessage);
        const senderId = lastMessage["sender_id"];
        if (senderId == conversationData.user_1) {
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: conversationData.username_1,
              body: lastMessage["text"],
              icon: conversationData.profile_pic_path_1,
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
          };
          return fcm.sendToDevice(conversationData.fcm_token_2, payload);
        } else {
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: conversationData.username_2,
              body: lastMessage["text"],
              icon: conversationData.profile_pic_path_2,
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
          };
          return fcm.sendToDevice(conversationData.fcm_token_1, payload);
        }
      }
      return true;
    });
