import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import 'story_scene_screen.dart';
import 'action_execution_screen.dart';
import 'ending_screen.dart';
import '../game_controller.dart';
import '../epilogue_scripts.dart';
import 'settings_screen.dart';

class GameplayHubScreen extends StatefulWidget {
  const GameplayHubScreen({super.key});

  @override
  State<GameplayHubScreen> createState() => _GameplayHubScreenState();
}

class _GameplayHubScreenState extends State<GameplayHubScreen> {
  
  @override
  void initState() {
    super.initState();
    gameController.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    gameController.removeListener(_onGameStateChanged);
    super.dispose();
  }

  void _onGameStateChanged() {
    if (gameController.gamePhase == GamePhase.epilogue) {
      gameController.removeListener(_onGameStateChanged);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StorySceneScreen(
            customDialogues: getEpilogueDialogue(gameController.achievedEnding!),
          ),
        ),
      ).then((_) {
        gameController.addListener(_onGameStateChanged);
        gameController.finishEpilogue();
      });
    } else if (gameController.gamePhase == GamePhase.ending) {
      gameController.removeListener(_onGameStateChanged);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EndingScreen(ending: gameController.achievedEnding!),
        ),
      );
    }
  }

  void _executeActivity(String activityName, int poiseDelta, int knowledgeDelta, int stressDelta) {
    if (gameController.gamePhase != GamePhase.active) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionExecutionScreen(
          activityName: activityName,
          poiseDelta: poiseDelta,
          knowledgeDelta: knowledgeDelta,
          stressDelta: stressDelta,
          onComplete: () {
            gameController.executeActivity(poiseDelta, knowledgeDelta, stressDelta);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: gameController,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background Image: assets/bedroom02_day.png for odd turns, assets/bedroom02_evening.png for even turns
              Positioned.fill(
                child: Image.asset(
                  gameController.turnCurrent.isOdd
                      ? 'assets/bedroom02_day.png'
                      : 'assets/bedroom02_evening.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFF8F7),
                          Color(0xFFFFE9E7),
                          Color(0xFFF4C2C2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const ParticleOverlay(particleCount: 15),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Top HUD Bar
                      _buildTopHUD(),

                      const Spacer(),

                      // Action Buttons Grid (2x2) at the very bottom
                      _buildActionGrid(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopHUD() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: DuchessTheme.glassGoldBorder(borderRadius: 14),
      child: Column(
        children: [
          // Day Counter Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: DuchessTheme.goldDim,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${gameController.dayRemaining} DAYS REMAINING',
                        style: DuchessTheme.labelCaps(
                          color: DuchessTheme.primary,
                        ),
                      ),
                      Text(
                        'Day ${8 - gameController.dayRemaining} • Turn ${gameController.turnCurrent}/14',
                        style: DuchessTheme.bodyMain(
                          color: DuchessTheme.onSurface,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: DuchessTheme.primary),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                ),
              ),
            ],
          ),

          const Divider(height: 20, color: DuchessTheme.goldAccent),

          // Stats Meters Stack
          Row(
            children: [
              Expanded(child: _buildStatMeter('Poise', gameController.poise, 100, DuchessTheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatMeter('Knowledge', gameController.knowledge, 100, DuchessTheme.tertiary)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatMeter('Stress', gameController.stress, 100, DuchessTheme.error)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatMeter(String label, int value, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: DuchessTheme.labelCaps(color: DuchessTheme.onSurfaceVariant),
            ),
            Text(
              '$value/$max',
              style: DuchessTheme.labelCaps(color: color).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / max,
            minHeight: 8,
            backgroundColor: DuchessTheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: 'Etiquette',
                icon: Icons.auto_awesome_outlined,
                color: DuchessTheme.primary,
                onTap: () => _executeActivity('Etiquette', 15, 0, 10),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: 'Study',
                icon: Icons.auto_stories_outlined,
                color: DuchessTheme.primary,
                onTap: () => _executeActivity('Study', 0, 15, 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                label: 'Masterclass',
                icon: Icons.school_outlined,
                color: DuchessTheme.primary,
                onTap: () => _executeActivity('Masterclass', 10, 10, 10),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                label: 'Rest',
                icon: Icons.king_bed_outlined,
                color: const Color(0xFF4A5D4E),
                onTap: () => _executeActivity('Rest', 0, 0, -10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5C7C8),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: DuchessTheme.goldAccent,
              width: 2.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: color,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.sourceSerif4(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
