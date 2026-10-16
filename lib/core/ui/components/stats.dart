import 'dart:async';

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../format.dart';
import '../app_icons.dart';
import './cards.dart';

// ================================================================ Divers

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.emoji,
    this.delta,
    this.color,
  });

  final String label;
  final String value;
  final String? emoji;
  final String? delta;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11.5,
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTheme.montserrat,
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: color ?? cs.onSurface,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Text(delta!,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.w700)),
          ],
        ],
      ),
    );
  }
}

class BarChartMini extends StatelessWidget {
  const BarChartMini({super.key, required this.values, this.labels = const []});

  final List<int> values;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxValue = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      height: (values[i] / maxValue) * 82 + 8,
                      decoration: BoxDecoration(
                        color: i == values.length - 1
                            ? cs.primary
                            : cs.primary.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (i < labels.length)
                      Text(
                        labels[i],
                        style: TextStyle(
                            fontSize: 10, color: cs.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class StepBar extends StatelessWidget {
  const StepBar({super.key, required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2.5,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: i <= current
                      ? cs.primary
                      : cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: i <= current ? cs.primary : cs.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: i < current
                    ? const AppIcon(AppIcons.check_rounded,
                        size: 15, color: Colors.white)
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: i <= current ? Colors.white : cs.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(height: 5),
              Text(
                steps[i],
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: i <= current ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Compte à rebours des offres flash (fin à minuit).
class CountdownText extends StatefulWidget {
  const CountdownText({super.key, this.size = 12});

  final double size;

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = _computeRemaining());
    });
  }

  Duration _computeRemaining() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        durationHms(_remaining),
        style: TextStyle(
          fontSize: widget.size,
          fontWeight: FontWeight.w800,
          color: AppColors.danger,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
