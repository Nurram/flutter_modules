import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtils {
  static final firebabseAuth = FirebaseAuth.instance;
  static final firebaseFirestore = FirebaseFirestore.instance;
  static final firebaseStorage = FirebaseStorage.instance;

  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await firebabseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return authResponse;
    } catch (e) {
      if (e is FirebaseException) {
        if (e.message!.contains('INVALID_LOGIN_CREDENTIALS ')) {
          throw 'Invalid Email / Password';
        }
      }
      rethrow;
    }
  }

  static Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await firebabseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return authResponse;
    } catch (e) {
      if (e is FirebaseException) {
        if (e.message!.contains('INVALID_LOGIN_CREDENTIALS ')) {
          throw 'Invalid Email / Password';
        } else if (e.message!
            .contains('Password should be at least 6 characters')) {
          throw 'Password minimal 6 karakter';
        } else if (e.message!.contains(
            'The email address is already in use by another account.')) {
          throw 'Email telah digunakan';
        } else if (e.message!
            .contains('The email address is badly formatted.')) {
          throw 'Masukan Email yang Valid';
        }
      }
      rethrow;
    }
  }

  static Future resetPassword({required String email}) async {
    try {
      await firebabseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseException) {
        if (e.message!.contains('INVALID_LOGIN_CREDENTIALS ')) {
          throw 'Invalid Email / Password';
        } else if (e.message!
            .contains('Password should be at least 6 characters')) {
          throw 'Password minimal 6 karakter';
        } else if (e.message!.contains(
            'The email address is already in use by another account.')) {
          throw 'Email telah digunakan';
        } else if (e.message!
            .contains('The email address is badly formatted.')) {
          throw 'Masukan Email yang Valid';
        }
      }
      rethrow;
    }
  }

  static Future logout() async {
    await firebabseAuth.signOut();
  }

  static Future<List<Map<String, dynamic>>> getDataFromFirestore(
      {required String collection}) async {
    try {
      final response = await firebaseFirestore.collection(collection).get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getDataFromFirestoreById(
      {required String collection, required String id}) async {
    try {
      final response =
          await firebaseFirestore.collection(collection).doc(id).get();
      final data = response.data()!;
      data['id'] = response.id;

      return data;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>>
      getDataFromFirestoreSortedLessGreaterFiltered({
    required String collection,
    required String whereField,
    required num less,
    required num greater,
    required String orderField,
    bool isDesc = true,
  }) async {
    try {
      final response = await firebaseFirestore
          .collection(collection)
          .orderBy(orderField, descending: isDesc)
          .where(whereField, isGreaterThanOrEqualTo: less)
          .where(whereField, isLessThanOrEqualTo: greater)
          .get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>>
      getDataFromFirestoreSortedIdLessGreaterFiltered({
    required String collection,
    required String idField,
    required String id,
    required String whereField,
    required num less,
    required num greater,
    required String orderField,
    bool isDesc = true,
  }) async {
    try {
      final response = await firebaseFirestore
          .collection(collection)
          .orderBy(orderField, descending: isDesc)
          .where(idField, isEqualTo: id)
          .where(whereField, isGreaterThanOrEqualTo: less)
          .where(whereField, isLessThanOrEqualTo: greater)
          .get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>>
      getDataFromFirestoreWhereInFiltered({
    required String collection,
    required Object field,
    required List args,
  }) async {
    try {
      final response = await firebaseFirestore
          .collection(collection)
          .where(field, whereIn: args)
          .get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getDataFromFirestoreEqualFiltered({
    required String collection,
    required Object field,
    required dynamic args,
  }) async {
    try {
      final response = await firebaseFirestore
          .collection(collection)
          .where(field, isEqualTo: args)
          .get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>>
      getDataFromFirestoreOrderedEqualFiltered(
          {required String collection,
          required Object field,
          required dynamic args,
          required String orderBy,
          required bool desc}) async {
    try {
      final response = await firebaseFirestore
          .collection(collection)
          .where(field, isEqualTo: args)
          .orderBy(orderBy, descending: desc)
          .get();

      final responses = <Map<String, dynamic>>[];
      for (var element in response.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      return responses;
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<DocumentReference> storeDataToFirestore(
      {required String collection, required Map<String, dynamic> data}) async {
    try {
      return await firebaseFirestore.collection(collection).add(data);
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future storeDataToFirestoreById({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await firebaseFirestore.collection(collection).doc(id).set(data);
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future<TaskSnapshot> storeFileToStorage({
    required String ref,
    required File file,
  }) async {
    try {
      return await firebaseStorage.ref(ref).putFile(file);
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future updateDataToFirestoreById(
      {required String collection,
      required String id,
      required Map<String, dynamic> data}) async {
    try {
      return await firebaseFirestore
          .collection(collection)
          .doc(id)
          .update(data);
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future deleteFromFirestore(
      {required String collection, required String id}) async {
    try {
      await firebaseFirestore.collection(collection).doc(id).delete();
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static Future deleteFromFirebaseStorage({required String ref}) async {
    try {
      await firebaseStorage.ref(ref).delete();
    } catch (e) {
      if (e is FirebaseException) throw e.message!;

      rethrow;
    }
  }

  static listenDataFromFirestore({
    required String collection,
    required Function(List<Map<String, dynamic>>) onDone,
    required Function(String) onError,
  }) {
    firebaseFirestore.collection(collection).snapshots().listen((event) {
      final responses = <Map<String, dynamic>>[];
      for (var element in event.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      onDone(responses);
    }).onError((e) {
      if (e is FirebaseException) onError(e.message!);
      onError(e.toString());
    });
  }

  static listenDataFromFirestoreOrdered({
    required String collection,
    required String orderBy,
    bool desc = true,
    required Function(List<Map<String, dynamic>>) onDone,
    required Function(String) onError,
  }) {
    firebaseFirestore
        .collection(collection)
        .orderBy(orderBy, descending: desc)
        .snapshots()
        .listen((event) {
      final responses = <Map<String, dynamic>>[];
      for (var element in event.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      onDone(responses);
    }).onError((e) {
      if (e is FirebaseException) onError(e.message!);
      onError(e.toString());
    });
  }

  static listenDataFromFirestoreGreaterFiltered({
    required String collection,
    required String fieldName,
    required num arg,
    required Function(List<Map<String, dynamic>>) onDone,
    required Function(String) onError,
  }) {
    firebaseFirestore
        .collection(collection)
        .where(fieldName, isGreaterThan: arg)
        .snapshots()
        .listen((event) {
      final responses = <Map<String, dynamic>>[];
      for (var element in event.docs) {
        final data = element.data();
        data['id'] = element.id;

        responses.add(data);
      }

      onDone(responses);
    }).onError((e) {
      if (e is FirebaseException) onError(e.message!);
      onError(e.toString());
    });
  }
}
