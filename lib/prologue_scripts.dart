List<Map<String, String>> getPrologueDialogue() {
  final dialogues = [
    {
      'speaker': 'Lady Elara',
      'text': '"The tea must be poured exactly as instructed, neither too fast nor too slow. One breath, one motion. Is it truly so difficult to remember?"',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady-in-Training',
      'text': '"Forgive me, Lady Elara. But this teapot feels suspiciously like a solid iron dumbbell."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady Elara',
      'text': '"It is fine porcelain, you heathen! If you spill one drop during the Grand Entrance, the Queen will personally see our entire house exiled to a remote turnip farm."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady-in-Training',
      'text': '"I hear turnips are quite resilient. Unlike my wrists."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady Elara',
      'text': '"Silence! We have exactly seven days to mold you from a clumsy peasant into a paragon of high society. Or at the very least, someone who does not weaponize hot beverages."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady-in-Training',
      'text': '"I promise to only weaponize the scones, my lady."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
    {
      'speaker': 'Lady Elara',
      'text': '"Heavens give me strength... Pick up the teapot. And try not to concuss anyone this time."',
      'characterImage': 'assets/TheCountess_v1/sad.motion3.json',
    },
  ];

  return dialogues.map((d) => {...d, 'bgImage': 'assets/inthallway2_day.png'}).toList();
}

