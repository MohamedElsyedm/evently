import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/models/event_model.dart';
import 'package:evently/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static CollectionReference<EventModel> getEventCollection() =>
      FirebaseFirestore.instance
          .collection('events')
          .withConverter<EventModel>(
            fromFirestore: (docSnapshot, _) =>
                EventModel.fromJson(docSnapshot.data()!),
            toFirestore: (event, _) => event.toJson(),
          );

  static CollectionReference<UserModel> getUserCollection() => FirebaseFirestore
      .instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (docSnapshot, _) =>
            UserModel.fromJson(docSnapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  static Future<void> createEvent(EventModel event) {
    CollectionReference<EventModel> eventsCollection = getEventCollection();
    DocumentReference<EventModel> doc = eventsCollection.doc();
    event.id = doc.id;
    return doc.set(event);
  }

  static Future<List<EventModel>> getEvents() async {
    CollectionReference<EventModel> eventsCollection = getEventCollection();
    QuerySnapshot<EventModel> querySnapshot = await eventsCollection
        .orderBy('timestamp')
        .get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> editEvent(EventModel event) async {
    CollectionReference<EventModel> eventsCollection = getEventCollection();
    DocumentReference<EventModel> doc = eventsCollection.doc(event.id);
    print(event.id);
    return doc.update(event.toJson());
  }

  static Future<void> deleteEvent(EventModel event) async {
    CollectionReference<EventModel> eventsCollection = getEventCollection();
    DocumentReference<EventModel> doc = eventsCollection.doc(event.id);
    print(event.id);
    return doc.delete();
  }

  Future<UserModel?> signInWithGoogleAccount() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      //signin with google auth tokens
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      //signin with created google credential
      final UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(cred);

      UserModel userModel = UserModel.fromFirebaseUser(userCred.user);

      return userModel;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    UserModel user = UserModel(
      id: credential.user!.uid,
      name: name,
      email: email,
      favoriteEventIds: [],
    );

    CollectionReference<UserModel> userCollection = getUserCollection();
    userCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    CollectionReference<UserModel> userCollection = getUserCollection();

    DocumentSnapshot<UserModel> docSnapshot = await userCollection
        .doc(credential.user!.uid)
        .get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() {
    return FirebaseAuth.instance.signOut();
    // _googleSignIn.signOut();
  }

  static Future<void> addEventToFavorite(String eventId) async {
    CollectionReference<UserModel> userCollection = getUserCollection();
    DocumentReference<UserModel> userDoc = userCollection.doc(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return userDoc.update({
      'favoriteEventIds': FieldValue.arrayUnion([eventId]),
    });
  }

  static Future<void> removeEventFromFavorite(String eventId) async {
    CollectionReference<UserModel> userCollection = getUserCollection();
    DocumentReference<UserModel> userDoc = userCollection.doc(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return userDoc.update({
      'favoriteEventIds': FieldValue.arrayRemove([eventId]),
    });
  }
}
