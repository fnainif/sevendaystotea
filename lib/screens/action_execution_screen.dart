import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';

class ActionExecutionScreen extends StatefulWidget {
  final String activityName;
  final int poiseDelta;
  final int knowledgeDelta;
  final int stressDelta;
  final VoidCallback onComplete;

  const ActionExecutionScreen({
    super.key,
    required this.activityName,
    required this.poiseDelta,
    required this.knowledgeDelta,
    required this.stressDelta,
    required this.onComplete,
  });

  @override
  State<ActionExecutionScreen> createState() => _ActionExecutionScreenState();
}

class _ActionExecutionScreenState extends State<ActionExecutionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isFinished = false;
  bool _wasCompleted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward().then((_) {
        if (mounted) {
          setState(() {
            _isFinished = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _finishAndReturn() {
    if (!_isFinished) return;
    if (!_wasCompleted) {
      _wasCompleted = true;
      Navigator.pop(context);
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isFinished,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          if (!_wasCompleted && _isFinished) {
            _wasCompleted = true;
            widget.onComplete();
          }
          return;
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _finishAndReturn,
        child: Scaffold(
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Animation Placeholder taking 3/4 of screen height
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: DuchessTheme.surfaceContainerHigh.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: DuchessTheme.goldAccent.withValues(alpha: 0.5), width: 2),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.animation,
                                  size: 64,
                                  color: DuchessTheme.primary.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Animation Placeholder',
                                  style: DuchessTheme.labelCaps(color: DuchessTheme.primary.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Details section taking 1/4 of screen height
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                          decoration: DuchessTheme.glassGoldBorder(borderRadius: 20),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _isFinished ? Icons.task_alt : Icons.auto_awesome,
                                        size: 24,
                                        color: DuchessTheme.goldAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.activityName.toUpperCase(),
                                        style: DuchessTheme.labelCaps(color: DuchessTheme.primary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getActivityDescription(widget.activityName),
                                    style: DuchessTheme.bodyMain(color: DuchessTheme.onSurfaceVariant),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  if (!_isFinished) ...[
                                    SizedBox(
                                      width: 240,
                                      child: AnimatedBuilder(
                                        animation: _progressController,
                                        builder: (context, child) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: _progressController.value,
                                              minHeight: 10,
                                              backgroundColor: DuchessTheme.surfaceContainerHigh,
                                              valueColor: const AlwaysStoppedAnimation<Color>(
                                                DuchessTheme.goldDim,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        if (widget.poiseDelta != 0)
                                          _buildStatChip(
                                            label: '${widget.poiseDelta > 0 ? "+" : ""}${widget.poiseDelta} Poise',
                                            color: DuchessTheme.primary,
                                          ),
                                        if (widget.knowledgeDelta != 0)
                                          _buildStatChip(
                                            label: '${widget.knowledgeDelta > 0 ? "+" : ""}${widget.knowledgeDelta} Knowledge',
                                            color: DuchessTheme.tertiary,
                                          ),
                                        if (widget.stressDelta != 0)
                                          _buildStatChip(
                                            label: '${widget.stressDelta > 0 ? "+" : ""}${widget.stressDelta} Stress',
                                            color: widget.stressDelta > 0
                                                ? DuchessTheme.error
                                                : DuchessTheme.secondary,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap anywhere to return',
                                      style: DuchessTheme.labelCaps(
                                        color: DuchessTheme.primary.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getActivityDescription(String activityName) {
    switch (activityName.toLowerCase()) {
      case 'etiquette':
        return 'Practicing grace and proper manners.';
      case 'study':
        return 'Reading books and expanding knowledge.';
      case 'masterclass':
        return 'Attending a specialized masterclass to hone skills.';
      case 'rest':
        return 'Taking a peaceful break to relieve stress.';
      default:
        return 'Engaging in activity...';
    }
  }

  Widget _buildStatChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: DuchessTheme.labelCaps(color: color).copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
