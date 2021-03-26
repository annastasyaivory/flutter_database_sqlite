import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dbhelper.dart';
import 'entryform.dart';
import 'item.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper(); //panggil class dbhelper
  int count = 0;
  List<Item> itemList;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                //TODO 2 Panggil Fungsi untuk Insert ke DB
                if (item != null) {
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              this.itemList[index].name,
              style: textStyle,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: ' + this.itemList[index].price.toString()),
                Text('Stock: ' + this.itemList[index].stock.toString()),
                Text('Item Code: ' + this.itemList[index].itemCode),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
//TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                int id = this.itemList[index].id;
                int result = await dbHelper.delete(id); //hapus sesuai id
                itemList.removeAt(index); // hapus pada list sesuai index
                updateListView(); //update list item
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
//TODO 4 Panggil Fungsi untuk Edit data
              if (item != null) {
                int result = await dbHelper.update(item); //update item
                if (result > 0) {
                  updateListView(); //update list item
                }
              }
            },
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
//TODO 1 Select data dari DB
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
