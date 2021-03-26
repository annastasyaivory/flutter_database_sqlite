import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'item.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();

  // future adalah tipe data yang terpanggil dengan adanya delay atau keterlambatan
  // async : menggunakan future pada sebuah method, sehingga membuat sistem menunggu sampai terjadi Blocking
  Future<Database> initDb() async {
    // await : artinya sistem harus menunggu sampai syntax tersebut selesai berjalan
    // Method getApplicationDocumentsDirectory() berfungsi untuk mengambil direktori folder aplikasi untuk menempatkan data yang dibuat pengguna sehingga tidak dapat dibuat ulang oleh aplikasi tersebut.
    Directory directory = await getApplicationDocumentsDirectory();

    //untuk menentukan nama database dan lokasi yg dibuat
    String path = directory.path + 'item.db';

    //openDatabase : membuat dan mengakses database
    // version : level penggunaan database
    // onCreate : membuat tabel
    var itemDatabase = openDatabase(path, version: 4, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

//buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    await db.execute('''
CREATE TABLE item (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT,
price INTEGER,
stock INTEGER,
itemCode TEXT
)
''');
  }

// fungsi untuk melakukan CRUD (create, read, update, delete)
// Variable count digunakan untuk menampung hasil SQL ² nya. Bertipe Integer karena ketika sistem berhasil dieksekusi, nilai yang dikeluarkan adalah 1

//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('item', orderBy: 'name');
    return mapList;
  }

//create databases
  Future<int> insert(Item object) async {
    Database db = await this.initDb();
    int count = await db.insert('item', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Item object) async {
    Database db = await this.initDb();
    int count = await db
        .update('item', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('item', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Item>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMap(itemMapList[i]));
    }
    return itemList;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
