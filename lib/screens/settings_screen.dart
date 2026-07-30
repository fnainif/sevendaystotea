import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../widgets/particle_overlay.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
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
                        'SETTINGS',
                        style: DuchessTheme.displayTitle(color: DuchessTheme.primary),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    decoration: DuchessTheme.glassGoldBorder(borderRadius: 20),
                    child: ListenableBuilder(
                      listenable: SettingsService.instance,
                      builder: (context, _) {
                        final settings = SettingsService.instance;
                        return ListView(
                          padding: const EdgeInsets.all(24.0),
                          children: [
                            _buildSectionTitle('General'),
                            _buildSwitch(
                              title: 'Master Volume',
                              value: settings.masterVolume,
                              onChanged: (val) => settings.setMasterVolume(val),
                            ),
                            _buildSwitch(
                              title: 'Music Volume',
                              value: settings.musicVolume,
                              onChanged: (val) => settings.setMusicVolume(val),
                            ),
                            
                            if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) ...[
                              const SizedBox(height: 24),
                              _buildSectionTitle('Desktop Specific'),
                              _buildSwitch(
                                title: 'Fullscreen Mode',
                                value: settings.fullscreen,
                                onChanged: (val) => settings.setFullscreen(val),
                              ),
                              _buildSwitch(
                                title: 'Windowed Borderless',
                                value: settings.windowedBorderless,
                                onChanged: (val) => settings.setWindowedBorderless(val),
                              ),
                            ],

                            if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
                              const SizedBox(height: 24),
                              _buildSectionTitle('Mobile Specific'),
                              _buildSwitch(
                                title: 'Haptic Feedback',
                                value: settings.hapticFeedback,
                                onChanged: (val) {
                                  settings.setHapticFeedback(val);
                                  if (val) HapticFeedback.vibrate();
                                },
                              ),
                              _buildSwitch(
                                title: 'Battery Saver Mode',
                                value: settings.batterySaver,
                                onChanged: (val) => settings.setBatterySaver(val),
                              ),
                            ],
                          ],
                        );
                      }
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: DuchessTheme.headlineLg(color: DuchessTheme.primary),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: DuchessTheme.bodyMain(color: DuchessTheme.onSurface),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: DuchessTheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
