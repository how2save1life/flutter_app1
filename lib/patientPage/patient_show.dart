import 'dart:convert';

import 'package:flutterapp1/model/patient_list_model.dart';
import 'package:flutterapp1/patientPage/patient_add.dart';
import 'package:flutterapp1/patientPage/patient_info.dart';

import '../service/http_service.dart';
import 'package:flutter/material.dart';
import '../service/util.dart';

var theUrl = Global().BASE_url;

class Patients extends StatefulWidget {
  @override
  createState() => _PatientPageListState();
}

class _PatientPageListState extends State<Patients> {
  PatientListModel patientList = PatientListModel([]);
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPatients();
  }

  void getPatients() async {
    var url = theUrl + 'Patient/AllPatients';

    await request(url).then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //打印数据
      print('病人列表数据Json格式:::' + data.toString());

      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        patientList = PatientListModel.fromJson(data);
      });
    });
  }

  //列表项
  Widget _ListWidget(List newList, int index) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black12),
              )),
          //水平方向布局
          child: Card(
              child: Row(
            children: <Widget>[
              //返回图片

              _patientHead(newList, index),
              SizedBox(
                width: 10,
              ),
              //右侧使用垂直布局
              _patientInfomation(newList, index)
            ],
          ))),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new PatientInfo(
                  patientId: newList[index].patientId,
                ))).then((data) {
          getPatients();
        });
      },
    );
  }

  //名称
  Widget _patientInfomation(List newList, int index) {
    return Expanded(
      //padding: EdgeInsets.all(5.0),
      // width:double.infinity,
      child: Column(
        children: [
          ListTile(
            title: Text(newList[index].patientName,
                style: TextStyle(fontSize: 25)),
            subtitle: Text(
              (newList[index].patientSex == ''
                  ? ''
                  : (newList[index].patientSex == 'M' ? '男' : '女')),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              "手机号：" + newList[index].patientPhone,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  //图片
  Widget _patientHead(List newList, int index) {
    if (newList[index].patientHead != "") {
      return Container(
        width: 150,
        height: 150,
        child: Image.network(
          theUrl + newList[index].patientHead + "/1.jpg?" + randomSuffix(),
          fit: BoxFit.fitWidth,
        ),
      );
    } else
      return Container(
        width: 150,
        height: 150,
        child: Image.asset(
          "images/head/head.jpg",
          fit: BoxFit.fitWidth,
        ),
      );
  }

  Widget _buildList() {
    if (patientList.data.length > 0) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        //滚动控制器
        controller: scrollController,
        //列表长度
        itemCount: patientList.data.length,
        //列表项构造器
        itemBuilder: (context, index) {
          //列表项 传入列表数据及索引
          return _ListWidget(patientList.data, index);
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('病人信息'),
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new PatientAdd()))
              .then((data) {
            getPatients();
          });
        },
        child: new Icon(Icons.add),
        //elevation: 3.0,
        //highlightElevation: 2.0,
        //backgroundColor: Colors.red,        // 红色
      ),
    );
  }
}
