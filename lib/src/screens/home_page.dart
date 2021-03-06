import 'package:fmr/src/blocs/todos/todos_bloc.dart';
import 'package:fmr/src/blocs/todos/todos_event.dart';
import 'package:fmr/src/blocs/todos/todos_state.dart';
import 'package:fmr/src/models/todo.dart';
import 'package:fmr/src/screens/details.dart';
import 'package:fmr/src/widgets/appbar.dart';
import 'package:fmr/src/widgets/loading_indicator.dart';
import 'package:fmr/src/widgets/nav_fragment.dart';
import 'package:fmr/src/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'add_edit_todo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavFragmentContainer(builder: (context) {
      return Scaffold(
        appBar: mainAppBar(context),
        body: BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
          if (state is TodosLoadInProgress) {
            return LoadingIndicator();
          } else if (state is TodosLoadSuccess) {
            final todos = state.todos;
            return ReorderableListView.builder(
                itemCount: todos.length,
                onReorder: (fromIndex, toIndex) {
                  BlocProvider.of<TodosBloc>(context)
                      .add(TodosReorder(fromIndex, toIndex));
                },
                itemBuilder: (context, index) {
                  var todo = todos[index];
                  return ReorderableDragStartListener(
                    index: index,
                    key: Key("todo_ $index"),
                    child: TodoItem(
                      todo: todo,
                      onCheckboxChanged: (bool? value) {
                        BlocProvider.of<TodosBloc>(context).add(
                          TodoUpdated(todo.copyWith(complete: !todo.complete)),
                        );
                      },
                      onTap: () {
                        Navigator.push(context, DetailsPage.page(id: todo.id));
                      },
                    ),
                  );
                });
          } else {
            return Text("empty");
          }
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(AddEditTodoPage.page(
                onSave: (String task, String note) {
                  BlocProvider.of<TodosBloc>(context).add(
                    TodoAdded(Todo(task, note: note, id: Uuid().v4())),
                  );
                },
                editing: false));
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
