import 'package:flutter/material.dart';
import 'package:pofel_app/src/ui/components/pofel_modal.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';

Future<void> showJoinPofelSheet({
  required BuildContext context,
  required ValueChanged<String> onSubmit,
  String initialJoinCode = '',
}) async {
  final controller = TextEditingController(text: initialJoinCode);

  void submit(BuildContext sheetContext) {
    final joinId = controller.text.trim();
    if (joinId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(context, 'Zadej join kód.'),
      );
      return;
    }

    onSubmit(joinId);
    Navigator.pop(sheetContext);
  }

  await showPofelModalSheet<void>(
    context: context,
    builder: (sheetContext) => PofelModalSheet(
      icon: Icons.group_add_rounded,
      title: 'Připojit k pofelu',
      subtitle: 'Zadej kód pofelu',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            decoration: pofelModalInputDecoration(
              labelText: 'Join kód',
              hintText: 'Např. abcd1',
              prefixIcon: Icons.vpn_key_rounded,
            ),
            onSubmitted: (_) => submit(sheetContext),
          ),
          const SizedBox(height: 20),
          PofelModalActions(
            secondaryLabel: 'Zrušit',
            onSecondary: () => Navigator.pop(sheetContext),
            primaryLabel: 'Připojit',
            primaryIcon: Icons.arrow_forward_rounded,
            onPrimary: () => submit(sheetContext),
          ),
        ],
      ),
    ),
  );

  controller.dispose();
}
