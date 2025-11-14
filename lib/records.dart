import 'package:flutter/material.dart';

class Records extends StatefulWidget {
  Records({required super.key});
  @override
  State<StatefulWidget> createState() => RecordsState();
}

class RecordsState extends State{
  List<Text> records = [];

  void clearRecords(){
    records.clear();
  }
  
  void addRecord(int sec){
    int minuti = (sec / 60).toInt();
    int secondi = sec - minuti * 60;
    records.add(Text("${minuti < 10 ? "0$minuti" : minuti}:${secondi < 10 ? "0$secondi" : secondi}", style: TextStyle(color: Colors.white)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: records,
    );
  }
  
}