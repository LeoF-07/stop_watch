import 'package:flutter/material.dart';

import 'dart:async';

import 'package:stop_watch/records.dart';

import 'circle_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: Colors.black
      ),
      home: const MyHomePage(title: 'Stop Watch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int stopTime = 0;
  int time = 0;
  int secondi = 0;

  bool started = false;
  bool paused = false;

  GlobalKey<RecordsState> recordsStateKey = GlobalKey();

  StreamSubscription<int>? tickSubscription;

  @override
  void initState(){
    super.initState();
    startTick();
  }

  startTick(){
    Stream<int> tick = Stream.periodic(Duration(milliseconds: 10), (count) => count);
    tickSubscription = tick.listen((count) {
      time = count;
      if(!paused && (count + 1 - stopTime) % 100 == 0) {
        controllerSecondi.add(1);
      }
    });
  }

  StreamController controllerSecondi = StreamController();

  void start(){
    started = true;

    controllerSecondi = StreamController();

    controllerSecondi.stream.listen((count) {
      setState(() {
        if(started) secondi++;
      });
    });
  }

  void stop(){
    setState(() {
      started = false;
    });
    paused = true;
  }

  void reset(){
    setState(() {
      secondi = 0;
      stopTime = 0;
      time = 0;
      started = false;
      paused = false;

      recordsStateKey.currentState!.clearRecords();
    });

    tickSubscription!.cancel();
    startTick();
  }

  void pause(){
    stopTime = time;
    setState(() {
      paused = true;
      recordsStateKey.currentState?.addRecord(secondi);
    });
  }

  void resume(){
    setState(() {
      paused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int minuti = (this.secondi / 60).toInt();
    int secondi = this.secondi - minuti * 60;

    TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 70);


    ButtonStyle stylePrimaryButton = !started && !paused ?
      ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ) : (!started ?
        ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ) :
        ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        )
      );

    ButtonStyle styleSecondaryButton = !paused ?
    ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ) :
    ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white))
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CustomPaint(
                  size: Size(100, 100),
                  painter: CirclePainter(secondi, paused),
                )
              )
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 200),
                  child: Text("${minuti < 10 ? "0$minuti" : minuti} : ${secondi < 10 ? "0$secondi" : secondi}", style: textStyle),),
                Records(key: recordsStateKey),
              ]
            ),
            Positioned(
                right: 60,
                bottom: 100,
                child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Row(
                      children: [
                        started ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: !paused ? pause : resume,
                              style: styleSecondaryButton,
                              child: Text(!paused ? "Pause" : "Resume", style: TextStyle(color: Colors.black)),
                            )
                        ) : SizedBox(width: 0, height: 0),
                        ElevatedButton(
                          onPressed: !started && !paused ? start : (!started ? reset : stop),
                          style: stylePrimaryButton,
                          child: Text(!started && !paused ? "Start" : (!started ? "Reset" : "Stop"), style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    )
                )
            )
          ]
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
