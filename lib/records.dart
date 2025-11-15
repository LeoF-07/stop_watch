import 'package:flutter/material.dart';

class Records extends StatefulWidget {
  const Records({required super.key});
  @override
  State<StatefulWidget> createState() => RecordsState();
}

class RecordsState extends State{
  List<Widget> records = [];

  void clearRecords(){
    records.clear();
  }
  
  void addRecord(int sec){
    int minuti = (sec / 60).toInt();
    int secondi = sec - minuti * 60;
    setState(() {
      records.add(Padding(padding: EdgeInsets.only(bottom: 5), child: (Text("${minuti < 10 ? "0$minuti" : minuti}:${secondi < 10 ? "0$secondi" : secondi}", style: TextStyle(color: Colors.white, fontSize: 20)))));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(bottom: 15), child: Text("Records", style: TextStyle(color: Colors.white, fontSize: 20))),
        SizedBox(
          height: 200,
          child: SingleChildScrollView(
            controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: records,
              )
          )
        )
      ]
    );
  }
  
}