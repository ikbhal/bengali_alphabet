import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'alphabets.dart';
import 'dart:math';

void main() {
  runApp(TeluguAlphabetPlayer());
}

class TeluguAlphabetPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telugu Alphabet Player',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AlphabetPlayerScreen(),
    );
  }
}

class AlphabetPlayerScreen extends StatefulWidget {
  @override
  _AlphabetPlayerScreenState createState() => _AlphabetPlayerScreenState();
}

class _AlphabetPlayerScreenState extends State<AlphabetPlayerScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String currentAlphabet = '';
  bool isPlaying = false;
  int repeatCount = 10;
  List<String> alphabets = Alphabets.alphabets;

  // final List<String> startAlphabets = List.from(Alphabets.alphabets);
  // final List<String> endAlphabets = List.from(Alphabets.alphabets);
  String startAlphabet = Alphabets.alphabets.first;
  String endAlphabet = Alphabets.alphabets.last;

  List<DropdownMenuItem<String>> getAlphabetDropdownItems(
      List<String> alphabets) {
    return alphabets
        .map((alphabet) => DropdownMenuItem<String>(
              value: alphabet,
              child: Text(alphabet),
            ))
        .toList();
  }

  List<DropdownMenuItem<int>> getRepeatCountDropdownItems() {
    return List.generate(100, (index) {
      final count = index + 1;
      return DropdownMenuItem<int>(
        value: count,
        child: Text(count.toString()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    currentAlphabet = '';
    repeatCount = 1;
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void playAlphabets() async {
    setState(() {
      isPlaying = true;
    });

    int startAlphabetIndex = Alphabets.alphabets.indexOf(startAlphabet);
    int endAlphabetIndex = Alphabets.alphabets.indexOf(endAlphabet);

    for (int i = 0; i < repeatCount; i++) {
      // find the position
      for (int index = startAlphabetIndex; index <= endAlphabetIndex; index++) {
        if (!isPlaying) break;

        final alphabet = Alphabets.alphabets[index];

        setState(() {
          currentAlphabet = alphabet;
        });

        await flutterTts.setLanguage('bn'); // Set language to Bengali
        await flutterTts.speak(alphabet);

        await Future.delayed(Duration(seconds: 1));
      }
    }

    setState(() {
      isPlaying = false;
      currentAlphabet = '';
    });
  }

  void pauseAlphabets() {
    setState(() {
      isPlaying = false;
    });
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bengali Alphabet Help'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('1. Select Start Alphabet.'),
              Text('2. Select End Alphabet.'),
              Text('3. Select Repeat Count.'),
              Text('4. Click Play Button to Play.'),
              Text('5. Click Stop button to stop'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bengali Alphabet Player'),
        actions: [
          IconButton(
            onPressed: () {
              showHelpDialog(context);
            },
            icon: Icon(Icons.help),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: startAlphabet,
              items: getAlphabetDropdownItems(alphabets),
              onChanged: (selectedAlphabet) {
                setState(() {
                  startAlphabet = selectedAlphabet!;
                });
              },
              hint: Text('Start Alphabet'),
            ),
            DropdownButton<String>(
              value: endAlphabet,
              items: getAlphabetDropdownItems(alphabets),
              onChanged: (selectedAlphabet) {
                setState(() {
                  endAlphabet = selectedAlphabet!;
                });
              },
              hint: Text('End Alphabet'),
            ),
            DropdownButton<int>(
              value: repeatCount,
              items: getRepeatCountDropdownItems(),
              onChanged: (selectedCount) {
                setState(() {
                  repeatCount = selectedCount!;
                });
              },
              hint: Text('Repeat Count'),
            ),
            SizedBox(height: 20),
            Text(
              '$currentAlphabet',
              style: TextStyle(
                  fontSize: 100,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isPlaying ? pauseAlphabets : playAlphabets,
                  child: Text(isPlaying ? 'Pause' : 'Play'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    pauseAlphabets();
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
