import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/http_service.dart';


///新增处方
var theUrl = Global().BASE_url;

class PrescriptionAdd extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PrescriptionAddState();
  }

}

class _PrescriptionAddState extends State<PrescriptionAdd>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("处方新增"),
      ),
      body: Center(),
    );
  }

}