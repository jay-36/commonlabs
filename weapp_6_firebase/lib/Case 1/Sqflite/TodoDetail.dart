import 'package:flutter/material.dart';
import 'Database Helper.dart';
import 'Model.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {

  final String appBarTitle;
  final Todo todo;
  final bool buttonDelete;

  TodoDetail(this.todo, this.appBarTitle,this.buttonDelete);

  @override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {

  //static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String appBarTitle;
  Todo todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TodoDetailState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {


    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(

        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: <Widget>[

                  // Second Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: titleController,
                      validator: (val){
                        if(val.isEmpty){
                          return "Please enter something.";
                        }else{
                          return null;
                        }
                      },
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (val){
                        if(val.isEmpty){
                          return "Please enter something.";
                        }else{
                          return null;
                        }
                      },
                      onChanged: (value) {
                        debugPrint('Something changed in Description Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          )
                      ),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();
                              setState(() {
                                debugPrint("Save button clicked");
                                _save();
                              });
                            }
                          },
                        ),
                        SizedBox(width: 5),
                        widget.buttonDelete ? RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ) : Container(width: 0),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }



  // Update the title of todo object
  void updateTitle(){
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {  // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else { // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Save', 'Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Error', 'Problem Saving');
    }

  }


  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW todo i.e. he has come to
    // the detail page by pressing the FAB of todoList page.
    if (todo.id == null) {
      _showAlertDialog('Status', 'No deleted');
      return;
    }

    // Case 2: User is trying to delete the old todo that already has a valid ID.
    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Delete', 'Deleted Successfully');
    } else {
      _showAlertDialog('Error', 'Error Occured while Deleting');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}