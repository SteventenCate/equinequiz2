Elite Paardentraining Quiz App
Welkom bij de Elite Paardentraining Quiz App! Deze Flutter-applicatie is ontworpen om paardentrainingsenthousiastelingen te helpen hun kennis te testen en bij te houden, en om trainingssessies te simuleren. De app bevat een interactieve quiz, een ranglijst, instellingen voor personalisatie en een simpele trainingsopnamefunctie.

Inhoudsopgave
- Features

- Installatie

- Gebruik

- App Structuur

- Theming

- Bijdragen

- Licentie

Features

Home Tab: Start en stop een gesimuleerde trainingsopname. Na het stoppen van de opname worden er fictieve trainingsresultaten getoond.

Quiz Tab: Test je kennis over paardentraining met meerkeuzevragen. Verdiende XP wordt toegevoegd aan een ranglijst.

Ranglijst Tab: Bekijk de top X spelers op basis van hun verdiende XP.

Instellingen Tab: Schakel de Quiz-knop in of uit en beheer notificaties.

Aangepast Thema: Een uniek en oogvriendelijk kleurenschema, gericht op een 'elite' uitstraling.

Navigatie met Tabs: Eenvoudige navigatie tussen de verschillende secties via een BottomNavigationBar.

Installatie

Om deze applicatie lokaal te draaien, volg je de volgende stappen:

Vereisten

Flutter SDK geïnstalleerd (versie 3.x.x of hoger aanbevolen).

Een IDE zoals VS Code of Android Studio met de Flutter-plug-in.

Stappen

Kloon de repository:

git clone https://github.com/SteventenCate/equinequiz2
cd equinequiz2


Haal de afhankelijkheden op:

flutter pub get

Voer de app uit:

flutter run

Kies een emulator/apparaat (Android, iOS, Web, Desktop) om de app op te starten.

Gebruik

Home Tab: Druk op 'Start Opname' om een gesimuleerde training te beginnen. Druk nogmaals om te 'Stop Opname' en de trainingsresultaten te bekijken.

Quiz Tab: Selecteer de Quiz-tab in de navigatiebalk. Beantwoord de vragen door op de juiste optie te tikken. Na de laatste vraag wordt je gevraagd om je naam in te voeren en je score op de ranglijst op te slaan.

Ranglijst Tab: Ga naar de Ranglijst-tab om de scores van de quiz-spelers te zien.

Instellingen Tab: Beheer de zichtbaarheid van de Quiz-knop en schakel notificaties in of uit.

App Structuur

De applicatie is modulair opgebouwd met de volgende belangrijke componenten:

main.dart: Het opstartpunt van de applicatie. Definieert het hoofd MaterialApp en het thema.

HorseTrainingQuizApp: De hoofd StatelessWidget die het thema en de MainAppShell definieert.

MainAppShell: Een StatefulWidget die de BottomNavigationBar beheert en de IndexedStack gebruikt om de verschillende tab-navigators te renderen en hun staat te behouden.

TabNavigator: Een helper StatelessWidget die een Navigator voor elke tab inkapselt, zodat elke tab zijn eigen navigatiestack kan beheren.

HomeTab: De implementatie van de Home-pagina met de trainingsopnamefunctionaliteit.

TrainingResultsPage: Toont gesimuleerde trainingsgegevens na het beëindigen van een opname.

QuizPage: Bevat de quizlogica, inclusief het weergeven van vragen, het controleren van antwoorden en het tonen van resultaten.

LeaderboardPage: Toont de ranglijst van de quiz-scores.

SettingsPage: De pagina voor het beheren van app-instellingen.

Question: Een dataklasse om quizvragen te modelleren.

Theming

De app maakt gebruik van een aangepast kleurenschema dat is gedefinieerd in main.dart, met:

primaryColor: #00B0A1 (een groenblauw)

scaffoldBackgroundColor: #002B36 (donkerblauw/zwart)

backgroundColor voor navigatiebalk en kaarten: #003B3D

Tekstkleuren: Wit en lichtgrijs voor leesbaarheid.

Bijdragen

Voel je vrij om bij te dragen aan dit project! Je kunt issues openen voor bugs of functieverzoeken, of pull-requests indienen met verbeteringen.

Licentie

Dit project is gelicentieerd onder de MIT-licentie. Zie het LICENSE-bestand voor meer details.
