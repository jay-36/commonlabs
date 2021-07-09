import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Model.dart';
import 'TodoDetail.dart';
import 'package:weapp_6_firebase/Case 1/Sqflite/Database Helper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('SQFlite'),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', ''), 'Add',false);
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                  image: AssetImage("assets/wave.gif"), fit: BoxFit.cover),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(getFirstLetter(this.todoList[position].title),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              title: Text(this.todoList[position].title,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(this.todoList[position].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        child: new AlertDialog(
                          title: const Text("Delete"),
                          content: Text("Are you sure...?"),
                          actions: [
                            RaisedButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            RaisedButton(
                                child: Text("Done"),
                                onPressed: () {
                                  _delete(context, todoList[position]);
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetail(this.todoList[position], 'Edit',true);
              },
            ),
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(Todo todo, String title, bool buttonDelete) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title, buttonDelete);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
