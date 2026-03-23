import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_bloc.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_event.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/components/todo_container.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import '../../../core/bloc/todo_bloc/todo_bloc_state.dart';

Widget PofelTodosPage(BuildContext context, PofelModel pofel) {
  TodoBloc todoBloc = TodoBloc();
  todoBloc.add(LoadTodos(pofelId: pofel.pofelId));

  return Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
    child: BlocProvider(
      create: (context) => todoBloc,
      child: BlocListener<TodoBloc, TodoBlocState>(
        listener: (context, state) {
          if (state is TodosWithData &&
              state.todosEnum == TodosEnum.TODO_UPDATED) {
            todoBloc.add(LoadTodos(pofelId: pofel.pofelId));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _QuestHero(),
            const SizedBox(height: 14),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoBlocState>(
                builder: (context, state) {
                  if (state is! TodosWithData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: PofelPalette.primary,
                      ),
                    );
                  }

                  final totalTodos =
                      state.notDoneTodos.length + state.doneTodos.length;

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _QuestStatsCard(
                        openCount: state.notDoneTodos.length,
                        doneCount: state.doneTodos.length,
                        totalCount: totalTodos,
                      ),
                      const SizedBox(height: 14),
                      _QuestSection(
                        title: 'Probíhající questy',
                        subtitle: 'Věci, které je ještě potřeba zařídit.',
                        color: const Color(0xFF2F6FD6),
                        icon: Icons.timelapse_rounded,
                        todos: state.notDoneTodos,
                        emptyMessage:
                            'Všechny aktivní questy jsou hotové. Můžeš přidat další.',
                        pofel: pofel,
                        todoBloc: todoBloc,
                      ),
                      const SizedBox(height: 14),
                      _QuestSection(
                        title: 'Hotové questy',
                        subtitle: 'Splněné úkoly, které už někdo odmakal.',
                        color: const Color(0xFF29956A),
                        icon: Icons.verified_rounded,
                        todos: state.doneTodos,
                        emptyMessage: 'Tady se zatím nic nesplnilo.',
                        pofel: pofel,
                        todoBloc: todoBloc,
                        completed: true,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: PofelOutlineButton(
                    label: 'Zpět',
                    onPressed: () {
                      context.read<PofelDetailNavigationBloc>().add(
                            const PofelInfoEvent(),
                          );
                    },
                    color: const Color(0xFFE59AA8),
                    textColor: const Color(0xFF7E2642),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PofelGradientButton(
                    label: 'Přidat quest',
                    icon: Icons.add_task_rounded,
                    onPressed: () {
                      _showAddTodoSheet(context, pofel, todoBloc);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _QuestHero extends StatelessWidget {
  const _QuestHero();

  @override
  Widget build(BuildContext context) {
    return PofelPanel(
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(
                Icons.assignment_turned_in_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questy pofelu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rozděl úkoly mezi lidi a měj přehled, co už je hotové.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestStatsCard extends StatelessWidget {
  const _QuestStatsCard({
    required this.openCount,
    required this.doneCount,
    required this.totalCount,
  });

  final int openCount;
  final int doneCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: _QuestStatTile(
              label: 'Otevřené',
              value: openCount.toString(),
              color: PofelPalette.accentBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuestStatTile(
              label: 'Hotové',
              value: doneCount.toString(),
              color: const Color(0xFF29956A),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _QuestStatTile(
              label: 'Celkem',
              value: totalCount.toString(),
              color: PofelPalette.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestStatTile extends StatelessWidget {
  const _QuestStatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: PofelPalette.text.withValues(alpha: 0.64),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestSection extends StatelessWidget {
  const _QuestSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.todos,
    required this.emptyMessage,
    required this.pofel,
    required this.todoBloc,
    this.completed = false,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final List<TodoModel> todos;
  final String emptyMessage;
  final PofelModel pofel;
  final TodoBloc todoBloc;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: PofelPalette.text,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: PofelPalette.text.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${todos.length}x',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (todos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: PofelPalette.background,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                emptyMessage,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: PofelPalette.text.withValues(alpha: 0.58),
                ),
              ),
            )
          else
            Column(
              children: List.generate(
                todos.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index == todos.length - 1 ? 0 : 10,
                  ),
                  child: completed
                      ? TodoDoneContainer(
                          context,
                          todos[index],
                          pofel,
                          todoBloc,
                        )
                      : TodoNotDoneContainer(
                          context,
                          todos[index],
                          pofel,
                          todoBloc,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

List<DropdownMenuItem<String>> getDropdownItems(List<PofelUserModel> users) {
  return users
      .map(
        (user) => DropdownMenuItem(
          value: user.uid,
          child: Text(user.name),
        ),
      )
      .toList();
}

Future<void> _showAddTodoSheet(
  BuildContext context,
  PofelModel pofel,
  TodoBloc todoBloc,
) {
  final form = fb.group(<String, Object>{
    'name': FormControl<String>(validators: [Validators.required]),
    'clovek': FormControl<String>(validators: [Validators.required]),
  });

  return showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.assignment_turned_in_rounded,
      title: 'Přidat quest',
      subtitle:
          'Sepiš úkol a rovnou ho přiřaď člověku, který si ho má vzít na starost.',
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReactiveTextField<String>(
              formControlName: 'name',
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => 'Doplň název questu.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Jméno questu',
                hintText: 'Např. Vzít led z benzínky',
                prefixIcon: Icons.task_alt_rounded,
              ),
              onSubmitted: (_) => form.focus('clovek'),
            ),
            const SizedBox(height: 12),
            ReactiveDropdownField<String>(
              formControlName: 'clovek',
              validationMessages: {
                ValidationMessage.required: (_) => 'Vyber, komu quest patří.',
              },
              decoration: pofelModalInputDecoration(
                labelText: 'Komu to připíšeme?',
                hintText: 'Vyber člověka',
                prefixIcon: Icons.person_search_rounded,
              ),
              items: getDropdownItems(pofel.signedUsers),
            ),
            const SizedBox(height: 20),
            PofelModalActions(
              secondaryLabel: 'Zrušit',
              onSecondary: () => Navigator.pop(sheetContext),
              primaryLabel: 'Přiřadit quest',
              primaryIcon: Icons.add_task_rounded,
              onPrimary: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(sheetContext);
                final successSnackBar = SnackBarAlert(context, 'Quest zadán!');
                if (!form.valid) {
                  form.markAllAsTouched();
                  messenger.showSnackBar(
                    SnackBarError(
                      context,
                      'Zkontroluj prosím zvýrazněná pole.',
                    ),
                  );
                  return;
                }

                final prefs = await SharedPreferences.getInstance();
                final uid = prefs.getString("uid");
                final questName =
                    (form.control('name').value as String?)?.trim() ?? '';
                final assignedUid = form.control('clovek').value as String?;

                if (uid == null || questName.isEmpty || assignedUid == null) {
                  form.markAllAsTouched();
                  return;
                }

                final assignedUser = pofel.signedUsers.firstWhere(
                  (user) => user.uid == assignedUid,
                );

                todoBloc.add(
                  AddTodoEvent(
                    assignedByName: "",
                    assignedByProfilePic: '',
                    assignedByUid: uid,
                    assignedToName: assignedUser.name,
                    assignedToProfilePic: assignedUser.photo,
                    assignedToUid: assignedUser.uid,
                    isDone: false,
                    pofelId: pofel.pofelId,
                    todoTitle: questName,
                  ),
                );
                messenger.showSnackBar(successSnackBar);
                navigator.pop();
              },
            ),
          ],
        ),
      ),
    ),
  );
}
