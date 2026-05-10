import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> addNote(String uid, String title, String content) async {
    try {
      final collectionRef = _db.collection('notes');
      final newDocRef = collectionRef.doc();
      final generatedID = newDocRef.id;
      final note = Note(
        id: generatedID,
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userID: uid,
      );

      await newDocRef.set(note.toFirestore());
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (_) {
      throw 'data-create-failed';
    }
  }

  Stream<List<Note>> watchNotes(String userID) {
    try {
      final collectionRef = _db.collection('notes');
      final query = collectionRef.where('userId', isEqualTo: userID);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Note.fromFirestore(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (_) {
      throw 'data-watch-failed';
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final collectionRef = _db.collection('notes');
      final docRef = collectionRef.doc(id);

      await docRef.delete();
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (_) {
      throw 'data-delete-failed';
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      final collectionRef = _db.collection('notes');
      final docRef = collectionRef.doc(note.id);

      await docRef.update(note.toFirestore());
    } on FirebaseException catch (e) {
      throw e.code;
    } catch (_) {
      throw 'data-update-failed';
    }
  }
}
