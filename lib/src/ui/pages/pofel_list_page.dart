import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';

class PofelListPage extends StatefulWidget {
  const PofelListPage({super.key});

  @override
  State<PofelListPage> createState() => _PofelListPageState();
}

class _PofelListPageState extends State<PofelListPage> {
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: PofelPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: PofelSectionTitle('Moje pofely')),
            const SizedBox(height: 16),
            BlocBuilder<LoadpofelsBloc, LoadpofelsState>(
              builder: (context, state) {
                if (state is LoadPofelsWithData &&
                    state.loadPofelStateEnum ==
                        LoadPofelsStateEnum.POFELS_LOADED) {
                  if (state.myPofels.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 36),
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
                                  PofelDetailPageEvent(pofelId: pofel.pofelId),
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
            const SizedBox(height: 8),
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
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day, from.hour, from.minute);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
    return to.difference(from).inDays;
  }
}
