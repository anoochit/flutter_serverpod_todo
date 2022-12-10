import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todos_client/todos_client.dart';
import 'package:todos_flutter/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _taskTextController = TextEditingController();

  final _uid = sessionManager.signedInUser!.id;

  @override
  void initState() {
    super.initState();
    log('userId = $_uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${sessionManager.signedInUser!.userName}'),
        actions: [
          IconButton(
            onPressed: () {
              // signout
              sessionManager.signOut();
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: FutureBuilder(
        future: client.todo.getTodos(_uid!),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>?> snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final todos = snapshot.data;

          return ListView.builder(
            itemCount: todos!.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text(
                  todos[index].title,
                  style: (todos[index].isCompleted) ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                ),
                value: todos[index].isCompleted,
                onChanged: (value) async {
                  // update todo status
                  final _todo = todos[index];
                  _todo.isCompleted = value!;
                  await client.todo.updateTodoStatus(_todo);
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add task
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add"),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _taskTextController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your task here',
                    ),
                  ),
                ),
                actions: [
                  // cancel button
                  TextButton(
                    onPressed: () {
                      // back
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  // add button
                  TextButton(
                    onPressed: () async {
                      // add tasks
                      if (_formKey.currentState!.validate()) {
                        final todo = Todo(
                          id: null,
                          createdAt: DateTime.now(),
                          title: _taskTextController.text,
                          userId: _uid!,
                          isCompleted: false,
                        );
                        await client.todo.addTodo(todo);
                      }
                      _taskTextController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  )
                ],
              );
            },
          ).then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
