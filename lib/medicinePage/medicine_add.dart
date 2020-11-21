import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterapp1/model/medicine_list_model.dart';
import 'package:flutterapp1/service/http_service.dart';

var theUrl = "http://10.0.2.2:8080/";

class MedicineAdd extends StatefulWidget {
  @override
  createState() => _MedicineAddState();
}

class _MedicineAddState extends State<MedicineAdd> {
  final myController = TextEditingController();
  String MedicineName;
  String MedicineName1;
  String MedicineName2;
  var _imgPath;

/*图片控件*/
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text("请选择图片或拍照"),
      );
    } else {
      return Image.file(
        imgPath,
      );
    }
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> infoKey = GlobalKey<FormState>();
    void _savePic(String medicineId, File file) async {
      var dir = file.path;
      // ByteData byteData = await _imgPath.getByteData();
      // List<int> imageData = byteData.buffer.asUint8List();
      //var name = _imgPath.substring(_imgPath.lastIndexOf("/") + 1, _imgPath.length);
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(dir),
        "medicineId": medicineId,
      });
      await requestPost(theUrl + 'Meds/MedPic', formData: data).then((value) {
        print(value);
      });
    }

    void _saveMedicine() async {
      var infoForm = infoKey.currentState;
      if (infoForm.validate()) {
        infoForm.save();
        print(infoForm);
        print(MedicineName);
        print(MedicineName1);
        print(MedicineName2);
        var data = MedicineModel(
            "", MedicineName, MedicineName1, MedicineName2, "", "");
        await requestPost(theUrl + 'Meds/SaveMedicine', formData: data.toJson())
            .then((value) {
          print("succ");
          print(value);
          if (value.toString() != '') {
            _savePic(value.toString(), _imgPath);
            Navigator.of(context).pop("");
          }
        });
      }
    }

    return Scaffold(
      appBar: new AppBar(
        title: Text("中药新增"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: infoKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '药名',
                  ),
                  onSaved: (value) {
                    MedicineName = value;
                  },
                  validator: (val) {
                    return val.length <= 0 ? "请输入药名" : null;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '药名2',
                  ),
                  onSaved: (value) {
                    MedicineName1 = value;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '药名3',
                  ),
                  onSaved: (value) {
                    MedicineName2 = value;
                  },
                ),

                _ImageView(_imgPath),
                RaisedButton(
                  onPressed: _takePhoto,
                  child: Text("拍照"),
                ),
                RaisedButton(
                  onPressed: _openGallery,
                  child: Text("选择照片"),
                ),
                Row(children: [
                  IconButton(
                    icon: new Icon(Icons.volume_up),
                    //tooltip: 'Increase volume by 10%',
                    onPressed: () {
                      // ...
                    },
                  ),
                  Expanded(
                    child: Text(''), // 中间用Expanded控件
                  ),
                  IconButton(
                    icon: new Icon(Icons.mic),
                    //tooltip: 'Increase volume by 10%',
                    onPressed: () {
                      // ...
                    },
                  )
                ]),
                // 按钮
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
                            _saveMedicine();
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
