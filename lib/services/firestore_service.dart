import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addNote(String title, String description) async {
    await _db.collection("notes").add({
      "title": title,
      "description": description,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Note>> getNotes() {
    return _db
        .collection("notes")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Note.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> deleteNote(String id) async {
    await _db.collection("notes").doc(id).delete();
  }
}