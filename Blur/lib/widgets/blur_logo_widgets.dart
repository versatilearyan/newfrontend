import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Reusable Blur Logo Widget ─────────────────────────────────────────────────
// Usage:
//   BlurLogo(size: 44)           // square icon (drawer, app bar)
//   BlurLogo(size: 80)           // large (get started screen)
//   BlurLogo(size: 44, rounded: true) // with border radius (default)
// ─────────────────────────────────────────────────────────────────────────────
class BlurLogo extends StatelessWidget {
  final double size;
  final bool rounded;
  final double? borderRadius;

  const BlurLogo({
    super.key,
    this.size = 44,
    this.rounded = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? size * 0.22;

    final logo = Image.asset(
      'assets/images/blur_logo.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      // Fallback if asset not found yet
      errorBuilder: (_, __, ___) => _FallbackLogo(size: size, radius: radius),
    );

    if (!rounded) return logo;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: size, height: size, child: logo),
    );
  }
}

// ── Fallback (shows until asset is added) ────────────────────────────────────
class _FallbackLogo extends StatelessWidget {
  final double size;
  final double radius;
  const _FallbackLogo({required this.size, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          'blur',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.28,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW TO USE IN EACH SCREEN
// ─────────────────────────────────────────────────────────────────────────────

// ── 1. DRAWER HEADER (home_screen.dart) ──────────────────────────────────────
// Replace:
//   Container(
//     width: 44, height: 44,
//     decoration: BoxDecoration(color: AppTheme.primary, borderRadius: ...),
//     child: const Icon(Icons.blur_on, color: Colors.white, size: 24),
//   )
//
// With:
//   BlurLogo(size: 44)

// ── 2. GET STARTED SCREEN (get_started_screen.dart) ──────────────────────────
// Add at the top of the hero card or above it:
//   BlurLogo(size: 72)
//
// Or replace the "CampusBlind" AppBar title text with:
//   Row(children: [BlurLogo(size: 28), SizedBox(width: 8), Text('blur')])

// ── 3. APP BAR (lounges_screen.dart, profile_screen.dart) ────────────────────
// Replace the star icon + text:
//   Row(
//     children: [
//       Icon(Icons.star, color: AppTheme.primary, size: 18),
//       SizedBox(width: 6),
//       Text('CampusBlind', ...)
//     ]
//   )
//
// With:
//   Row(
//     children: [
//       BlurLogo(size: 28),
//       SizedBox(width: 8),
//       Text('Blur', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700))
//     ]
//   )

// ── 4. SPLASH / ONBOARDING ───────────────────────────────────────────────────
//   Center(child: BlurLogo(size: 100))