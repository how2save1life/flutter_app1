import 'dart:convert';
import '../service/http_service.dart';
import 'package:flutter/material.dart';
import '../model/medicine_list_model.dart';
import 'medicine_add.dart';
import 'medicine_info.dart';
import '../service/util.dart';
// import '../common.dart';
// var theUrl = "http://10.0.2.2:8080/";
var theUrl = Global().BASE_url; //"http://10.0.2.2:8080/";
///大列表
class Medicines extends StatefulWidget {
  @override
  createState() => _MedicinePageListState();
}

class _MedicinePageListState extends State<Medicines> {
  MedicineListModel medicineList = MedicineListModel([]);
  var scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMedicines();
  }

  void getMedicines() async {
    var url = theUrl + 'Meds/AllMeds';

    await request(url).then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //打印数据
      print('商品列表数据Json格式:::' + data.toString());

      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        medicineList = MedicineListModel.fromJson(data);
      });
    });
  }

  //列表项
  Widget _ListWidget(List newList, int index) {
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.black12),
              )),
          //水平方向布局
          child: Row(
            children: <Widget>[
              //返回商品图片
              _medicineImage(newList, index),
              SizedBox(
                width: 10,
              ),
              //右侧使用垂直布局
              _medicineName(newList, index)
            ],
          )),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new MedicineInfo(
                      medId: newList[index].medicineId,
                    ))).then((data) {
          getMedicines();
        });
      },
    );
  }

  //名称
  Widget _medicineName(List newList, int index) {
    return Expanded(
        //padding: EdgeInsets.all(5.0),
        // width:double.infinity,
        child: Text(
      newList[index].medicineName +
          (newList[index].medicineName1 != ''
              ? ('/' + newList[index].medicineName1)
              : "") +
          (newList[index].medicineName2 != ''
              ? ('/' + newList[index].medicineName2)
              : ""),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 18),
    ));
  }

  //图片
  Widget _medicineImage(List newList, int index) {
    if (newList[index].medicinePic != "") {
      return Container(
        width: 150,
        height: 150,
        child: Image.network(
          theUrl +
              newList[index].medicinePic +
              "/1.jpg?" +
              randomSuffix(),
          fit: BoxFit.fitWidth,
        ),
      );
    } else
      return Container(
        width: 150,
        height: 150,
      );
  }

  Widget _buildList() {
    if (medicineList.data.length > 0) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        //滚动控制器
        controller: scrollController,
        //列表长度
        itemCount: medicineList.data.length,
        //列表项构造器
        itemBuilder: (context, index) {
          //列表项 传入列表数据及索引
          return _ListWidget(medicineList.data, index);
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('药品'),
      ),
      body: _buildList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MedicineAdd())).then((data) {
            getMedicines();
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
