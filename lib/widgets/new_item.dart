import 'package:flutter/material.dart';

class NewItem extends StatefulWidget{
  NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD A NEW ITEM"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Text("The form"),
        ),
    );
  }
}