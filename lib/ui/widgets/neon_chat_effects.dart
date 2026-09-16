
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../app_theme.dart';

abstract final class NeonColors {
  static const cyan = Color(0xFF00D4FF);
  static const cyanBright = Color(0xFF5CFFFF);
  static const purple = Color(0xFFB56CFF);
  static const violet = Color(0xFF7B5CFF);
  static const magenta = Color(0xFFE040FB);
}

class NeonTypingPill extends StatefulWidget {
  const NeonTypingPill({super.key});
  @override State<NeonTypingPill> createState() => _NeonTypingPillState();
}
class _NeonTypingPillState extends State<NeonTypingPill> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 9, 14, 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: [NeonColors.violet.withValues(alpha: 0.45), NeonColors.cyan.withValues(alpha: 0.22)]),
        border: Border.all(color: NeonColors.cyan.withValues(alpha: 0.55), width: 1.2),
        boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: 0.35), blurRadius: 18, spreadRadius: -2)],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.auto_awesome, size: 15, color: NeonColors.cyanBright),
        const SizedBox(width: 8),
        AnimatedBuilder(animation: _c, builder: (_, __) => Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) {
          final phase = (_c.value + i * 0.22) % 1.0;
          final wave = math.sin(phase * math.pi * 2);
          final o = 0.3 + 0.7 * ((wave + 1) / 2);
          return Transform.translate(offset: Offset(0, -wave * 3.2), child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5), width: 6.5, height: 6.5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: NeonColors.cyan.withValues(alpha: o),
              boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: o * 0.7), blurRadius: 8)]),
          ));
        }))),
        const SizedBox(width: 8),
        const Text('Thinking…', style: TextStyle(color: NeonColors.cyanBright, fontSize: 12.5, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class NeonThinkingOrb extends StatefulWidget {
  const NeonThinkingOrb({super.key, this.size = 100, this.title = 'Thinking…', this.subtitle = 'Analyzing your request…'});
  final double size; final String title; final String subtitle;
  @override State<NeonThinkingOrb> createState() => _NeonThinkingOrbState();
}
class _NeonThinkingOrbState extends State<NeonThinkingOrb> with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat(reverse: true);
  @override void dispose() { _spin.dispose(); _pulse.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [const Color(0xFF081428), NeonColors.violet.withValues(alpha: 0.2), const Color(0xFF0A1A30)]),
        border: Border.all(color: NeonColors.cyan.withValues(alpha: 0.4), width: 1.2),
        boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: 0.22), blurRadius: 28, spreadRadius: -4)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: widget.size * 1.35, height: widget.size,
          child: AnimatedBuilder(animation: Listenable.merge([_spin, _pulse]), builder: (_, __) {
            return CustomPaint(painter: _OrbPainter(_spin.value * math.pi * 2, Curves.easeInOut.transform(_pulse.value)));
          })),
        const SizedBox(height: 12),
        Text(widget.title, style: const TextStyle(color: NeonColors.cyanBright, fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 4),
        Text(widget.subtitle, style: TextStyle(color: NeonColors.cyan.withValues(alpha: 0.55), fontSize: 12.5)),
      ]),
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter(this.t, this.pulse);
  final double t, pulse;
  @override void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.shortestSide * 0.22 * (0.92 + 0.08 * pulse);
    canvas.drawCircle(c, r * 2.2, Paint()..shader = ui.Gradient.radial(c, r * 2.2, [NeonColors.cyan.withValues(alpha: 0.2 * pulse), NeonColors.purple.withValues(alpha: 0.08), Colors.transparent], const [0.0, 0.45, 1.0]));
    for (final ring in [(1.55, 0.42, t * 0.7, NeonColors.cyan, 1.8), (1.4, 0.38, -t * 0.55 + 0.9, NeonColors.purple, 1.4), (1.25, 0.32, t * 0.4 + 1.5, NeonColors.magenta, 1.1)]) {
      canvas.save(); canvas.translate(c.dx, c.dy); canvas.rotate(ring.$3);
      final rect = Rect.fromCenter(center: Offset.zero, width: r * 2 * ring.$1, height: r * 2 * ring.$2);
      canvas.drawOval(rect, Paint()..style = PaintingStyle.stroke..strokeWidth = ring.$5..color = ring.$4.withValues(alpha: 0.55)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5));
      canvas.drawOval(rect, Paint()..style = PaintingStyle.stroke..strokeWidth = ring.$5 * 0.6..color = ring.$4.withValues(alpha: 0.9));
      canvas.restore();
    }
    canvas.drawCircle(c, r, Paint()..shader = ui.Gradient.radial(c.translate(-r * 0.25, -r * 0.3), r * 1.4, const [Color(0xFFE8FFFF), NeonColors.cyan, NeonColors.violet, Color(0xFF2A1060)], const [0.0, 0.35, 0.7, 1.0]));
    canvas.drawCircle(c.translate(-r * 0.28, -r * 0.32), r * 0.28, Paint()..color = Colors.white.withValues(alpha: 0.45));
  }
  @override bool shouldRepaint(covariant _OrbPainter old) => old.t != t || old.pulse != pulse;
}

class NeonGeneratingCard extends StatefulWidget {
  const NeonGeneratingCard({super.key});
  @override State<NeonGeneratingCard> createState() => _NeonGeneratingCardState();
}
class _NeonGeneratingCardState extends State<NeonGeneratingCard> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 4800))..repeat();
  static const steps = ['Analyzing request', 'Finding best approach', 'Preparing detailed answer', 'Adding finishing touches'];
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _c, builder: (_, __) {
      final progress = _c.value;
      final doneCount = (progress * (steps.length + 0.2)).floor().clamp(0, steps.length);
      return Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(colors: [const Color(0xFF081428), NeonColors.violet.withValues(alpha: 0.25)]),
          border: Border.all(color: NeonColors.cyan.withValues(alpha: 0.5), width: 1.2),
          boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: 0.25), blurRadius: 24, spreadRadius: -2)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.graphic_eq_rounded, size: 18, color: NeonColors.cyanBright), SizedBox(width: 8),
            Text('Generating response…', style: TextStyle(color: NeonColors.cyanBright, fontWeight: FontWeight.w700, fontSize: 14))]),
          const SizedBox(height: 12),
          for (var i = 0; i < steps.length; i++)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
              Icon(i < doneCount ? Icons.check_circle_rounded : Icons.circle_outlined, size: 16, color: i < doneCount ? NeonColors.cyan : NeonColors.cyan.withValues(alpha: 0.3)),
              const SizedBox(width: 8),
              Expanded(child: Text(steps[i], style: TextStyle(color: i < doneCount ? const Color(0xFFD0E8FF) : const Color(0xFF5A7088), fontSize: 12.5))),
            ])),
          ClipRRect(borderRadius: BorderRadius.circular(99), child: LinearProgressIndicator(value: progress.clamp(0.08, 1.0), minHeight: 5, backgroundColor: const Color(0xFF152238), color: NeonColors.cyan)),
        ]),
      );
    });
  }
}

class NeonMessageShell extends StatelessWidget {
  const NeonMessageShell({super.key, required this.child, this.streaming = false});
  final Widget child; final bool streaming;
  @override Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard + 4),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF0A1528), NeonColors.violet.withValues(alpha: streaming ? 0.28 : 0.16), const Color(0xFF0C1830)]),
        border: Border.all(color: NeonColors.cyan.withValues(alpha: streaming ? 0.6 : 0.38), width: 1.15),
        boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: streaming ? 0.32 : 0.16), blurRadius: streaming ? 30 : 20, spreadRadius: -4)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: child,
    );
  }
}

class NeonAssistantStream extends StatelessWidget {
  const NeonAssistantStream({super.key, required this.text, required this.streaming, required this.child});
  final String text; final bool streaming; final Widget child;
  @override Widget build(BuildContext context) {
    if (!streaming) return NeonMessageShell(child: child);
    final len = text.trim().length;
    if (len == 0) return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [NeonTypingPill(), SizedBox(height: 12), NeonThinkingOrb()]);
    if (len < 48) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const NeonGeneratingCard(), const SizedBox(height: 10), NeonMessageShell(streaming: true, child: child)]);
    return NeonMessageShell(streaming: true, child: child);
  }
}

class NeonHeroIcon extends StatefulWidget {
  const NeonHeroIcon({super.key, this.size = 110});
  final double size;
  @override State<NeonHeroIcon> createState() => _NeonHeroIconState();
}
class _NeonHeroIconState extends State<NeonHeroIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 7))..repeat();
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    return AnimatedBuilder(animation: _c, builder: (_, __) {
      final t = _c.value * math.pi * 2;
      return SizedBox(width: widget.size * 1.45, height: widget.size * 1.15, child: CustomPaint(painter: _OrbPainter(t, 0.6),
        child: Center(child: Container(
          width: widget.size * 0.42, height: widget.size * 0.42,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(colors: [Color(0xFF4AA9FF), NeonColors.violet]),
            border: Border.all(color: Colors.white24), boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: 0.5), blurRadius: 24)]),
          child: const Center(child: Text('>_', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20, fontFamily: AppTheme.monoFamily))),
        ))));
    });
  }
}

class NeonSuggestionCard extends StatelessWidget {
  const NeonSuggestionCard({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon; final String title; final String subtitle; final VoidCallback onTap;
  @override Widget build(BuildContext context) {
    return Material(color: Colors.transparent, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Ink(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFF0A1220).withValues(alpha: 0.9),
        border: Border.all(color: NeonColors.cyan.withValues(alpha: 0.3)), boxShadow: [BoxShadow(color: NeonColors.cyan.withValues(alpha: 0.1), blurRadius: 14)]),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: LinearGradient(colors: [NeonColors.violet.withValues(alpha: 0.75), NeonColors.cyan.withValues(alpha: 0.55)])),
          child: Icon(icon, color: Colors.white, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Color(0xFFE8F4FF), fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: NeonColors.cyan.withValues(alpha: 0.55), fontSize: 12)),
        ])),
        Icon(Icons.chevron_right_rounded, color: NeonColors.cyan.withValues(alpha: 0.5)),
      ]),
    )));
  }
}
