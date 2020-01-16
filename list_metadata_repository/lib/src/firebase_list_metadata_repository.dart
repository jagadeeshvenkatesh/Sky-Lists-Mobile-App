import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:list_metadata_repository/list_metadata_repository.dart';
import 'entities/entities.dart';

class FirebaseListMetadataRepository implements ListMetadataRepository {
  FirebaseListMetadataRepository(String userId)
      : assert(userId != null),
        this._collection = Firestore.instance
            .collection('shopping lists')
            .document(userId)
            .collection('lists');

  final CollectionReference _collection;

  @override
  Future<void> addNewList(ListMetadata list) {
    return _collection.add(
      list.toEntity().toDocument(),
    );
  }

  @override
  Future<void> deleteList(ListMetadata list) async {
    return _collection.document(list.id).delete();
  }

  @override
  Stream<List<ListMetadata>> streamLists({
    Timestamp startAfterTimestamp,
    int limit = 10,
  }) {
    final baseQuery = _collection.limit(limit).orderBy(
          "lastModified",
          descending: true,
        );
    final startAfterQuery = baseQuery.startAfter([startAfterTimestamp]);
    final query = startAfterTimestamp == null ? baseQuery : startAfterQuery;

    return query.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map(
              (doc) => ListMetadata.fromEntity(
                ListMetadataEntity.fromSnapshot(doc),
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> updateList(ListMetadata update) {
    return Firestore().runTransaction(
      (Transaction transaction) => _collection.document(update.id).updateData(
            update.toEntity().toDocument(),
          ),
    );
  }

  @override
  Stream<ListMetadata> streamListTitle(ListMetadata list) {
    return list.docRef.snapshots().map((snapshot) =>
        ListMetadata.fromEntity(ListMetadataEntity.fromSnapshot(snapshot)));
  }
}
