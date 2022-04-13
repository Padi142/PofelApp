import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_items_bloc/pofel_items_state.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_bloc.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_event.dart';
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/components/todo_container.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/bloc/todo_bloc/todo_bloc_state.dart';
import '../../components/item_container.dart';

Widget PofelTodosPage(BuildContext context, PofelModel pofel) {
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TodoBloc _todoBloc = TodoBloc();
  _todoBloc.add(LoadTodos(pofelId: pofel.pofelId));
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: BlocProvider(
      create: (context) => _todoBloc,
      child: BlocListener<TodoBloc, TodoBlocState>(
        listener: (context, state) {
          if (state is TodosWithData) {
            switch (state.todosEnum) {
              case TodosEnum.TODO_UPDATED:
                _todoBloc.add(LoadTodos(pofelId: pofel.pofelId));
                break;
              default:
                break;
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: BlocBuilder<TodoBloc, TodoBlocState>(
                builder: (context, state) {
                  if (state is TodosWithData) {
                    if (state.notDoneTodos.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Probíhající questy"),
                          Expanded(
                            child: ListView.builder(
                                itemCount: state.notDoneTodos.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return TodoNotDoneContainer(
                                      context,
                                      state.notDoneTodos[index],
                                      pofel,
                                      _todoBloc);
                                }),
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Zatím tu nejsou žádné questy :/"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: BlocBuilder<TodoBloc, TodoBlocState>(
                builder: (context, state) {
                  if (state is TodosWithData) {
                    if (state.doneTodos.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Hotové questy"),
                          Expanded(
                            child: ListView.builder(
                                itemCount: state.doneTodos.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return TodoDoneContainer(context,
                                      state.doneTodos[index], pofel, _todoBloc);
                                }),
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("Zatím tu nejsou žádné questy :/"),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(flex: 2, child: Container()),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: "Questy",
                        content: Column(
                          children: [
                            ReactiveForm(
                              formGroup: form,
                              child: Column(
                                children: <Widget>[
                                  ReactiveTextField(
                                    formControlName: 'name',
                                    decoration: const InputDecoration(
                                      labelText: 'Jméno questu',
                                    ),
                                    onSubmitted: () => form.focus('clovek'),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        backgroundColor: Colors.white),
                                  ),
                                  ReactiveDropdownField(
                                      formControlName: 'clovek',
                                      decoration: const InputDecoration(
                                        labelText: 'Vyber ',
                                      ),
                                      items:
                                          getDropdownItems(pofel.signedUsers)),
                                ],
                              ),
                            )
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Přidat",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              String? uid = prefs.getString("uid");
                              if (form.control("name").value != "" &&
                                  form.control("clovek").value != "") {
                                PofelUserModel assignedUser = pofel.signedUsers
                                    .firstWhere((user) =>
                                        user.uid ==
                                        form.control("clovek").value);
                                _todoBloc.add(AddTodoEvent(
                                    assignedByName: "",
                                    assignedByProfilePic: '',
                                    assignedByUid: uid!,
                                    assignedToName: assignedUser.name,
                                    assignedToProfilePic: assignedUser.photo,
                                    assignedToUid: assignedUser.uid,
                                    isDone: false,
                                    pofelId: pofel.pofelId,
                                    todoTitle: form.control("name").value));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBarAlert(context, 'Quest zadán!'));
                                Navigator.pop(context);
                              }
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                    child: const Text("Přidat quest"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

final form = fb.group({
  'name': ['', Validators.required],
  'clovek': ["", Validators.required],
});
List<DropdownMenuItem<String>> getDropdownItems(List<PofelUserModel> users) {
  List<DropdownMenuItem<String>> items = [];
  for (PofelUserModel user in users) {
    items.add(
      DropdownMenuItem(
        child: Text(user.name),
        value: user.uid,
      ),
    );
  }
  return items;
}
