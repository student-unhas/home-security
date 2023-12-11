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

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // readData();
    return Scaffold(
      body: StreamBuilder(
          stream: dbRef.child("data").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data?.snapshot.value != null) {
              final jsonString = jsonEncode(snapshot.data!.snapshot.value);

              Map<String, dynamic> jsonMap = json.decode(jsonString);
              GasDataList gasDataList = GasDataList.fromJson(jsonMap);

              // gasDataList.data.forEach((key, gasData) {
              //   print("Key: $key");
              //   print("Gas Value: ${gasData.gasValue}");

              //   // Mengonversi timestamp menjadi DateTime
              //   DateTime dateTime =
              //       DateTime.fromMillisecondsSinceEpoch(gasData.tanggal);

              //   // Menggunakan intl untuk memformat tampilan tanggal dan waktu
              //   String formattedDateTime =
              //       DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
              //   print("Tanggal: $formattedDateTime");
              // });

              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xff1b61b9), Color(0xff1586f9)],
                            )),
                            child: Stack(
                              children: [
                                Image.asset(
                                  value == true
                                      ? "assets/on.png"
                                      : "assets/off.png",
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                                SafeArea(
                                    child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            const Text(
                                              "Moving Detector",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  height: 1,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Home Security",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(.5),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const Spacer(),
                                            Text(
                                              value == true
                                                  ? "Sensor On"
                                                  : "Sensor Off",
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Switch.adaptive(
                                              activeColor: Colors.amber,
                                              value: value,
                                              onChanged: (bool value) {
                                                onUpdate();
                                                writeData();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          )),
                      const Expanded(
                        flex: 3,
                        child: SizedBox(),
                        // child: ListView.builder(
                        //   itemCount: gasDataList.data.length,
                        //   itemBuilder: (context, index) {
                        //     String key =
                        //         gasDataList.data.keys.elementAt(index);

                        //     return CardLog(gasData: gasDataList.data[key]!);
                        //   },
                        // )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: SizedBox(),
                      ),
                      Expanded(
                          flex: 7,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            // padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Riwayat",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: gasDataList.data.length,
                                    padding: const EdgeInsets.all(15),
                                    itemBuilder: (context, index) {
                                      String key = gasDataList.data.keys
                                          .elementAt(index);

                                      return CardLog(
                                          gasData: gasDataList.data[key]!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
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
    dbRef.child("state").set({"switch": !value});
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
      decoration: BoxDecoration(
          boxShadow: const [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.2),
            //   spreadRadius: 1,
            //   blurRadius: 1,
            //   offset: const Offset(0, 0),
            // ),
          ],
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
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
          style: const TextStyle(color: Colors.black, fontSize: 12),
        )
      ]),
    );
  }
}
