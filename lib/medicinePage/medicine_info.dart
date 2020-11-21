import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp1/model/medicine_list_model.dart';
import '../service/http_service.dart';

var theUrl = "http://10.0.2.2:8080/";

class MedicineInfo extends StatefulWidget {
  final medId;
  final medPic;

  MedicineInfo({Key key, @required this.medId, this.medPic}) : super(key: key);

  @override
  createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  MedicineModel medicineModel;
  var _name = new TextEditingController();
  var _name1 = new TextEditingController();
  var _name2 = new TextEditingController();
  String _pic = ""; //不加初始值的话会有红屏 invalid arguments
  var _newPic;

  @override
  void initState() {
    super.initState();
    getMedicine();
  }

//  原本图片展示
  Widget _medicineImage() {
    return Container(
      width: 150,
      height: 150,
      child: Image.network(
        theUrl + _pic + "/1.jpg",
        fit: BoxFit.fitWidth,
      ),
    );
  }

  //新选择的图片展示
  Widget _newMedicineImage(myPic) {
    return Container(
        width: 150,
        height: 150,
        child: Image.file(
          myPic,
          fit: BoxFit.fitWidth,
        ));
  }

  //加载药品信息
  void getMedicine() async {
    var url = theUrl + 'Meds/OneMed';
    FormData data = FormData.fromMap({"medicineId": widget.medId});
    await requestPost(url, formData: data).then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //打印数据
      print('商品列表数据Json格式:::' + data.toString());
      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        medicineModel = MedicineModel.fromJson(data);
        _name.text = medicineModel.medicineName;
        _name1.text = medicineModel.medicineName1;
        _name2.text = medicineModel.medicineName2;
        _pic = medicineModel.medicinePic;
      });
    });
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _newPic = image;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newPic = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateMedicine() async {
      var url = theUrl + 'Meds/UpdateMedicine';
      var newPicData;
      //有加入新图片
      if (_newPic != null) {
        newPicData = await MultipartFile.fromFile(_newPic.path);
      } else {
        //本身该药品就没有图片，且没有加入新图片
        newPicData = null;
      }
      FormData data = FormData.fromMap({
        "medicineId": widget.medId,
        "medicineName": _name.text,
        "medicineName1": _name1.text,
        "medicineName2": _name2.text,
        "newPic": newPicData
      });
      print(widget.medId);
      await requestPost(url, formData: data).then((value) {
        if (value.toString() != '') {
          Navigator.of(context).pop("");
        }
      });
    }

    Widget _showMedicine() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: new InputDecoration(
                labelText: '药名',
              ),
              controller: _name,
              // onSaved: (value) {
              //   MedicineName = value;
              // },
              validator: (val) {
                return val.length <= 0 ? "请输入药名" : null;
              },
            ),
            TextFormField(
              decoration: new InputDecoration(
                labelText: '药名2',
              ),
              controller: _name1,
              // onSaved: (value) {
              //   MedicineName1 = value;
              // },
            ),
            TextFormField(
              decoration: new InputDecoration(
                labelText: '药名3',
              ),
              controller: _name2,
              // onSaved: (value) {
              //   MedicineName2 = value;
              // },
            ),
            //_medicineImage(),
            _newPic != null ? _newMedicineImage(_newPic) : _medicineImage(),
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
                        _updateMedicine();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("详细信息"),
        ),
        body: _showMedicine());
  }
}
