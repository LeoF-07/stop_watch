import 'package:flutter/material.dart';

import 'dart:async';

import 'package:stop_watch/records.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

    TextStyle textStyle = TextStyle(color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text("${minuti < 10 ? "0$minuti" : minuti}:${secondi < 10 ? "0$secondi" : secondi}", style: textStyle),
            ),
            Records(key: recordsStateKey),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: !started && !paused ? start : (!started ? reset : stop),
                    child: Text(!started && !paused ? "Start" : (!started ? "Reset" : "Stop"), style: TextStyle(color: Colors.black)),
                  ),
                  started ? ElevatedButton(
                    onPressed: !paused ? pause : resume,
                    child: Text(!paused ? "Pause" : "Resume", style: TextStyle(color: Colors.black)),
                  ) : SizedBox(width: 0, height: 0)
                ],
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
