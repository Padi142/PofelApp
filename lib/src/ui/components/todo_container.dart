import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_bloc.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_event.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget TodoNotDoneContainer(BuildContext context, TodoModel todo,
    PofelModel pofel, TodoBloc _todoBloc) {
  return GestureDetector(
    onTap: () {
      alert(context, pofel, todo, _todoBloc).show();
    },
    child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
            height: 60,
            decoration: const BoxDecoration(
                color: Color(0xFF73BCFC),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      flex: 3,
                      child: AutoSizeText(
                        todo.todoTitle,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 4,
                      )),
                  Expanded(
                    flex: 2,
                    child: Row(children: [
                      Expanded(
                        flex: 4,
                        child: AutoSizeText(
                          todo.assignedToName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 3,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(todo.assignedToProfilePic,
                                height: 50, width: 50),
                          ),
                        ),
                      ),
                    ]),
                  )
                ]))),
  );
}

Widget TodoDoneContainer(BuildContext context, TodoModel todo, PofelModel pofel,
    TodoBloc _todoBloc) {
  return GestureDetector(
    onTap: () {
      alert(context, pofel, todo, _todoBloc).show();
    },
    child: Padding(
        padding: const EdgeInsets.all(2),
        child: Stack(children: [
          Container(
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        flex: 3,
                        child: AutoSizeText(
                          todo.todoTitle,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 4,
                        )),
                    Expanded(
                      flex: 2,
                      child: Row(children: [
                        Expanded(
                          flex: 4,
                          child: AutoSizeText(
                            todo.assignedToName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            maxLines: 3,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(todo.assignedToProfilePic,
                                  height: 50, width: 50),
                            ),
                          ),
                        ),
                      ]),
                    )
                  ])),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Divider(thickness: 4, color: Colors.black),
          )
        ])),
  );
}

Alert alert(BuildContext context, PofelModel pofel, TodoModel todo,
    TodoBloc _todoBloc) {
  return Alert(
    context: context,
    type: AlertType.none,
    title: "Quest",
    content: Column(
      children: [
        Row(
          children: [
            const Text("Jméno: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            SizedBox(
              child: Text(todo.todoTitle,
                  maxLines: 3,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Row(
          children: [
            const Text("Quest pro: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            SizedBox(
              child: Text(todo.assignedToName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        Row(
          children: [
            const Text("Zadal: ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            SizedBox(
              child: Text(todo.assignedByName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        todo.isDone
            ? Row(
                children: const [
                  Text("Uděláno: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    child: Text("Ano",
                        style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              )
            : Row(
                children: const [
                  Text("Uděláno: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    child: Text("Ne",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
      ],
    ),
    buttons: [
      DialogButton(
        child: const Text(
          "Zavřít",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      ),
      DialogButton(
        color: Colors.greenAccent,
        child: const Text(
          "Udělat",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          String? uid = prefs.getString("uid");

          if (uid! == todo.assignedToUid || uid == pofel.adminUid) {
            _todoBloc
                .add(FinishTodo(pofelId: pofel.pofelId, todoId: todo.todoId));
          }
          Navigator.pop(context);
        },
        width: 120,
      ),
      DialogButton(
        color: Colors.redAccent,
        child: const Text(
          "Neudělat",
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          String? uid = prefs.getString("uid");

          if (uid! == todo.assignedToUid || uid == pofel.adminUid) {
            _todoBloc
                .add(UnfinishTodo(pofelId: pofel.pofelId, todoId: todo.todoId));
          }
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  );
}
