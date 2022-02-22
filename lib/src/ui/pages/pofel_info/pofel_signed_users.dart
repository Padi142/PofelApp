import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget PofelSignedUsers(BuildContext context, PofelModel pofel) {
  return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: [
        Row(
          children: [
            const Expanded(
                flex: 3, child: Text("Jméno", textAlign: TextAlign.center)),
            const Expanded(
                flex: 2,
                child: Text(
                  "Dovalí v",
                  textAlign: TextAlign.center,
                )),
            Expanded(flex: 1, child: Container())
          ],
        ),
        ListView.builder(
          itemCount: pofel.signedUsers.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
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
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(pofel.signedUsers[index].name,
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          DateTime pickedDate = DateTime.utc(1989, 11, 9);
                          Alert(
                            context: context,
                            type: AlertType.none,
                            desc: "Zadejt čas příjezdu",
                            content: Column(
                              children: [
                                DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    initialValue: '',
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'Datum a čas',
                                    onChanged: (val) {
                                      pickedDate = DateTime.parse(val);
                                    })
                              ],
                            ),
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  "Upravit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  BlocProvider.of<PofelBloc>(context).add(
                                      UpdateWillArrive(
                                          newDate: pickedDate,
                                          pofelId: pofel.pofelId));
                                  Navigator.pop(context);
                                },
                                width: 120,
                              )
                            ],
                          ).show();
                        },
                        child: Text(
                            pofel.signedUsers[index].willArrive.year ==
                                    DateTime.utc(1989, 11, 9).year
                                ? "idk"
                                : DateFormat('kk:mm').format(
                                    pofel.signedUsers[index].willArrive),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(pofel.signedUsers[index].photo,
                              height: 50, width: 50),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Pozvat lidi"),
              ),
            )
          ],
        ),
      ]));
}
