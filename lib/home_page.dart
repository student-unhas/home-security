import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer? _player;
  bool value = false;

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

  final dbRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    // readData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Scurity"),
      ),
      body: StreamBuilder(
          stream: dbRef.child("data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data?.snapshot.value != null) {
              final jsonString = jsonEncode(snapshot.data!.snapshot.value);

              Map<String, dynamic> jsonMap = json.decode(jsonString);
              GasDataList gasDataList = GasDataList.fromJson(jsonMap);

              gasDataList.data.forEach((key, gasData) {
                print("Key: $key");
                print("Gas Value: ${gasData.gasValue}");

                // Mengonversi timestamp menjadi DateTime
                DateTime dateTime =
                    DateTime.fromMillisecondsSinceEpoch(gasData.tanggal);

                // Menggunakan intl untuk memformat tampilan tanggal dan waktu
                String formattedDateTime =
                    DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                print("Tanggal: $formattedDateTime");
              });

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: _play, child: const Text('Play')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: _stopSound,
                      child: const Text('Stop'),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: gasDataList.data.length,
                    itemBuilder: (context, index) {
                      String key = gasDataList.data.keys.elementAt(index);

                      return CardLog(gasData: gasDataList.data[key]!);
                    },
                  )),
                ],
              );
            } else {
              return const Text("Kosong");
            }
          }),
    );
  }

  Future<void> readData() async {
    dbRef.child("data").once().then((DatabaseEvent value) {
      // log(value.snapshot.value.toString());
    });
  }

  Future<void> writeData() async {
    dbRef.child("lightState").set({"switch": !value});
  }
}

class GasData {
  int gasValue;
  int tanggal;

  GasData({
    required this.gasValue,
    required this.tanggal,
  });

  factory GasData.fromJson(Map<String, dynamic> json) {
    return GasData(
      gasValue: json['gasValue'] ?? 0,
      tanggal: json['tanggal'] ?? 0,
    );
  }
}

class GasDataList {
  Map<String, GasData> data;

  GasDataList({required this.data});

  factory GasDataList.fromJson(Map<String, dynamic> json) {
    Map<String, GasData> gasDataMap = {};
    json.forEach((key, value) {
      gasDataMap[key] = GasData.fromJson(value);
    });
    return GasDataList(data: gasDataMap);
  }
}

class CardLog extends StatelessWidget {
  final GasData gasData;
  const CardLog({super.key, required this.gasData});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(gasData.tanggal);

    // Menggunakan intl untuk memformat tampilan tanggal dan waktu
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
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
      child: Row(children: [
        const Expanded(
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
          formattedDateTime,
          style: const TextStyle(color: Colors.black),
        )
      ]),
    );
  }
}
