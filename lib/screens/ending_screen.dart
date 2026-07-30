import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import '../game_controller.dart';

class EndingScreen extends StatelessWidget {
  final GameEnding ending;

  const EndingScreen({super.key, required this.ending});

  @override
  Widget build(BuildContext context) {
    String endingTitle;
    String endingSubtitle;
    Color endingColor;

    switch (ending) {
      case GameEnding.perfectBelle:
        endingTitle = 'The Perfect Belle';
        endingSubtitle = 'A Flawless Debut';
        endingColor = DuchessTheme.goldAccent;
        break;
      case GameEnding.cleverIntellectual:
        endingTitle = 'The Clever Intellectual';
        endingSubtitle = 'Knowledge is True Power';
        endingColor = DuchessTheme.tertiary;
        break;
      case GameEnding.socialDisaster:
        endingTitle = 'The Social Disaster';
        endingSubtitle = 'A Lesson in Humility';
        endingColor = DuchessTheme.secondary;
        break;
      case GameEnding.meltdown:
        endingTitle = 'The Meltdown';
        endingSubtitle = 'Broken Teacups, Broken Dreams';
        endingColor = DuchessTheme.error;
        break;
      case GameEnding.neutral:
        endingTitle = 'A Neutral Path';
        endingSubtitle = 'Average, but Acceptable';
        endingColor = DuchessTheme.onSurfaceVariant;
        break;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient (Fallback)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8F7),
                  Color(0xFFF4C2C2),
                  Color(0xFF7B5455),
                ],
              ),
            ),
          ),
          
          // Full Illustration Placeholder based on ending
          Container(
            color: endingColor.withValues(alpha: 0.2),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 160,
                color: Colors.white54,
              ),
            ),
          ),
          const ParticleOverlay(particleCount: 40),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: DuchessTheme.glassGoldBorder(borderRadius: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FIN',
                        style: DuchessTheme.labelCaps(color: DuchessTheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        endingTitle,
                        style: DuchessTheme.displayTitle(color: DuchessTheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        endingSubtitle,
                        style: DuchessTheme.bodyMain(color: DuchessTheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DuchessTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Return to main menu, clearing all routes
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Text(
                          'RETURN TO TITLE',
                          style: DuchessTheme.labelCaps(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
