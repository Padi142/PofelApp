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
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/simple_date_time_picker.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';

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
                      if (state is LoadPofelsWithData && state.loadPofelStateEnum == LoadPofelsStateEnum.POFELS_LOADED) {
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
    showPofelModalSheet<void>(
      context: context,
      builder: (sheetContext) => PofelModalSheet(
        icon: Icons.group_add_rounded,
        title: 'Připojit k pofelu',
        subtitle: 'Zadej kód pofelu',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: myController,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.done,
              decoration: pofelModalInputDecoration(
                labelText: 'Join kód',
                hintText: 'Např. abcd1',
                prefixIcon: Icons.vpn_key_rounded,
              ),
              onSubmitted: (_) => _submitJoin(sheetContext),
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Připojit',
              primaryIcon: Icons.arrow_forward_rounded,
              onPrimary: () => _submitJoin(sheetContext),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    myController.clear();
    DateTime pickedDate = DateTime.utc(1989, 11, 9);
    showPofelModalSheet<void>(
      context: context,
      builder: (sheetContext) => PofelModalSheet(
        icon: Icons.celebration_rounded,
        title: 'Vytvořit pofel',
        subtitle: 'Pojmenuj akci a nastav termín.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: myController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: pofelModalInputDecoration(
                labelText: 'Jméno pofelu',
                hintText: 'Např. Birthday warmup',
                prefixIcon: Icons.badge_rounded,
              ),
            ),
            const SizedBox(height: 14),
            SimpleDateTimePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              labelText: 'Datum a čas',
              onChanged: (value) {
                pickedDate = value;
              },
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Vytvořit',
              primaryIcon: Icons.check_rounded,
              onPrimary: () {
                final name = myController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarError(context, 'Zadej jméno pofelu.'),
                  );
                  return;
                }
                if (pickedDate == DateTime.utc(1989, 11, 9)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarError(context, 'Vyber datum a čas.'),
                  );
                  return;
                }
                context.read<PofelBloc>().add(
                      CreatePofel(
                        pofelDesc: 'Žádný popis :/',
                        pofelName: name,
                        date: pickedDate,
                      ),
                    );
                Navigator.pop(sheetContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitJoin(BuildContext sheetContext) {
    final joinId = myController.text.trim();
    if (joinId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(context, 'Zadej join kód.'),
      );
      return;
    }
    context.read<PofelBloc>().add(JoinPofel(joinId: joinId));
    Navigator.pop(sheetContext);
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
