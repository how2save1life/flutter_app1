import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp1/model/medicine_list_model.dart';
import '../service/http_service.dart';
import '../sound_widget.dart';
import 'package:flutter_plugin_record/index.dart';
import '../service/util.dart';
// import '../common.dart';
// var theUrl = "http://10.0.2.2:8080/";
var theUrl = Global().BASE_url; //"http://10.0.2.2:8080/";

class MedicineInfo extends StatefulWidget {
  final medId;
  final medPic;

  // final medSound;

  MedicineInfo({Key key, @required this.medId, this.medPic}) : super(key: key);

  @override
  createState() => _MedicineInfoState();
}

class _MedicineInfoState extends State<MedicineInfo> {
  var visibleEdit = false; //是否点击编辑按钮
  MedicineModel medicineModel;
  var _name = new TextEditingController();
  var _name1 = new TextEditingController();
  var _name2 = new TextEditingController();
  String _pic = ""; //string 路径 不加初始值的话会有红屏 invalid arguments
  String _sound = ""; //string 路径
  var _newPic; //file文件
  String _soundPath = "";
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();

  @override
  void initState() {
    super.initState();
    getMedicine();
  }

//  原本图片展示
  Widget _medicineImage() {
    if (_pic != "") {
      return Container(
        width: 150,
        height: 150,
        child: Image.network(
          theUrl + _pic + "/1.jpg?"+randomSuffix(),
          fit: BoxFit.fitWidth,
        ),
      );
    } else
      return Center(
        child: Text("请选择图片或拍照"),
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
        _sound = medicineModel.medicineSound;
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

  _startRecord() {
    print("开始录制");
  }

  _stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    setState(() {
      _soundPath = path;
    });
  }

  ///播放指定路径录音文件  url为iOS播放网络语音，file为播放本地语音文件
  void _playByPath(String path, String type) {
    //path 传入的是新录音地址 或 数据库内保存的录音地址
    //url的话 要补全
    if (type=="url")
      path=theUrl+path+"/1.wav";
    recordPlugin.playByPath(path, type);
  }

  @override
  Widget build(BuildContext context) {
    _updateMedicine() async {
      var url = theUrl + 'Meds/UpdateMedicine';
      var newPicData;
      var newSoundData;
      //有加入新图片
      if (_newPic != null) {
        newPicData = await MultipartFile.fromFile(_newPic.path);
      } else {
        //本身该药品就没有图片，且没有加入新图片
        newPicData = null;
      }
      if (_soundPath != "") {
        newSoundData = await MultipartFile.fromFile(_soundPath);
      } else {
        //本身该药品就没有图片，且没有加入新图片
        newSoundData = null;
      }
      FormData data = FormData.fromMap({
        "medicineId": widget.medId,
        "medicineName": _name.text,
        "medicineName1": _name1.text,
        "medicineName2": _name2.text,
        "newPic": newPicData,
        "newSound": newSoundData
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
              enabled: visibleEdit,
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
              enabled: visibleEdit,
              decoration: new InputDecoration(
                labelText: '药名2',
              ),
              controller: _name1,
              // onSaved: (value) {
              //   MedicineName1 = value;
              // },
            ),
            TextFormField(
              enabled: visibleEdit,
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

            
              if (visibleEdit)Padding(
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
              if (visibleEdit)Padding(
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
              if (visibleEdit)Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                child: new SoundWidget(
                    startRecord: _startRecord, stopRecord: _stopRecord),
              ),
              //播放录音
              if (_sound != "" || _soundPath != "")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: RaisedButton(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(text: "播放录音"),
                            WidgetSpan(
                              child: Icon(Icons.volume_up),
                            ),
                          ]),
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(15.0),
                        onPressed: () {//没有新录音 播放老的
                          _soundPath == ""
                              ? _playByPath(_sound, "url")
                              : _playByPath(_soundPath, "file");
                        },
                      ))
                    ],
                  ),
                ),

              // 上传按钮
            if (visibleEdit)Padding(
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
            // 编辑按钮
            if (!visibleEdit)
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("编辑"),
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            visibleEdit = !visibleEdit;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (visibleEdit)
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("取消"),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            visibleEdit = !visibleEdit;
                          });
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
