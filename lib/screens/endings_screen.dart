import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import '../game_controller.dart';
import '../epilogue_scripts.dart';
import 'story_scene_screen.dart';
import 'ending_screen.dart';

class EndingsScreen extends StatefulWidget {
  const EndingsScreen({super.key});

  @override
  State<EndingsScreen> createState() => _EndingsScreenState();
}

class _EndingsScreenState extends State<EndingsScreen> {
  final List<GameEnding> _endingsOrder = [
    GameEnding.cleverIntellectual,
    GameEnding.socialDisaster,
    GameEnding.meltdown,
    GameEnding.neutral,
    GameEnding.perfectBelle,
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Overlay
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
          
          const ParticleOverlay(particleCount: 20),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: DuchessTheme.primary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ENDINGS GALLERY',
                        style: DuchessTheme.displayTitle(color: DuchessTheme.primary),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 5 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 0.65 : 0.7, // Vertical CG aspect ratio
                      ),
                      itemCount: _endingsOrder.length,
                      itemBuilder: (context, index) {
                        final ending = _endingsOrder[index];
                        final isUnlocked = gameController.unlockedEndings.contains(ending);
                        return _buildEndingCard(ending, isUnlocked);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndingCard(GameEnding ending, bool isUnlocked) {
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StorySceneScreen(
                customDialogues: getEpilogueDialogue(ending),
                onFinish: () {
                  // After epilogue dialogue finishes, replace with Ending Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EndingScreen(ending: ending),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: DuchessTheme.glassGoldBorder(borderRadius: 12),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder CG Image
            Container(
              color: DuchessTheme.surfaceContainerHigh,
              child: const Icon(
                Icons.image,
                size: 48,
                color: DuchessTheme.primaryContainer,
              ),
            ),
            
            if (!isUnlocked) ...[
              // Blur for locked state
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '???',
                        style: DuchessTheme.headlineLg(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Unlocked title banner
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    _getEndingTitle(ending),
                    style: DuchessTheme.labelCaps(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEndingTitle(GameEnding ending) {
    switch (ending) {
      case GameEnding.perfectBelle: return 'The Perfect Belle';
      case GameEnding.cleverIntellectual: return 'The Clever Intellectual';
      case GameEnding.socialDisaster: return 'The Social Disaster';
      case GameEnding.meltdown: return 'The Meltdown';
      case GameEnding.neutral: return 'A Neutral Path';
    }
  }
}
