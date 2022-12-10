import 'package:serverpod/server.dart';
import 'package:todos_server/src/generated/todo_class.dart';

class TodoEndpoint extends Endpoint {
  // get user todo
  Future<List<Todo>?> getTodos(Session session, int userId) async {
    return await Todo.find(
      session,
      where: (todo) => todo.userId.equals(userId),
      orderBy: TodoTable().isCompleted,
      orderDescending: false,
    );
  }

  // add todo
  Future<bool> addTodo(Session session, Todo todo) async {
    await Todo.insert(session, todo);
    return true;
  }

  // updateTask
  Future<bool> updateTodoStatus(Session session, Todo todo) async {
    await Todo.update(session, todo);
    return true;
  }
}
