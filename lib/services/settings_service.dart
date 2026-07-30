import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService instance = SettingsService._internal();

  SettingsService._internal();

  late SharedPreferences _prefs;

  bool _masterVolume = true;
  bool _musicVolume = true;
  bool _fullscreen = false;
  bool _hapticFeedback = true;
  bool _batterySaver = false;
  bool _windowedBorderless = false;

  bool get masterVolume => _masterVolume;
  bool get musicVolume => _musicVolume;
  bool get fullscreen => _fullscreen;
  bool get hapticFeedback => _hapticFeedback;
  bool get batterySaver => _batterySaver;
  bool get windowedBorderless => _windowedBorderless;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    _masterVolume = _prefs.getBool('masterVolume') ?? true;
    _musicVolume = _prefs.getBool('musicVolume') ?? true;
    _fullscreen = _prefs.getBool('fullscreen') ?? false;
    _hapticFeedback = _prefs.getBool('hapticFeedback') ?? true;
    _batterySaver = _prefs.getBool('batterySaver') ?? false;
    _windowedBorderless = _prefs.getBool('windowedBorderless') ?? false;

    // Apply window manager settings if on desktop
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      await _applyWindowSettings();
    }
  }

  Future<void> setMasterVolume(bool value) async {
    _masterVolume = value;
    await _prefs.setBool('masterVolume', value);
    notifyListeners();
  }

  Future<void> setMusicVolume(bool value) async {
    _musicVolume = value;
    await _prefs.setBool('musicVolume', value);
    notifyListeners();
  }

  Future<void> setFullscreen(bool value) async {
    _fullscreen = value;
    await _prefs.setBool('fullscreen', value);
    notifyListeners();
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      await _applyWindowSettings();
    }
  }
  
  Future<void> setWindowedBorderless(bool value) async {
    _windowedBorderless = value;
    await _prefs.setBool('windowedBorderless', value);
    notifyListeners();
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      await _applyWindowSettings();
    }
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    await _prefs.setBool('hapticFeedback', value);
    notifyListeners();
  }

  Future<void> setBatterySaver(bool value) async {
    _batterySaver = value;
    await _prefs.setBool('batterySaver', value);
    notifyListeners();
  }

  Future<void> _applyWindowSettings() async {
    await windowManager.setFullScreen(_fullscreen);
    if (_windowedBorderless) {
      await windowManager.setAsFrameless();
    } else {
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    }
  }
}
