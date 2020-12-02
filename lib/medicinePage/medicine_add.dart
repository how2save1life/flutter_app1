import 'dart:io';
import 'package:flutter_plugin_record/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/medicine_list_model.dart';
import '../service/http_service.dart';
import '../sound_widget.dart';
///新增
var theUrl = Global().BASE_url; //"http://10.0.2.2:8080/";

class MedicineAdd extends StatefulWidget {
  @override
  createState() => _MedicineAddState();
}

class _MedicineAddState extends State<MedicineAdd> {
  final myController = TextEditingController();

  var MedicineName = new TextEditingController();
  var MedicineName1 = new TextEditingController();
  var MedicineName2 = new TextEditingController();
  var _imgPath;
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  String _soundPath = "";

  @override
  void initState() {
    super.initState();
    recordPlugin.init();
  }

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

    _saveSound(String medicineId, String file) async {
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(file),
        "medicineId": medicineId,
      });
      await requestPost(theUrl + 'Meds/MedSound', formData: data).then((value) {
        print(value);
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
      recordPlugin.playByPath(path, type);
    }

    void _saveMedicine() async {
      var infoForm = infoKey.currentState;
      if (infoForm.validate()) {
        infoForm.save();
        print(infoForm);
        print(MedicineName);
        print(MedicineName1);
        print(MedicineName2);
        var data = MedicineModel("", MedicineName.text, MedicineName1.text,
            MedicineName2.text, "", "");
        await requestPost(theUrl + 'Meds/SaveMedicine', formData: data.toJson())
            .then((value) {
          print("succ");
          print(value);
          if (value.toString() != '') {
            _savePic(value.toString(), _imgPath);
            _saveSound(value.toString(), _soundPath);
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
                  controller: MedicineName,
                  onSaved: (value) {
                    MedicineName.text = value;
                  },
                  validator: (val) {
                    return val.length <= 0 ? "请输入药名" : null;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '药名2',
                  ),
                  controller: MedicineName1,
                  onSaved: (value) {
                    MedicineName1.text = value;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(
                    labelText: '药名3',
                  ),
                  controller: MedicineName2,
                  onSaved: (value) {
                    MedicineName2.text = value;
                  },
                ),

                _ImageView(_imgPath),
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
                //录音
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20, 8.0, 8.0),
                  child: new SoundWidget(
                      startRecord: _startRecord, stopRecord: _stopRecord),
                ),
                //播放录音
                if (_soundPath != "")
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
                          onPressed: () {
                            _playByPath(_soundPath, "file");
                          },
                        ))
                      ],
                    ),
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
