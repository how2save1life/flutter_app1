import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/patient_list_model.dart';
import 'package:image_picker/image_picker.dart';
import '../service/http_service.dart';


///新增
var theUrl = Global().BASE_url; //"http://10.0.2.2:8080/";

class PatientAdd extends StatefulWidget {
  @override
  createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {
  final myController = TextEditingController();

  var patientName = new TextEditingController();
  var patientAddr = new TextEditingController();
  var patientPhone = new TextEditingController();
  var patientBirthday="";
  var patientSex='M';
  var _headPath;
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('zh'), // 强制显示中文 如果报错就删除,跟随系统语言显示
        context: context,
        initialDate: selectedDate, //初始值
        firstDate: DateTime(1900, 1), //开始日期
        lastDate: DateTime(2050)); //结束日期
    if (picked != null && picked != selectedDate)
      setState(() {
        patientBirthday=picked.toString();//.split(' ')[0];
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
  }

/*图片控件*/
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Container(
        width: 150,
        height: 150,
        child: Image.asset(
          "images/head/head.jpg",
          fit: BoxFit.fitWidth,
        ),
      );
    } else {
      return Container(
        width: 150,
        height: 150,
        child: Image.file(
          imgPath,
        ),
      );
    }
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _headPath = image;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _headPath = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> infoKey = GlobalKey<FormState>();
    void _saveHead(String patientId, File file) async {
      var dir = file.path;
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(dir),
        "patientId": patientId,
      });
      await requestPost(theUrl + 'Patient/PatientHead', formData: data).then((value) {
        print(value);
      });
    }

    void _savePatient() async {
      var infoForm = infoKey.currentState;
      if (infoForm.validate()) {
        infoForm.save();
        // print(infoForm);
        print(patientName.value);
        print(patientSex);
        print(patientBirthday);
        var data = PatientModel(
            "", patientName.text, "",patientSex, patientAddr.text,patientAddr.text,patientBirthday);
        await requestPost(theUrl + 'Patient/SavePatient', formData: data.toJson())
            .then((value) {
          print("succ");
          print(value);
          if (value.toString() != '') {
            _saveHead(value.toString(), _headPath);
            Navigator.of(context).pop("");
          }
        });
      }
    }

    return Scaffold(
      appBar: new AppBar(
        title: Text("病人新增"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: infoKey,
            child: Column(
              children: [
                _ImageView(_headPath),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: RaisedButton(
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: "手机拍照 "),
                                WidgetSpan(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ]),
                            ),
                            padding: EdgeInsets.all(15.0),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: _takePhoto,
                          ))
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: _openGallery,
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: "相册照片 "),
                                WidgetSpan(
                                  child: Icon(Icons.photo_library),
                                ),
                              ]),
                            ),
                            padding: EdgeInsets.all(15.0),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    )),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '姓名',
                  ),
                  controller: patientName,
                  onSaved: (value) {
                    patientName.text = value;
                  },
                  validator: (val) {
                    return val.length <= 0 ? "请输入姓名" : null;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '手机号',
                  ),
                  controller: patientPhone,
                  onSaved: (value) {
                    patientPhone.text = value;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '联系地址',
                  ),
                  controller: patientAddr,
                  onSaved: (value) {
                    patientAddr.text = value;
                  },
                ),
                Row(
                  children: [
                    Text("性别："),
                    Row(
                      ///包裹子布局
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          ///此单选框绑定的值 必选参数
                          value: 'M',

                          ///当前组中这选定的值  必选参数
                          groupValue: patientSex,

                          ///点击状态改变时的回调 必选参数
                          onChanged: (v) {
                            setState(() {
                              patientSex = v;
                            });
                          },
                        ),
                        Text("男")
                      ],
                    ),
                    Row(
                      ///包裹子布局
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          ///此单选框绑定的值 必选参数
                          value: 'F',

                          ///当前组中这选定的值  必选参数
                          groupValue: patientSex,

                          ///点击状态改变时的回调 必选参数
                          onChanged: (v) {
                            setState(() {
                              patientSex = v;
                            });
                          },
                        ),
                        Text("女")
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("出生日期："),
                    Expanded(
                      child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0].split('-')[0]+"年"+
                              "${selectedDate.toLocal()}".split(' ')[0].split('-')[1]+"月"+
                              "${selectedDate.toLocal()}".split(' ')[0].split('-')[2]+"日"),

                    ),
                    RaisedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('选择日期'),
                    )
                  ],
                ),


                // 上传按钮
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(15.0),
                          child: Text("上传"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            _savePatient();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
