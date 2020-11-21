// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ImagePickerPage extends StatefulWidget {
//   ImagePickerPage({Key key}) : super(key: key);
//
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }
//
// class _ImagePickerPageState extends State<ImagePickerPage> {
//   //记录选择的照片
//   File _image;
//
//   //当图片上传成功后，记录当前上传的图片在服务器中的位置
//   String _imgServerPath;
//
//   //拍照
//   Future _getImageFromCamera() async {
//     var image =
//     await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400);
//
//     setState(() {
//       _image = image;
//     });
//   }
//
//   //相册选择
//   Future _getImageFromGallery() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image = image;
//     });
//   }
//
//   //上传图片到服务器
//   _uploadImage() async {
//     FormData formData = FormData.fromMap({
//       //"": "", //这里写其他需要传递的参数
//       "multipartFiles" : _image
//     });
//     var response =
//     await Dio().post("http://jd.itying.com/imgupload", data: formData);
//     print(response);
//     if (response.statusCode == 200) {
//       Map responseMap = response.data;
//       print("http://jd.itying.com${responseMap["path"]}");
//       setState(() {
//         _imgServerPath = "http://jd.itying.com${responseMap["path"]}";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("选择图片并上传")),
//       body: Container(
//         child: ListView(
//           children: <Widget>[
//             RaisedButton(
//               onPressed: () {
//                 _getImageFromCamera();
//               },
//               child: Text("照相机"),
//             ),
//             SizedBox(height: 10),
//             RaisedButton(
//               onPressed: () {
//                 _getImageFromGallery();
//               },
//               child: Text("相册"),
//             ),
//             SizedBox(height: 10),
//             /**
//              * 展示选择的图片
//              */
//             _image == null
//                 ? Text("no image selected")
//                 : Image.file(
//               _image,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 10),
//             RaisedButton(
//               onPressed: () {
//                 _uploadImage();
//               },
//               child: Text("上传图片到服务器"),
//             ),
//             SizedBox(height: 10),
//             _imgServerPath == null
//                 ? Text("没有上传图片")
//                 : Image.network(
//                 "http://jd.itying.com/public/upload/daoyXVTvrCCUeoIliZtNXX-s.png"),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState();
  }
}

class _ImagePickerState extends State<ImagePickerWidget> {
  var _imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ImagePicker"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _ImageView(_imgPath),
              RaisedButton(
                onPressed: _takePhoto,
                child: Text("拍照"),
              ),
              RaisedButton(
                onPressed: _openGallery,
                child: Text("选择照片"),
              ),
            ],
          ),
        ));
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
}


