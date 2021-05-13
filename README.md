# Overview:

## Demo:

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/CDS__Me3HLQ/0.jpg)](https://www.youtube.com/watch?v=CDS__Me3HLQ)

- A beautiful chat application built using Flutter and Google Firebase.

## Features:

- Email authentication for account creation via [firebase_auth](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_auth).
- Cloud database for account access on any device with realtime database updates through [cloud_firestore](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/cloud_firestore).
- Notifications on receiving messages (both background and foreground) using [firebase_messaging](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_messaging) and [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications). Notifications triggered by [cloud_functions](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/cloud_functions).
- Remote storage of media (profile pictures) via [firebase_storage](https://github.com/FirebaseExtended/flutterfire/tree/master/packages/firebase_storage).
- A clean and minimal UI.

## Screenshots:

- Here are some screenshots that outline the various screens of the application, to see all of them please click [here](https://github.com/akashvshroff/Talk_Flutter_App/tree/master/screenshots) or simply watch the video above to see the app in action.

<img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/talk.jpg"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/signup.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/add_profile.png">

<img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/connections.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/conversations.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Talk_Flutter_App/blob/master/screenshots/chat.png">

# Purpose:

- Chat applications are a vital component of our social connections today. They form the very backbone upon which the basic human need to communicate rests on and given their importance and widespread use, I wanted to challenge myself and see whether I could come up with a basic, yet fully functioning chat app. Moreover, building a chat application awarded me another opportunity that I had been eagerly waiting for - a project through which I could learn how to use Google Firebase.
- The build was more challenging than I had expected since I had to understand how to use Google Firebase as well as how to structure data within the NoSQL Cloud Firestore (more on that later), as well as how to leverage the other features of Firebase such as authentication and Cloud Functions. The end result was incredibly gratifying and helped solidify my understanding of the BLOC approach to state management in Flutter as well as how to build efficient, scalable applications.
- A detailed description where I examine the different choices I made with regards to my build can be found below.

# Description:

- While it would be a futile effort to try and explain every single component of the build, I have identified a few that I would like to cover in greater detail, namely the [Storage Architecture](https://github.com/akashvshroff/Talk_Flutter_App#storage-architecture), [Notifications](https://github.com/akashvshroff/Talk_Flutter_App#notifications) and the [UI](https://github.com/akashvshroff/Talk_Flutter_App#notifications).

## Storage Architecture:

- Having come from a more orthodox SQL background built on the principles of normalised data (i.e each object appearing only once in the database) and relational tables, Cloud Firestore and its world of NoSQL data storage warranted a paradigm shift. The resources I used to help me understand how Cloud Firestore works are this excellent [course by the Firebase team](https://www.youtube.com/playlist?list=PLl-K7zZEsYLluG5MCVEzXAQ7ACZBCuZgZ) where there is an in-depth explanation of how collections and documents work, how to query data and securely store it as well as this [FreeCodeCamp tutorial](https://www.youtube.com/watch?v=fi2WkznwWbc&t=1s) for Cryptocurrency wallet which explains how to code CRUD operations with Firestore.

### Denormalised Data:

- Before I can delve into the specifics of the build, a general concept that I have to cover is the idea of **denormalised data** that Firestore is based on. Denormalised data is when certain key snippets of data are repeated and stored in multiple locations and is the exact opposite of the SQL relational approach where data is stored in one place.
- This sort of a system has some obvious advantages and flaws. The primary advantage is that fetching data is made much simpler as you only have to retrieve data from one location and don't have to make any subsequent calls like in a relational structure - however writing data is a lot more complex as data doesn't have a single location where it can be modified but rather must be modified at every location it is present.
- Quite clearly, this system is built on the premise of favouring reads over writes - since reads occur much more frequently than writes and since Firestore is a platform that charges users based on number of reads and writes, using denormalized data is prefered as with only one read you can access all the information you need as opposed to doing multiple reads. This approach of denormalized data is prevalent throughout my build as well - as you will be able to observe in the next section.

### Firestore Architecture:

- In a general overview, there are two top level collections in my Firestore database: Users and Conversations.
- Users:
  - Each user document consists of basic information such as the username and profile picture path (which corresponds to the url of the picture that is saved to Cloud Storage). It also contains a FCM Token (more on that in the notifications section).
  - Apart from that it contains an array of maps called active conversations which is used to store basic conversation information for all of the users open conversations including the username of whom they are speaking to, their profile picture, the last message, the time that the conversation was last updated as well as a bool indicating if there is any new message. This allows the client to display all the open conversations without having to fetch any additional documents.
  - Moreover, it also contains an array of maps called connections which stores all the _friends_ or connections of the user and follows a similar denormalised approach to displaying their information.
- Conversations:
  - Each document in this collections refers to a conversation between two users - it contains some basic user information such as user ids and usernames as well as the profile pictures for each of the two users (to display in the conversation page).
  - Moreover, the conversation id the alphabetical combination of the user ids of the two users who are involved in the conversation.
  - Each text in the conversation is stored as a map in an array of maps called messages and includes the message text, the sender id and the sent time (an ISO8601 string).
- Each facet of this architecture (and the app as a whole) has been broken down into smaller chunks and stored as part of the [models](https://github.com/akashvshroff/Talk_Flutter_App/tree/master/lib/src/models). This allows me to store data that has been fetched from Firestore in a much more easy to use manner while also leveraging the typed features of Dart. I would recommend perusing through the different models in order to gain a better understanding of the storage architecture.

### BLOC:

- The [BLOC](https://github.com/akashvshroff/Talk_Flutter_App/blob/master/lib/src/blocs/bloc.dart) class contains a number of streams and StreamTransformers that are responsible for fetching the data from Cloud Firestore and convert this data into objects of the different local models that have been mentioned above.
- The UI leverages these streams by accessing the BLOC through the [Provider](https://github.com/akashvshroff/Talk_Flutter_App/blob/master/lib/src/blocs/provider.dart) class and implementing StreamBuilders which allow for realtime update of data.

## Notifications:

- Notifications for the application are handled by three components working in tandem - Cloud Functions for Firebase, Firebase Cloud Messaging and Flutter Local Notifications. To get a better understanding of how to use Cloud Functions and FCM for sending push notifications, I would recommend [this video](https://www.youtube.com/watch?v=2TSm2YGBT1s&ab_channel=Fireship), bear in mind that some of the API features of FCM have since been updated but the [documentation](https://firebase.flutter.dev/docs/messaging/overview) is thorough.
- Each of these components play a distinct role in the notification process.

### Firebase Cloud Messaging:

- FCM serves as the pipeline for the transfer of messages and it is used to channel messages from the cloud function to the client where it handles a stream of messages for foreground messages (i.e when the app is open) and it is passed a handler for the background messages. You can use FCM to send notifications with a certain title, body as well as some payload to trigger a change. Moreover, you could simply use it to send snippets of data and I would recommend reading the documentation to fully understand how to use it.

### Local Notifications:

- Local Notifications are used to convert the notifications received by the FCM pipeline into 'heads-up' overlay messages - i.e a popup notification that informs the user. These can be appropriately styled and simply serve as the UI element of the notification.

### Cloud Functions:

- Cloud Functions are used to trigger and send notifications - when a change is made to a conversation document and a new message map is added to the messages array, the function will identify the last message and send the notification by calling upon FCM to the client.
- It can send the message that the client is logged on to through their FCM Token which is a unique identifier for each client. This data is fetched and stored when the user creates their profile.

## UI:

-
