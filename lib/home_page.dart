import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer? _player;

  @override
  void dispose() {
    _player?.dispose();

    super.dispose();
  }

  void _play() {
    _player?.dispose();
    final player = _player = AudioPlayer();
    player.play(AssetSource('sound.mp3'));
  }

  void _stopSound() {
    _player?.dispose();
    final player = _player = AudioPlayer();
    player.stop();
  }

  final player = AudioPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Scurity"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child:
                  ElevatedButton(onPressed: _play, child: const Text('Play')),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: _stopSound,
                child: const Text('Stop'),
              ),
            ),
            const CardLog(),
            const CardLog(),
            const CardLog(),
            const CardLog(),
            const CardLog(),
          ],
        ),
      ),
    );
  }
}

class CardLog extends StatelessWidget {
  const CardLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 0),
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: const Row(children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gerakan terdeteksi",
              style: TextStyle(color: Colors.black),
            )
          ],
        )),
        Text(
          "label",
          style: TextStyle(color: Colors.black),
        )
      ]),
    );
  }
}
