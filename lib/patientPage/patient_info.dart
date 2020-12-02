import 'dart:convert';
import 'package:flutterapp1/model/patient_list_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../service/http_service.dart';
import '../service/util.dart';

var theUrl = Global().BASE_url; //"http://10.0.2.2:8080/";

///个人信息 可以修改
class PatientInfo extends StatefulWidget {
  final patientId;

  PatientInfo({Key key, @required this.patientId}) : super(key: key);

  @override
  createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  var visibleEdit = false; //是否点击编辑按钮
  PatientModel patientModel;
  var mySex;
  var myBirthday;
  var patientName = new TextEditingController();
  var patientAddr = new TextEditingController();
  var patientPhone = new TextEditingController();
  var patientBirthday = "";
  var patientSex;
  String _headPath = ""; //string 路径 不加初始值的话会有红屏 invalid arguments
  var _newHead; //file文件

  var selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        locale: Locale('zh'),
        // 强制显示中文 如果报错就删除,跟随系统语言显示
        context: context,
        initialDate: selectedDate,
        //初始值
        firstDate: DateTime(1900, 1),
        //开始日期
        lastDate: DateTime(2050)); //结束日期
    if (picked != null && picked != selectedDate)
      setState(() {
        patientBirthday = picked.toString().split(' ')[0];
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    getPatient();
  }

//  原本图片展示
  Widget _medicineImage() {
    if (_headPath != "") {
      return Container(
        width: 150,
        height: 150,
        child: Image.network(
          theUrl + _headPath + "/1.jpg?" + randomSuffix(),
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

  //加载病人信息
  void getPatient() async {
    var url = theUrl + 'Patient/OnePatient';
    FormData data = FormData.fromMap({"patientId": widget.patientId});
    await requestPost(url, formData: data).then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //打印数据
      print('病人列表数据Json格式:::' + data.toString());
      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        patientModel = PatientModel.fromJson(data);
        patientName.text = patientModel.patientName;
        patientAddr.text = patientModel.patientAddr;
        patientPhone.text = patientModel.patientPhone;
        _headPath = patientModel.patientHead;
        patientSex = patientModel.patientSex;
        patientBirthday = patientModel.patientBirthday;
        if (patientBirthday != null && patientBirthday != "") {
          selectedDate = DateTime.parse(patientBirthday);
          myBirthday = new TextEditingController(
              text: (patientBirthday.split(' ')[0].split('-')[0] +
                  "年" +
                  patientBirthday.split(' ')[0].split('-')[1] +
                  "月" +
                  patientBirthday.split(' ')[0].split('-')[2] +
                  "日"));
        }
        mySex = new TextEditingController(
            text: (patientSex == '' ? "" : (patientSex == 'M' ? "男" : "女")));
      });
    });
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _newHead = image;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _newHead = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> infoKey = GlobalKey<FormState>();

    _updatePatient() async {
      var url = theUrl + 'Patient/UpdatePatient';
      var newHeadData;
      //有加入新图片
      if (_newHead != null) {
        newHeadData = await MultipartFile.fromFile(_newHead.path);
      } else {
        //本身该就没有图片，且没有加入新图片
        newHeadData = null;
      }
      FormData data = FormData.fromMap({
        "patientId": widget.patientId,
        "patientName": patientName.text,
        "patientAddr": patientAddr.text,
        "patientPhone": patientPhone.text,
        "patientSex": patientSex,
        "patientBirthday": patientBirthday,
        "newHead": newHeadData,
      });
      print(widget.patientId);
      await requestPost(url, formData: data).then((value) {
        if (value.toString() != '') {
          Navigator.of(context).pop("");
        }
      });
    }

    Widget _showPatient() {
      return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: infoKey,
            child: Column(
              children: [
                _newHead != null
                    ? _newMedicineImage(_newHead)
                    : _medicineImage(),
                if (visibleEdit)
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
                if (visibleEdit)
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
                  enabled: visibleEdit,
                  decoration: new InputDecoration(
                    labelText: '姓名',
                  ),
                  controller: patientName,
                  validator: (val) {
                    return val.length <= 0 ? "请输入姓名" : null;
                  },
                ),
                TextFormField(
                  enabled: visibleEdit,
                  decoration: new InputDecoration(
                    labelText: '手机号',
                  ),
                  controller: patientPhone,
                ),
                TextFormField(
                  enabled: visibleEdit,
                  decoration: new InputDecoration(
                    labelText: '联系地址',
                  ),
                  controller: patientAddr,
                ),
                if (!visibleEdit)
                  TextFormField(
                    enabled: visibleEdit,
                    decoration: new InputDecoration(
                      labelText: '性别',
                    ),
                    controller: mySex,
                  ),
                if (!visibleEdit)
                  TextFormField(
                    enabled: visibleEdit,
                    decoration: new InputDecoration(
                      labelText: '出生年月日',
                    ),
                    controller: myBirthday,
                  ),

                if (visibleEdit)
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
                if (visibleEdit)
                  Row(
                    children: [
                      Text("出生日期："),
                      Expanded(
                        child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0].split('-')[0]+"年"+
                            "${selectedDate.toLocal()}".split(' ')[0].split('-')[1]+"月"+
                            "${selectedDate.toLocal()}".split(' ')[0].split('-')[2]+"日"),
                      ),
                      if (visibleEdit)
                        RaisedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('选择日期'),
                        )
                    ],
                  ),
                // 上传按钮
                if (visibleEdit)
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(15.0),
                            child: Text("更新"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              _updatePatient();
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
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("详细信息"),
        ),
        body: _showPatient());
  }
}
