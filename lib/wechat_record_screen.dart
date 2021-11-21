import 'package:flutter/material.dart';
import 'package:flutter_plugin_record/index.dart';

import 'service/http_service.dart';

// var theUrl = "http://10.0.2.2:8080/";
var theUrl = Global().BASE_url;//"http://10.0.2.2:8080/";
class WeChatRecordScreen extends StatefulWidget {
  @override
  _WeChatRecordScreenState createState() => _WeChatRecordScreenState();
}

class _WeChatRecordScreenState extends State<WeChatRecordScreen> {
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  String filePath = "";
  String toastShow = "悬浮框";
  OverlayEntry overlayEntry;
  @override
  void initState(){
    super.initState();
    // FlutterPluginRecord   recordPlugin = new FlutterPluginRecord();
//    初始化
    recordPlugin.init();
    // ///初始化方法的监听
    // recordPlugin.responseFromInit.listen((data) {
    //   if (data) {
    //     print("初始化成功");
    //   } else {
    //     print("初始化失败");
    //   }
    // });
    //
    // /// 开始录制或结束录制的监听
    // recordPlugin.response.listen((data) {
    //   if (data.msg == "onStop") {
    //     ///结束录制时会返回录制文件的地址方便上传服务器
    //     print("onStop  文件路径" + data.path);
    //     filePath = data.path;
    //     print("onStop  时长 " + data.audioTimeLength.toString());
    //   } else if (data.msg == "onStart") {
    //     print("onStart --");
    //   } else {
    //     print("--" + data.msg);
    //   }
    // });
    //
    // ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    // recordPlugin.responseFromAmplitude.listen((data) {
    //   var voiceData = double.parse(data.msg);
    //   print("振幅大小   " + voiceData.toString());
    // });
    //
    // recordPlugin.responsePlayStateController.listen((data) {
    //   print("播放路径   " + data.playPath);
    //   print("播放状态   " + data.playState);
    // });
  }
  showView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            child: Center(
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff77797A),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  ///播放语音的方法
  void play() {
    recordPlugin.play();
  }

  ///播放指定路径录音文件  url为iOS播放网络语音，file为播放本地语音文件
  void playByPath(String path,String type) {
    recordPlugin.playByPath(path,type);
  }

  ///暂停|继续播放
  void pause() {
    recordPlugin.pausePlay();
  }

  void stopPlay() {
    recordPlugin.stopPlay();
  }
  startRecord(){
    print("开始录制");
    // recordPlugin.start();
  }

  stopRecord(String path,double audioTimeLength ){
    print("结束束录制");
    print("音频文件位置"+path);
    print("音频录制时长"+audioTimeLength.toString());
    filePath=path;
    // recordPlugin.stop();
  }
  @override
  void dispose() {
    /// 当界面退出的时候是释放录音资源
    recordPlugin.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("仿微信发送语音"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // new FlatButton(
            //     onPressed: () {
            //       showView(context);
            //     },
            //     child: new Text("悬浮组件")),
            // new FlatButton(
            //     onPressed: () {
            //       if (overlayEntry != null) {
            //         overlayEntry.remove();
            //         overlayEntry = null;
            //       }
            //     },
            //     child: new Text("隐藏悬浮组件")),
            // new FlatButton(
            //     onPressed: () {
            //       setState(() {
            //         toastShow = "111";
            //         if (overlayEntry != null) {
            //           overlayEntry.markNeedsBuild();
            //         }
            //       });
            //     },
            //     child: new Text("悬浮窗状态更新")),
            new VoiceWidget(startRecord: startRecord,stopRecord: stopRecord),
            FlatButton(
              child: Text("播放本地指定路径录音文件"),
              onPressed: () {
                playByPath(filePath,"file");
              },
            ),
            FlatButton(
              child: Text("播放网络wav文件"),
              onPressed: () {
                playByPath(theUrl+"image/1.wav","url");
              },
            ),
            FlatButton(
              child: Text("暂停|继续播放"),
              onPressed: () {
                pause();
              },
            ),
            FlatButton(
              child: Text("停止播放"),
              onPressed: () {
                stopPlay();
              },
            ),
          ],
        ),
      ),
    );
  }
}
