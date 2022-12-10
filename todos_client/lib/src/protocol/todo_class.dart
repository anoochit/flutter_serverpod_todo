/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class Todo extends _i1.SerializableEntity {
  Todo({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    required this.userId,
  });

  factory Todo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Todo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      title:
          serializationManager.deserialize<String>(jsonSerialization['title']),
      isCompleted: serializationManager
          .deserialize<bool>(jsonSerialization['isCompleted']),
      createdAt: serializationManager
          .deserialize<DateTime>(jsonSerialization['createdAt']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
    );
  }

  int? id;

  String title;

  bool isCompleted;

  DateTime createdAt;

  int userId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'userId': userId,
    };
  }
}
