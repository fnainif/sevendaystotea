import 'game_controller.dart';

List<Map<String, String>> getEpilogueDialogue(GameEnding ending) {
  final List<Map<String, String>> rawDialogues;
  switch (ending) {
    case GameEnding.perfectBelle:
      rawDialogues = [
        {
          'speaker': 'Lady Elara',
          'text': '"In all my years at court, I have never seen such flawless execution. The Queen was moved to tears!"',
          'characterImage': 'assets/sf2g_sensei_normaltalkb.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I hope I didn\'t ruin her majesty\'s makeup, my lady."',
          'characterImage': 'assets/sf2g_sensei_normalblush.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Nonsense! It was a triumph! I, of course, take full credit for your miraculous transformation."',
          'characterImage': 'assets/sf2g_sensei_normaltalkb.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"Of course. Though my wrists may never fully recover from the teapot drills."',
          'characterImage': 'assets/sf2g_sensei_normalblush.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"A small price to pay for eternal glory! You are the crown jewel of this season, and our house is secured forever!"',
          'characterImage': 'assets/sf2g_sensei_normaltalkb.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"(Sigh)... Does this mean I have to keep acting like this every day?"',
          'characterImage': 'assets/sf2g_sensei_normalblush.png',
        },
        {
          'speaker': 'System',
          'text': 'ENDING REACHED: The Perfect Belle. You have secured your place in high society... but you peaked too early and now have to maintain this impossible standard forever.',
        },
      ];
      break;
    case GameEnding.cleverIntellectual:
      rawDialogues = [
        {
          'speaker': 'Lady Elara',
          'text': '"Well... you certainly left an impression. A two-hour unprompted lecture on tea leaf fermentation was... unexpected."',
          'characterImage': 'assets/sf2g_sensei_ooo.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"The scholars seemed quite riveted, my lady! Did you see how fast they were taking notes?"',
          'characterImage': 'assets/sf2g_sensei_normal.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Yes, the scholars were obsessed. Half the court, however, was sound asleep. Including the Duke of York."',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"He was just resting his eyes to better visualize the fermentation process!"',
          'characterImage': 'assets/sf2g_sensei_normal.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Regardless... they are calling you the \'Savant of the Saucer\'. I suppose we shall have to rebrand our house as a refuge for eccentric geniuses."',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"Can we get comfortable chairs for the library, then?"',
          'characterImage': 'assets/sf2g_sensei_normal.png',
        },
        {
          'speaker': 'System',
          'text': 'ENDING REACHED: The Clever Intellectual. You bored half the court to sleep, but the scholars worship the ground you walk on.',
        },
      ];
      break;
    case GameEnding.socialDisaster:
      rawDialogues = [
        {
          'speaker': 'Lady Elara',
          'text': '"*Gasps* You poured the boiling Earl Grey directly onto the Duke of Wellington\'s trousers!"',
          'characterImage': 'assets/sf2g_sensei_ohno.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I-I thought he looked cold! And I did maintain eye contact while pouring, just as you taught me!"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Eye contact does not make up for third-degree burns! He is doing the jig of pain in the center of the royal salon!"',
          'characterImage': 'assets/sf2g_sensei_angrytalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"The silence in the room was... very dramatic. Does this mean I don\'t get a biscuit?"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"You will be lucky if you do not get the guillotine! Pack your things, we are fleeing to the turnip farm immediately!"',
          'characterImage': 'assets/sf2g_sensei_angrytalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I call the window seat on the carriage!"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'System',
          'text': 'ENDING REACHED: The Social Disaster. You were laughed out of the royal tea room, and your family is now in the turnip business.',
        },
      ];
      break;
    case GameEnding.meltdown:
      rawDialogues = [
        {
          'speaker': 'Lady-in-Training',
          'text': '"I CANNOT TAKE IT ANYMORE! THE TEA, THE ETIQUETTE, THE POSTURE! IT IS JUST LEAVES IN HOT WATER!"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Child, control yourself! Put down that expensive tin of Earl Grey immediately!"',
          'characterImage': 'assets/sf2g_sensei_angrytalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"*Throws the tin into the fireplace* I declare independence from this ridiculous porcelain prison!"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"*Speechless, holding a broken teacup* ...Guards? Anyone?"',
          'characterImage': 'assets/sf2g_sensei_angrytalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I am leaving! And I am taking the finest almond biscuits with me! Farewell, oppressors!"',
          'characterImage': 'assets/sf2g_sensei_angry.png',
        },
        {
          'speaker': 'System',
          'text': 'ENDING REACHED: The Meltdown. Your stress boiled over before the tea did. You threw a tantrum, stole the snacks, and lived happily ever after on your own terms.',
        },
      ];
      break;
    case GameEnding.neutral:
      rawDialogues = [
        {
          'speaker': 'Lady Elara',
          'text': '"Well. That was... aggressively adequate."',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I didn\'t spill anything! And I remembered my own name when introduced!"',
          'characterImage': 'assets/sf2g_sensei_upset.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"Indeed. You were so perfectly average that Lady Harrington asked me if you came with the furniture."',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"I consider that a stealth victory. I survived without a scandal!"',
          'characterImage': 'assets/sf2g_sensei_upset.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"You survived without making an impact whatsoever. Enjoy your peace while it lasts, child..."',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady Elara',
          'text': '"...Because starting tomorrow, we begin the terrifying, grueling 365-day training regimen for next year\'s season!"',
          'characterImage': 'assets/sf2g_sensei_normaltalk.png',
        },
        {
          'speaker': 'Lady-in-Training',
          'text': '"...Oh no."',
          'characterImage': 'assets/sf2g_sensei_upset.png',
        },
        {
          'speaker': 'System',
          'text': 'ENDING REACHED: A Neutral Path. You were fine. So fine it hurt. Now prepare for a whole year of even stricter training.',
        },
      ];
      break;
  }

  return rawDialogues.map((d) => {...d, 'bgImage': 'assets/interior_entrance_nightl2.png'}).toList();
}
