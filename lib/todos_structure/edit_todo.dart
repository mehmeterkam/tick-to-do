import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tick_to_do/model/todo.dart';
import 'package:tick_to_do/provider/todos.dart';
import 'package:tick_to_do/todos_structure/todo_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tick_to_do/utils.dart';

class EditTodo extends StatefulWidget {
  final Todo todo;

  const EditTodo({Key key, @required this.todo}) : super(key: key);

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final _formKey = GlobalKey<FormState>();

  String title;
  String description;

  @override
  void initState() {
    super.initState();

    title = widget.todo.title;
    description = widget.todo.description;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Form(
              key: _formKey,
              child: Hero(
                tag: widget.todo.id,
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      maxWidth: MediaQuery.of(context).size.width / 1.2,
                      minWidth: MediaQuery.of(context).size.width / 1.2,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).editTodo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              deleteButton(context),
                            ],
                          ),
                        ),
                        TodoFormWidget(
                          title: title,
                          description: description,
                          onChangedTitle: (title) =>
                              setState(() => this.title = title),
                          onChangedDescription: (description) =>
                              setState(() => this.description = description),
                          onSavedTodo: saveTodo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  IconButton deleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        final provider = Provider.of<TodosProvider>(context, listen: false);
        provider.removeTodo(widget.todo);
        Utils.showSnackBar(
            context, AppLocalizations.of(context).snackbarDeleted.toString());
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.red,
      ),
      alignment: Alignment.topRight,
    );
  }

  void saveTodo() {
    final isValid = _formKey.currentState.validate();

    if (!isValid) {
      return;
    } else {
      final provider = Provider.of<TodosProvider>(context, listen: false);

      provider.updateTodo(widget.todo, title, description);
      Navigator.of(context).pop();
    }
  }
}
