import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_bloc.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_event.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget TodoNotDoneContainer(
  BuildContext context,
  TodoModel todo,
  PofelModel pofel,
  TodoBloc todoBloc,
) {
  return _TodoCard(
    todo: todo,
    accent: PofelPalette.accentBlue,
    icon: Icons.timelapse_rounded,
    chipLabel: 'Otevřený',
    onTap: () => _showTodoSheet(context, pofel, todo, todoBloc),
  );
}

Widget TodoDoneContainer(
  BuildContext context,
  TodoModel todo,
  PofelModel pofel,
  TodoBloc todoBloc,
) {
  return _TodoCard(
    todo: todo,
    accent: const Color(0xFF29956A),
    icon: Icons.verified_rounded,
    chipLabel: 'Hotovo',
    done: true,
    onTap: () => _showTodoSheet(context, pofel, todo, todoBloc),
  );
}

class _TodoCard extends StatelessWidget {
  const _TodoCard({
    required this.todo,
    required this.accent,
    required this.icon,
    required this.chipLabel,
    required this.onTap,
    this.done = false,
  });

  final TodoModel todo;
  final Color accent;
  final IconData icon;
  final String chipLabel;
  final VoidCallback onTap;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: 0.15),
              done ? const Color(0xFFF4FAF7) : Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: accent.withValues(alpha: 0.22),
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: PofelPalette.shadow,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: accent, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.todoTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: done
                          ? PofelPalette.text.withValues(alpha: 0.64)
                          : PofelPalette.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pro: ${todo.assignedToName}',
                    style: TextStyle(
                      color: PofelPalette.text.withValues(alpha: 0.62),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    chipLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 18,
                  foregroundImage: NetworkImage(todo.assignedToProfilePic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showTodoSheet(
  BuildContext context,
  PofelModel pofel,
  TodoModel todo,
  TodoBloc todoBloc,
) {
  final accent =
      todo.isDone ? const Color(0xFF29956A) : PofelPalette.accentBlue;
  final icon =
      todo.isDone ? Icons.verified_rounded : Icons.assignment_turned_in_rounded;

  showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: icon,
      accentGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, PofelPalette.primary],
      ),
      title: todo.todoTitle,
      subtitle: todo.isDone
          ? 'Quest je hotový, ale pořád jde vrátit zpět mezi otevřené.'
          : 'Přehled questu a rychlé akce pro jeho dokončení.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TodoDetailRow(label: 'Komu', value: todo.assignedToName),
          const SizedBox(height: 10),
          _TodoDetailRow(
            label: 'Zadal',
            value: todo.assignedByName.isEmpty
                ? 'Někdo z pofelu'
                : todo.assignedByName,
          ),
          const SizedBox(height: 10),
          _TodoDetailRow(
            label: 'Stav',
            value: todo.isDone ? 'Hotovo' : 'Čeká na splnění',
          ),
          const SizedBox(height: 10),
          _TodoDetailRow(
            label: 'Přiřazeno',
            value: DateFormat('dd.MM.  HH:mm').format(todo.assignedOn),
          ),
          if (todo.isDone) ...[
            const SizedBox(height: 10),
            _TodoDetailRow(
              label: 'Dokončeno',
              value: DateFormat('dd.MM.  HH:mm').format(todo.doneOn),
            ),
          ],
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zavřít',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel:
                todo.isDone ? 'Vrátit mezi otevřené' : 'Označit hotovo',
            primaryIcon: todo.isDone
                ? Icons.refresh_rounded
                : Icons.check_circle_outline_rounded,
            primaryGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: todo.isDone
                  ? [const Color(0xFFB98627), const Color(0xFFD7601B)]
                  : [const Color(0xFF29956A), const Color(0xFF1E7D57)],
            ),
            onPrimary: () async {
              final navigator = Navigator.of(sheetContext);
              final prefs = await SharedPreferences.getInstance();
              final uid = prefs.getString("uid");

              if (uid == todo.assignedToUid || uid == pofel.adminUid) {
                if (todo.isDone) {
                  todoBloc.add(
                    UnfinishTodo(
                      pofelId: pofel.pofelId,
                      todoId: todo.todoId,
                    ),
                  );
                } else {
                  todoBloc.add(
                    FinishTodo(
                      pofelId: pofel.pofelId,
                      todoId: todo.todoId,
                    ),
                  );
                }
              }
              navigator.pop();
            },
          ),
        ],
      ),
    ),
  );
}

class _TodoDetailRow extends StatelessWidget {
  const _TodoDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: PofelPalette.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: PofelPalette.text.withValues(alpha: 0.56),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: PofelPalette.text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
