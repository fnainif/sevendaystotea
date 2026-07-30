import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameController = GameController();

enum GamePhase { active, epilogue, ending }

enum GameEnding {
  perfectBelle,
  cleverIntellectual,
  socialDisaster,
  meltdown,
  neutral,
}

class GameController extends ChangeNotifier {
  int poise = 0;
  int knowledge = 0;
  int stress = 0;
  
  int turnCurrent = 1; // 1 to 14 total turns
  GamePhase gamePhase = GamePhase.active;
  GameEnding? achievedEnding;
  Set<GameEnding> unlockedEndings = {};

  bool _hasSavedState = false;
  bool get hasSavedState => _hasSavedState;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('unlocked_endings') ?? [];
    unlockedEndings = saved
        .map((name) => GameEnding.values.firstWhere(
              (e) => e.name == name,
              orElse: () => GameEnding.neutral,
            ))
        .toSet();

    _hasSavedState = prefs.getBool('has_saved_state') ?? false;
    if (_hasSavedState) {
      poise = prefs.getInt('saved_poise') ?? 0;
      knowledge = prefs.getInt('saved_knowledge') ?? 0;
      stress = prefs.getInt('saved_stress') ?? 0;
      turnCurrent = prefs.getInt('saved_turn') ?? 1;
      int phaseIndex = prefs.getInt('saved_phase') ?? 0;
      if (phaseIndex >= 0 && phaseIndex < GamePhase.values.length) {
        gamePhase = GamePhase.values[phaseIndex];
      }
    }
  }

  Future<void> _saveUnlockedEndings() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = unlockedEndings.map((e) => e.name).toList();
    await prefs.setStringList('unlocked_endings', saved);
  }

  Future<void> saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_saved_state', true);
    await prefs.setInt('saved_poise', poise);
    await prefs.setInt('saved_knowledge', knowledge);
    await prefs.setInt('saved_stress', stress);
    await prefs.setInt('saved_turn', turnCurrent);
    await prefs.setInt('saved_phase', gamePhase.index);
    _hasSavedState = true;
    notifyListeners();
  }

  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_saved_state', false);
    _hasSavedState = false;
    notifyListeners();
  }

  int get dayRemaining => 7 - ((turnCurrent - 1) ~/ 2);

  void reset() {
    poise = 0;
    knowledge = 0;
    stress = 0;
    turnCurrent = 1;
    gamePhase = GamePhase.active;
    achievedEnding = null;
    // Don't notify here to avoid duplicate triggers during init, 
    // or notify if needed, but it's safe.
  }

  void startNewGame() {
    reset();
    clearGameState();
  }

  void executeActivity(int poiseDelta, int knowledgeDelta, int stressDelta) {
    if (gamePhase != GamePhase.active) return;

    poise = (poise + poiseDelta).clamp(0, 100);
    knowledge = (knowledge + knowledgeDelta).clamp(0, 100);
    stress = (stress + stressDelta).clamp(0, 100);
    
    if (stress >= 100) {
      _triggerEpilogue();
      return;
    }

    if (turnCurrent >= 14) {
      _triggerEpilogue();
    } else {
      turnCurrent++;
      // Save game state at the end of each day (every 2 turns)
      if ((turnCurrent - 1) % 2 == 0) {
        saveGameState();
      }
    }
    notifyListeners();
  }

  GameEnding evaluateEnding() {
    if (stress >= 100) return GameEnding.meltdown;
    if (poise >= 70 && knowledge >= 70 && stress < 40) return GameEnding.perfectBelle;
    if (knowledge >= 80 && poise < 50 && stress < 40) return GameEnding.cleverIntellectual;
    if (poise < 40 && knowledge < 40) return GameEnding.socialDisaster;
    return GameEnding.neutral;
  }

  void _triggerEpilogue() {
    achievedEnding = evaluateEnding();
    if (achievedEnding != null) {
      unlockedEndings.add(achievedEnding!);
      _saveUnlockedEndings();
    }
    gamePhase = GamePhase.epilogue;
    clearGameState();
  }

  void finishEpilogue() {
    gamePhase = GamePhase.ending;
    notifyListeners();
  }
}
