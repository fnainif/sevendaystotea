import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import 'gameplay_hub_screen.dart';
import 'story_scene_screen.dart';
import 'endings_screen.dart';
import 'settings_screen.dart';
import '../game_controller.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Overlay simulating the Royal Garden Bathed in Warm Sunlight
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF0EF),
                  Color(0xFFF4C2C2),
                  Color(0xFF7B5455),
                ],
              ),
            ),
          ),
          
          // Soft ambient rose vignette
          Positioned.fill(
            child: Container(
              color: DuchessTheme.primary.withValues(alpha: 0.15),
            ),
          ),

          // Particle Overlay
          const ParticleOverlay(particleCount: 30),

          // Main Menu Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                
                // Title Header Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
                    decoration: DuchessTheme.glassGoldBorder(borderRadius: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lady in Training',
                          style: DuchessTheme.displayTitle(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 1,
                          width: 180,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                DuchessTheme.goldAccent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '7 Days to Tea',
                          style: DuchessTheme.headlineLg(
                            color: DuchessTheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Menu Buttons Stack
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ListenableBuilder(
                    listenable: gameController,
                    builder: (context, child) {
                      return Column(
                        children: [
                          if (gameController.hasSavedState) ...[
                            _buildMenuButton(
                              context,
                              label: 'CONTINUE',
                              isPrimary: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GameplayHubScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          _buildMenuButton(
                            context,
                            label: 'NEW GAME',
                            isPrimary: !gameController.hasSavedState,
                            onPressed: () {
                              gameController.startNewGame();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorySceneScreen(
                                    onFinish: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const GameplayHubScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildMenuButton(
                            context,
                            label: 'ENDINGS',
                            isPrimary: false,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EndingsScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildMenuButton(
                            context,
                            label: 'SETTINGS',
                            isPrimary: false,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary
                ? DuchessTheme.primaryContainer.withValues(alpha: 0.85)
                : DuchessTheme.surfaceContainer.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: DuchessTheme.goldAccent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isPrimary
                    ? DuchessTheme.primaryContainer.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isPrimary) ...[
                const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: DuchessTheme.tertiary,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: DuchessTheme.labelCaps(
                  color: isPrimary
                      ? DuchessTheme.onPrimaryContainer
                      : DuchessTheme.onSurfaceVariant,
                ),
              ),
              if (isPrimary) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: DuchessTheme.tertiary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
