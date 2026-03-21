import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PofelPalette {
  static const background = Color(0xFFF8F6FB);
  static const surface = Colors.white;
  static const primary = Color(0xFF7B1BC5);
  static const primaryDark = Color(0xFF44105F);
  static const accentBlue = Color(0xFF2F6FD6);
  static const softLilac = Color(0xFFE4D5F4);
  static const premium = Color(0xFFFFE95A);
  static const shadow = Color(0x220F0A18);
  static const text = Color(0xFF14111A);

  static const panelGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentBlue, primary],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, primary],
  );

  static const warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB119B4), Color(0xFFD84A1B)],
  );
}

class PofelScreenBackground extends StatelessWidget {
  const PofelScreenBackground({
    super.key,
    required this.child,
    this.showBottomBlobs = false,
  });

  final Widget child;
  final bool showBottomBlobs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PofelPalette.background,
      child: Stack(
        children: [
          if (showBottomBlobs) ...[
            Positioned(
              left: -120,
              right: -40,
              bottom: -170,
              child: Container(
                height: 420,
                decoration: const BoxDecoration(
                  gradient: PofelPalette.panelGradient,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(220)),
                ),
              ),
            ),
            Positioned(
              right: -80,
              bottom: -120,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
          child,
          const Positioned(
            top: -2,
            right: -2,
            child: _CornerRibbon(),
          ),
        ],
      ),
    );
  }
}

class PofelTopBar extends StatelessWidget {
  const PofelTopBar({
    super.key,
    this.onNotificationTap,
    this.compact = false,
  });

  final VoidCallback? onNotificationTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, compact ? 8 : 10, 16, compact ? 6 : 10),
      child: Row(
        children: [
          const Expanded(
              child: Align(
                  alignment: Alignment.centerLeft, child: PofelWordmark())),
          InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: PofelPalette.primary,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PofelWordmark extends StatelessWidget {
  const PofelWordmark({
    super.key,
    this.showVersion = false,
    this.size = 36,
  });

  final bool showVersion;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              PofelPalette.buttonGradient.createShader(bounds),
          child: Text(
            'POFEL',
            style: GoogleFonts.nunito(
              fontSize: size,
              fontWeight: FontWeight.w900,
              letterSpacing: -2.6,
              color: Colors.white,
              height: 0.95,
            ),
          ),
        ),
        if (showVersion) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '2.0',
              style: GoogleFonts.nunito(
                fontSize: size * 0.52,
                fontWeight: FontWeight.w900,
                color: PofelPalette.text,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class PofelPanel extends StatelessWidget {
  const PofelPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: PofelPalette.panelGradient,
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: PofelPalette.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class PofelSurfaceCard extends StatelessWidget {
  const PofelSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PofelPalette.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: PofelPalette.shadow,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class PofelGradientButton extends StatelessWidget {
  const PofelGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = PofelPalette.buttonGradient,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 24),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(62),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class PofelAppleSignInButton extends StatelessWidget {
  const PofelAppleSignInButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Sign in with Apple',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PofelOutlineButton extends StatelessWidget {
  const PofelOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = PofelPalette.primary,
    this.textColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(62),
        side: BorderSide(color: color, width: 3.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        foregroundColor: textColor ?? color,
        textStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: Text(label),
    );
  }
}

class PofelActionPill extends StatelessWidget {
  const PofelActionPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 26),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(66),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 2.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        textStyle: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class PofelQuickAction extends StatelessWidget {
  const PofelQuickAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: PofelPalette.buttonGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: PofelPalette.shadow,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.white, size: 28),
            constraints: const BoxConstraints.tightFor(width: 78, height: 78),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PofelPalette.text,
          ),
        ),
      ],
    );
  }
}

class PofelInfoRow extends StatelessWidget {
  const PofelInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PofelPalette.text,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: PofelPalette.text,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: PofelSurfaceCard(child: content),
    );
  }
}

class PofelSectionTitle extends StatelessWidget {
  const PofelSectionTitle(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: PofelPalette.text,
      ),
    );
  }
}

class _CornerRibbon extends StatelessWidget {
  const _CornerRibbon();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.78,
      child: Container(
        width: 42,
        height: 14,
        decoration: const BoxDecoration(
          color: Color(0xFFB95656),
          boxShadow: [
            BoxShadow(
              color: PofelPalette.shadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}
