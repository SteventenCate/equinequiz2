import 'package:flutter/material.dart';

void main() {
  runApp(const HorseTrainingQuizApp());
}

// Hoofdklasse voor de quiz-app
class HorseTrainingQuizApp extends StatelessWidget {
  const HorseTrainingQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Paardentraining Quiz',
      theme: ThemeData(
        primaryColor: const Color(0xFF00B0A1), // Hoofdkleur van de app
        scaffoldBackgroundColor: const Color(0xFF002B36), // Achtergrondkleur van de schermen
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16), // Standaard tekstgrootte en kleur
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00B0A1), // Basis seed kleur voor het kleurenschema
          primary: const Color(0xFF00B0A1), // Primaire kleur
          secondary: const Color(0xFF007B83), // Secundaire kleur
          surface: const Color(0xFF002B36), // Achtergrondkleur voor oppervlakken (zoals kaarten, dialogen)
        ),
        useMaterial3: true, // Gebruik Material Design 3
      ),
      home: const MainAppShell(), // De hoofd-applicatieschil die de navigatie beheert
    );
  }
}

// MainAppShell beheert de BottomNavigationBar en de navigatoren van elke tab
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  // _currentTab representeert de conceptuele index van de geselecteerde tab:
  // 0: Home, 1: Quiz, 2: Ranglijst, 3: Instellingen
  int _currentTab = 0;
  bool _isRecording = false; // Status van de opnameknop (wordt nu in HomeTab beheerd)
  bool _showQuizButton = true; // Bepaalt of de Quiz-knop zichtbaar is
  bool _notificationsEnabled = true; // Bepaalt of notificaties zijn ingeschakeld

  // GlobalKey voor de Navigator van elke tab om de interne navigatiestack te beheren
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Index 0: Home Tab Navigator
    GlobalKey<NavigatorState>(), // Index 1: Quiz Tab Navigator
    GlobalKey<NavigatorState>(), // Index 2: Ranglijst Tab Navigator
    GlobalKey<NavigatorState>(), // Index 3: Instellingen Tab Navigator
  ];

  // Hulpfunctie om standaard ranglijstgegevens op te halen
  static List<Map<String, dynamic>> getDefaultLeaderboard() {
    return [
      {'name': 'Strix', 'xp': 50},
      {'name': 'Luna', 'xp': 30},
      {'name': 'Max', 'xp': 40},
      {'name': 'Bella', 'xp': 20},
      {'name': 'Charlie', 'xp': 25},
    ];
  }

  // Bouwt de lijst van navigatoren voor de IndexedStack
  List<Widget> _buildTabNavigators() {
    return [
      // Tab Index 0: Home Tab
      TabNavigator(
        navigatorKey: _navigatorKeys[0],
        rootWidget: const HomeTab(), // HomeTab is de root van deze navigator
      ),
      // Tab Index 1: Quiz Tab
      TabNavigator(
        navigatorKey: _navigatorKeys[1],
        rootWidget: const QuizPage(), // QuizPage is de root van deze navigator
      ),
      // Tab Index 2: Ranglijst Tab
      TabNavigator(
        navigatorKey: _navigatorKeys[2],
        rootWidget: LeaderboardPage(leaderboard: getDefaultLeaderboard()), // LeaderboardPage is de root van deze navigator
      ),
      // Tab Index 3: Instellingen Tab
      TabNavigator(
        navigatorKey: _navigatorKeys[3],
        rootWidget: SettingsPage(
          showQuizButton: _showQuizButton,
          notificationsEnabled: _notificationsEnabled,
          onToggleQuizButton: (value) {
            setState(() {
              _showQuizButton = value;
              // Als de Quiz-knop wordt verborgen en de huidige tab de Quiz-tab was,
              // schakel dan over naar de Home-tab om fouten te voorkomen.
              if (!value && _currentTab == 1) { // 1 is de conceptuele index voor Quiz
                _currentTab = 0; // Schakel over naar Home-tab
              }
            });
          },
          onToggleNotifications: (value) {
            setState(() {
              _notificationsEnabled = value;
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificaties ingeschakeld!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificaties uitgeschakeld!')),
                );
              }
            });
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    ];

    // Voeg de Quiz-knop alleen toe als _showQuizButton true is
    if (_showQuizButton) {
      bottomNavItems.add(const BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'));
    }
    bottomNavItems.add(const BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranglijst'));
    bottomNavItems.add(const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Instellingen'));

    return Scaffold(
      // Gebruik IndexedStack om de status van de verschillende tab-navigators te beheren
      body: IndexedStack(
        index: _currentTab,
        children: _buildTabNavigators(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF003B3D), // Achtergrondkleur van de navigatiebalk
        items: bottomNavItems, // De items die in de navigatiebalk worden getoond
        // Bereken de huidige index voor de BottomNavigationBar gebaseerd op _currentTab (conceptuele index)
        currentIndex: _currentTab == 0
            ? 0
            : (_showQuizButton ? _currentTab : _currentTab - 1),
        selectedItemColor: const Color(0xFF00B0A1), // Kleur van het geselecteerde item
        unselectedItemColor: Colors.white, // Kleur van ongeselecteerde items
        type: BottomNavigationBarType.fixed, // Belangrijk om alle labels te tonen
        onTap: (navBarIndex) {
          // Converteer de getapte index van bottomNavItems naar de conceptuele _currentTab index
          int tappedConceptualIndex = 0; // Standaard naar Home
          if (navBarIndex == 0) { // Home is altijd index 0
            tappedConceptualIndex = 0;
          } else if (_showQuizButton && navBarIndex == 1) { // Quiz (als zichtbaar)
            tappedConceptualIndex = 1;
          } else if ((_showQuizButton && navBarIndex == 2) || (!_showQuizButton && navBarIndex == 1)) { // Ranglijst
            tappedConceptualIndex = 2;
          } else if ((_showQuizButton && navBarIndex == 3) || (!_showQuizButton && navBarIndex == 2)) { // Instellingen
            tappedConceptualIndex = 3;
          }

          setState(() {
            _currentTab = tappedConceptualIndex; // Update de actieve tab
          });
        },
      ),
    );
  }
}

// Helper Widget om een Navigator voor elke tab te beheren
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.rootWidget,
  });

  final GlobalKey<NavigatorState> navigatorKey; // Unieke sleutel voor deze navigator
  final Widget rootWidget; // Het root-widget van deze tab

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey, // Koppel de GlobalKey aan deze Navigator
      onGenerateRoute: (routeSettings) {
        // Genereer de initiële route voor deze navigator
        return MaterialPageRoute(
          builder: (context) => rootWidget, // Toon het root-widget van de tab
          settings: routeSettings, // Geef de route-instellingen door
        );
      },
    );
  }
}

// HomeTab Widget (voorheen de inhoud van de HomePage)
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isRecording = false; // Status van de opnameknop

  // Schakelt de opnamestatus om
  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    if (!_isRecording) {
      // Als de opname is gestopt, navigeer naar de resultatenpagina
      // Dit navigeert binnen de Home-tab's Navigator
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TrainingResultsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)), // Titel van de Home-tab
        backgroundColor: const Color(0xFF003B3D),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleRecording, // Koppel de toggle functie aan de knop
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording // Kleur verandert met opnamestatus
                    ? Colors.red
                    : const Color(0xFF00B0A1),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                foregroundColor: Colors.black, // Zorgt ervoor dat tekst zichtbaar is
              ),
              child: Text(
                  _isRecording ? 'Stop Opname' : 'Start Opname', // Tekst verandert met opnamestatus
                  style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// Pagina om nep trainingsresultaten weer te geven
class TrainingResultsPage extends StatelessWidget {
  const TrainingResultsPage({super.key});

  // Genereer nep trainingsgegevens
  Map<String, String> _getFakeTrainingData() {
    return {
      'Duur': '35 minuten',
      'Gemiddelde Snelheid': '12.5 km/u',
      'Maximale Hartslag': '180 bpm',
      'Verbrande Calorieën': '450 kcal',
      'Afgelegde Afstand': '7.3 km',
      'Intensiteitsniveau': 'Middel-Hoog',
    };
  }

  @override
  Widget build(BuildContext context) {
    final trainingData = _getFakeTrainingData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingsresultaten',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003B3D),
        iconTheme: const IconThemeData(color: Colors.white), // Zorgt ervoor dat de terugknop wit is
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          color: const Color(0xFF003B3D),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trainingssamenvatting',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                ...trainingData.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Ga terug naar het vorige scherm in deze Navigator
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B0A1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      foregroundColor: Colors.black, // Zorgt ervoor dat tekst zichtbaar is
                    ),
                    child: const Text('Klaar', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Klasse voor een vraag in de quiz
class Question {
  final String question; // De vraag zelf
  final List<String> options; // Beschikbare opties
  final int correctIndex; // Index van het juiste antwoord
  final String explanation; // Uitleg voor het juiste antwoord

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// Lijst van vragen in de quiz
final List<Question> questions = [
  Question(
    question: 'Wat is de ideale hartslag van een paard in rust?',
    options: ['30-40 bpm', '60-80 bpm', '100-120 bpm'],
    correctIndex: 0,
    explanation: 'De ideale hartslag van een paard in rust ligt tussen de 30 en 40 bpm.',
  ),
  Question(
    question: 'Hoe lang moet een paard zich herstellen na intensieve training?',
    options: ['5 minuten', '15 minuten', '30 minuten'],
    correctIndex: 1,
    explanation: 'Een paard heeft meestal 15 minuten nodig om te herstellen na intensieve training.',
  ),
  Question(
    question: 'Waarom is het belangrijk om de hartslag te monitoren?',
    options: ['Voorkomt dorst', 'Voorkomt overtraining', 'Verhoogt de spronghoogte'],
    correctIndex: 1,
    explanation: 'Het monitoren van de hartslag voorkomt overtraining en helpt bij het welzijn van het paard.',
  ),
  Question(
    question: 'Wat is de optimale temperatuur voor een paard tijdens training?',
    options: ['20-25°C', '15-20°C', '10-15°C'],
    correctIndex: 0,
    explanation: 'De optimale temperatuur voor een paard tijdens training ligt tussen de 20 en 25 °C.',
  ),
  Question(
    question: 'Hoeveel water moet een paard dagelijks drinken?',
    options: ['5-10 liter', '10-15 liter', '15-20 liter'],
    correctIndex: 1,
    explanation: 'Een paard moet dagelijks tussen de 10 en 15 liter water drinken.',
  ),
];

// Hoofdpagina van de quiz (nu een root van een tab)
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuizPageState createState() => _QuizPageState();
}

// Statusklasse voor de quizpagina
class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0; // Huidige vraag index
  int score = 0; // Huidige score in XP
  List<Map<String, dynamic>> leaderboard = []; // Ranglijst van spelers
  List<String> feedback = []; // Feedback voor elke vraag

  // Methode om een vraag te beantwoorden
  void answerQuestion(int selected) {
    final correct = questions[currentQuestion].correctIndex == selected; // Controleer of het antwoord juist is
    if (correct) {
      score += 10; // 10 XP toekennen voor een juist antwoord
      feedback.add('Goed! ${questions[currentQuestion].explanation}'); // Feedback voor goed antwoord
    } else {
      feedback.add('Fout. ${questions[currentQuestion].explanation}'); // Feedback voor fout antwoord
    }

    // Ga naar de volgende vraag of toon resultaten
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion += 1; // Volgende vraag
      });
    } else {
      _showResultDialog(); // Toon resultaat dialoog
    }
  }

  // Methode om het resultaat dialoogvenster te tonen
  void _showResultDialog() {
    TextEditingController nameController = TextEditingController(); // Controller voor naaminvoer

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF003B3D), // Achtergrondkleur van de popup
        title: const Text('Resultaat', style: TextStyle(color: Colors.white)), // Titel van het dialoogvenster
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Je hebt $score XP verdiend!', style: const TextStyle(color: Colors.white)), // Toon verdiende XP
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Je naam voor de ranglijst',
                labelStyle: TextStyle(color: Colors.white),
              ), // Invoerveld voor naam
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Toon feedback voor elke vraag met ruimte tussen
            for (var msg in feedback) ...[
              Text(msg, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10), // Ruimte tussen feedback berichten
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Voeg de speler toe aan de ranglijst
                leaderboard.add({'name': nameController.text, 'xp': score});
                leaderboard.sort((a, b) => b['xp'].compareTo(a['xp'])); // Sorteer ranglijst op XP
                currentQuestion = 0; // Reset naar eerste vraag
                score = 0; // Reset score
                feedback.clear(); // Reset feedbacklijst
              });
              Navigator.of(context).pop(); // Sluit dialoogvenster

              // BELANGRIJKE WIJZIGING: Gebruik Navigator.push in plaats van pushReplacement
              // Dit zorgt ervoor dat QuizPage op de stack blijft binnen de Navigator van deze tab,
              // zodat LeaderboardPage er later naar terug kan gaan met pop().
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardPage(leaderboard: leaderboard)), // Ga naar ranglijst
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B0A1),
                foregroundColor: Colors.black), // Kleur van de knop
            child: const Text('Opslaan en bekijken'), // Knoptekst
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion]; // Huidige vraag

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elite Paardenquiz',
            style: TextStyle(color: Colors.white)), // Titel van de appbalk
        backgroundColor: const Color(0xFF003B3D),
        iconTheme:
        const IconThemeData(color: Colors.white), // Zorgt ervoor dat de terugknop wit is
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          color: const Color(0xFF003B3D), // Achtergrondkleur van de kaart
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)), // Kaartvorm
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(q.question,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)), // Vraag tekst
                const SizedBox(height: 24), // Ruimte tussen vraag en opties
                ...List.generate(q.options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                        const Size(double.infinity, 48), // Knopgrootte
                        backgroundColor:
                        const Color(0xFF00B0A1), // Kleur van de knop
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)), // Knopvorm
                        foregroundColor: Colors.black, // Zorgt ervoor dat tekst zichtbaar is
                      ),
                      onPressed: () =>
                          answerQuestion(index), // Beantwoord vraag bij druk
                      child: Text(q.options[index]), // Optie tekst
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Klasse voor de ranglijstpagina (nu een root van een tab)
class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard; // Ranglijstgegevens

  const LeaderboardPage({super.key, required this.leaderboard}); // Const constructor

  @override
  Widget build(BuildContext context) {
    // Controleer of er een vorige route is om naar terug te keren
    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 10',
            style: TextStyle(color: Colors.white)), // Titel van de ranglijstpagina
        backgroundColor: const Color(0xFF003B3D),
        iconTheme:
        const IconThemeData(color: Colors.white), // Zorgt ervoor dat de terugknop wit is
        // Voeg expliciet een terugknop toe als canPop true is
        leading: canPop
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // Ga terug naar de vorige route in deze Navigator
        )
            : null, // Geen terugknop als er geen route is om naar terug te gaan
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Top 10',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)), // Ranglijst titel
          ...leaderboard.map((entry) => ListTile(
            leading: const Icon(Icons.emoji_events,
                color: Colors.white), // Medaille icoon
            title: Text(entry['name'],
                style: const TextStyle(color: Colors.white)), // Naam van de speler
            trailing: Text('${entry['xp']} XP',
                style: const TextStyle(color: Colors.white)), // XP van de speler
          )),
        ],
      ),
    );
  }
}

// Instellingenpagina (nu een root van een tab)
class SettingsPage extends StatefulWidget {
  final bool showQuizButton;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleQuizButton;
  final ValueChanged<bool> onToggleNotifications;

  const SettingsPage({
    super.key,
    required this.showQuizButton,
    required this.notificationsEnabled,
    required this.onToggleQuizButton,
    required this.onToggleNotifications,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _showQuizButton;
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _showQuizButton = widget.showQuizButton;
    _notificationsEnabled = widget.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instellingen', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003B3D),
        iconTheme:
        const IconThemeData(color: Colors.white), // Zorgt ervoor dat de terugknop wit is
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Toon Quiz Knop',
                style: TextStyle(color: Colors.white)),
            value: _showQuizButton,
            onChanged: (bool value) {
              setState(() {
                _showQuizButton = value;
              });
              widget.onToggleQuizButton(value);
            },
            activeColor: const Color(0xFF00B0A1),
          ),
          SwitchListTile(
            title: const Text('Schakel Notificaties In',
                style: TextStyle(color: Colors.white)),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              widget.onToggleNotifications(value);
            },
            activeColor: const Color(0xFF00B0A1),
          ),
        ],
      ),
    );
  }
}