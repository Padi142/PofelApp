import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_state.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/simple_date_time_picker.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoadpofelsBloc>().add(const LoadMyPofels());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PofelBloc, PofelState>(
      listener: (context, state) {
        if (state is PofelStateWithData) {
          switch (state.pofelStateEnum) {
            case PofelStateEnum.POFEL_CREATED:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Pofel úspěšně vytvořen'),
              );
              context.read<LoadpofelsBloc>().add(const LoadMyPofels());
              break;
            case PofelStateEnum.POFEL_JOINED:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarAlert(context, 'Úspěšně připojeno k pofelu'),
              );
              context.read<LoadpofelsBloc>().add(const LoadMyPofels());
              break;
            case PofelStateEnum.ERROR_JOINING:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarError(context, state.errorMessage!),
              );
              break;
            default:
              break;
          }
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PofelPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: PofelSectionTitle('Moje pofely'),
                  ),
                  const SizedBox(height: 14),
                  BlocBuilder<LoadpofelsBloc, LoadpofelsState>(
                    builder: (context, state) {
                      if (state is LoadPofelsWithData &&
                          state.loadPofelStateEnum ==
                              LoadPofelsStateEnum.POFELS_LOADED) {
                        if (state.myPofels.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'Zatím tu není žádný pofel.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: state.myPofels.map((pofel) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<NavigationBloc>().add(
                                        PofelDetailPageEvent(
                                          pofelId: pofel.pofelId,
                                        ),
                                      );
                                },
                                child: PofelSurfaceCard(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pofel.name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'za: ${daysBetween(DateTime.now(), pofel.dateFrom!)} dní',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: SizedBox(
                      width: 260,
                      child: PofelOutlineButton(
                        label: 'Veřejné pofely',
                        onPressed: () {
                          context.read<NavigationBloc>().add(
                                const LoadPublicPofelPage(),
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            PofelGradientButton(
              label: 'Připojit k pofelu',
              onPressed: _showJoinDialog,
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: PofelOutlineButton(
                label: 'Vytvořit pofel',
                onPressed: _showCreateDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog() {
    myController.clear();
    Alert(
      context: context,
      type: AlertType.none,
      title: "Připojit k pofelu",
      desc: "Zadejte pofel join ID",
      content: Column(
        children: [
          TextField(controller: myController),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            context.read<PofelBloc>().add(JoinPofel(joinId: myController.text));
            Navigator.pop(context);
          },
          width: 120,
          child: const Text(
            "Join",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  void _showCreateDialog() {
    myController.clear();
    DateTime pickedDate = DateTime.utc(1989, 11, 9);
    Alert(
      context: context,
      type: AlertType.none,
      title: "Zadejte jméno pofelu a datum",
      content: Column(
        children: [
          TextField(
            controller: myController,
            decoration: const InputDecoration(labelText: "Jméno"),
          ),
          const SizedBox(height: 5),
          SimpleDateTimePicker(
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            labelText: 'Datum a čas',
            onChanged: (value) {
              pickedDate = value;
            },
          )
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            if (pickedDate != DateTime.utc(1989, 11, 9)) {
              context.read<PofelBloc>().add(
                    CreatePofel(
                      pofelDesc: 'Žádný popis :/',
                      pofelName: myController.text,
                      date: pickedDate,
                    ),
                  );
              Navigator.pop(context);
            }
          },
          width: 120,
          child: const Text(
            "Create",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    return to.difference(from).inDays;
  }
}
