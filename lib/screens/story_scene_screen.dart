import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import '../prologue_scripts.dart';

class StorySceneScreen extends StatefulWidget {
  final List<Map<String, String>>? customDialogues;
  final VoidCallback? onFinish;

  const StorySceneScreen({
    super.key,
    this.customDialogues,
    this.onFinish,
  });

  @override
  State<StorySceneScreen> createState() => _StorySceneScreenState();
}

class _StorySceneScreenState extends State<StorySceneScreen> {
  int _dialogueIndex = 0;

  late final List<Map<String, String>> _dialogues;

  @override
  void initState() {
    super.initState();
    if (widget.customDialogues != null && widget.customDialogues!.isNotEmpty) {
      _dialogues = widget.customDialogues!;
    } else {
      _dialogues = getPrologueDialogue();
    }
  }

  void _nextDialogue() {
    setState(() {
      if (_dialogueIndex < _dialogues.length - 1) {
        _dialogueIndex++;
      } else {
        if (widget.onFinish != null) {
          widget.onFinish!();
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDialogue = _dialogues[_dialogueIndex];

    final String? bgImage = currentDialogue['bgImage'];
    final String? characterImage = currentDialogue['characterImage'];

    return Scaffold(
      body: GestureDetector(
        onTap: _nextDialogue,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Image (Full Illustration)
            if (bgImage != null && bgImage.isNotEmpty)
              Image.asset(
                bgImage,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => _buildBgPlaceholder(),
              )
            else
              _buildBgPlaceholder(),

            const ParticleOverlay(particleCount: 20),

            // 2. Character Sprite (with changing expressions or Live2D assets)
            if (characterImage != null && characterImage.isNotEmpty)
              _buildCharacterWidget(characterImage)
            else
              const SizedBox.shrink(),


            // Top Header Action Bar
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: DuchessTheme.primary, size: 28),
                    onPressed: () {
                      if (widget.onFinish != null) {
                        widget.onFinish!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            ),

            // Visual Character Center Shadow / Silhouette
            if (characterImage == null || characterImage.isEmpty)
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.15,
                  child: Icon(
                    Icons.person,
                    size: 260,
                    color: DuchessTheme.primary.withValues(alpha: 0.4),
                  ),
                ),
              ),

            // Dialogue Box Container at Bottom
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Parchment Glass Dialogue Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                        decoration: BoxDecoration(
                          color: DuchessTheme.surfaceContainer.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: DuchessTheme.primary.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x337B5455),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              currentDialogue['text']!,
                              style: DuchessTheme.bodyMain(
                                color: DuchessTheme.onSurface,
                              ).copyWith(fontSize: 17),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Tap to continue',
                                  style: DuchessTheme.labelCaps(
                                    color: DuchessTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.play_arrow,
                                  color: DuchessTheme.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Floating Speaker Name Badge
                      Positioned(
                        top: -14,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: DuchessTheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: DuchessTheme.tertiary,
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x2A000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            currentDialogue['speaker']!,
                            style: DuchessTheme.labelCaps(
                              color: DuchessTheme.onSurface,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8EF),
            Color(0xFFFFE0E0),
            Color(0xFF7B5455),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          size: 120,
          color: Colors.white30,
        ),
      ),
    );
  }

  Widget _buildCharacterWidget(String path) {
    if (path.endsWith('.json')) {
      const String fallbackTexture = 'assets/TheCountess_v1/TheCountess_v1.4096/texture_00.png';
      return Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          fallbackTexture,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
