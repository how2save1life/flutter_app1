import 'medicinePage/medicine_show.dart';
import 'package:flutter/material.dart';
import 'sound_test.dart';
import 'test.dart';
import 'common.dart';
void main() => runApp(MyApp());
// // var theUrl = "http://10.0.2.2:8080/";
// var theUrl = Global().BASE_url;//"http://10.0.2.2:8080/";
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '抓药',
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("抓药app"),
      ),
      body: Center(
        child: Column(
          children: [
            new MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('药品信息'),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Medicines()));
              },
            ),
            new MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('test'),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new ImagePickerWidget()));
              },
            ),
            new MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('test'),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new soundPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*
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
    var url = theUrl+'Meds/AllMeds';

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

  //商品列表项
  Widget _ListWidget(List newList, int index) {
    return Container(
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
          Column(
            children: <Widget>[
              _medicineName(newList, index),
            ],
          ),
        ],
      ),
    );
  }

  //商品名称
  Widget _medicineName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: [
          Text(
            newList[index].medicineName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            newList[index].medicineName1 != ''
                ? ('/' + newList[index].medicineName1)
                : "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            newList[index].medicineName2 != ''
                ? ('/' + newList[index].medicineName2)
                : "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  //商品图片
  Widget _medicineImage(List newList, int index) {
    return Container(
      width: 150,
      height: 150,
      child: Image.network(theUrl+newList[index].medicinePic,fit: BoxFit.fitWidth,),
    );
  }
  Widget _buildList() {
    if (medicineList.data.length > 0) {
      return ListView.builder(
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
    );
  }
}*/

// class RandomWords extends StatefulWidget{
//   @override
//   createState() {
//     return new RandomWordsState();
//   }
// }

//class RandomWordsState extends State<RandomWords>{
//   final _suggestions = <WordPair>[];
//   final _biggerFont = const TextStyle(fontSize: 18.0);
//   final _saved = new Set<WordPair>();
//   Widget _buildSuggestions(){
//     return new ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//
//       itemBuilder: (context,i){
//         if (i.isOdd) return new Divider();
//
//         final index = i~/2;
//         if (index>= _suggestions.length){
//           _suggestions.addAll(generateWordPairs().take(10));
//         }
//         return _buildRow(_suggestions[index]);
//       }
//     );
//   }
//   Widget _buildRow(WordPair pair) {
//     final alreadySaved = _saved.contains(pair);
//     return new ListTile(
//       title: new Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: new Icon(
//         alreadySaved ? Icons.favorite : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           } else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }
//   void _pushSaved() {
//     Navigator.of(context).push(
//       new MaterialPageRoute(
//         builder: (context) {
//           final tiles = _saved.map(
//                 (pair) {
//               return new ListTile(
//                 title: new Text(
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final divided = ListTile
//               .divideTiles(
//             context: context,
//             tiles: tiles,
//           ).toList();
//
//           return new Scaffold(
//             appBar: new AppBar(
//               title: new Text('Saved Suggestions'),
//             ),
//             body: new ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     // final wordPair = new WordPair.random();
//     // return new Text(wordPair.asPascalCase);
//     return new Scaffold (
//       appBar: new AppBar(
//         title: new Text('Startup Name Generator'),
//         actions: <Widget>[
//           new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//   }
// }
