import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';

Future<T?> showPofelModalSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.34),
    builder: builder,
  );
}

class PofelModalSheet extends StatelessWidget {
  const PofelModalSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.accentGradient = PofelPalette.buttonGradient,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Gradient accentGradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(0, 12, 0, bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: PofelPalette.surface,
                borderRadius: BorderRadius.circular(34),
                boxShadow: const [
                  BoxShadow(
                    color: PofelPalette.shadow,
                    blurRadius: 26,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 54,
                        height: 6,
                        decoration: BoxDecoration(
                          color: PofelPalette.softLilac,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (icon != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: accentGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: PofelPalette.shadow,
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(icon, color: Colors.white, size: 26),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                softWrap: true,
                                style: GoogleFonts.nunito(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: PofelPalette.text,
                                  height: 1,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  subtitle!,
                                  softWrap: true,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: PofelPalette.text.withValues(alpha: 0.68),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PofelModalActions extends StatelessWidget {
  const PofelModalActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.primaryGradient = PofelPalette.buttonGradient,
    this.primaryIcon,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Gradient primaryGradient;
  final IconData? primaryIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (secondaryLabel != null && onSecondary != null) ...[
          PofelOutlineButton(
            label: secondaryLabel!,
            onPressed: onSecondary!,
            color: PofelPalette.softLilac,
            textColor: PofelPalette.text,
          ),
          const SizedBox(height: 12),
        ],
        _PrimaryModalButton(
          label: primaryLabel,
          icon: primaryIcon,
          gradient: primaryGradient,
          onPressed: onPrimary,
        ),
      ],
    );
  }
}

class _PrimaryModalButton extends StatelessWidget {
  const _PrimaryModalButton({
    required this.label,
    required this.gradient,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Gradient gradient;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: PofelPalette.shadow,
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 22),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            minimumSize: const Size.fromHeight(62),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration pofelModalInputDecoration({
  required String labelText,
  String? hintText,
  IconData? prefixIcon,
  String? helperText,
}) {
  OutlineInputBorder border(Color color, {double width = 1.6}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    helperText: helperText,
    helperMaxLines: 2,
    filled: true,
    fillColor: const Color(0xFFF7F1FC),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: PofelPalette.primary, size: 22),
    labelStyle: GoogleFonts.nunito(
      color: PofelPalette.text.withValues(alpha: 0.7),
      fontWeight: FontWeight.w700,
    ),
    hintStyle: GoogleFonts.nunito(
      color: PofelPalette.text.withValues(alpha: 0.36),
      fontWeight: FontWeight.w600,
    ),
    helperStyle: GoogleFonts.nunito(
      color: PofelPalette.text.withValues(alpha: 0.54),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
    enabledBorder: border(PofelPalette.softLilac),
    focusedBorder: border(PofelPalette.primary, width: 2),
    errorBorder: border(const Color(0xFFD1456E), width: 1.8),
    focusedErrorBorder: border(const Color(0xFFD1456E), width: 2),
    border: border(PofelPalette.softLilac),
  );
}
