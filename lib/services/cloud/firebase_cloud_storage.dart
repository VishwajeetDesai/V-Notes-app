import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/services/cloud/cloud_note.dart';
import 'package:practice/services/cloud/cloud_storage_constants.dart';
import 'package:practice/services/cloud/cloud_storage_exceptions.dart';

class FireBaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNotesException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map(
                (doc) => CloudNote.fromSnapshot(doc),
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({
    required String ownerUserId,
  }) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchednote = await document.get();
    return CloudNote(
      documentId: fetchednote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();

  FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;
}
