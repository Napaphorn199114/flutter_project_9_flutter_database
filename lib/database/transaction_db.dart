import 'dart:io';

import 'package:flutter_database/models/Transactions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TransactionDB {
  //บริการเกี่ยวกับฐานข้อมูล
  String dbName; //เก็บชื่อฐานข้อมูล

  //ถ้ายังไม่ถูกสร้าง ให้ทำการ => สร้าง
  //ถูกสร้างไว้แล้ว => เปิด
  TransactionDB({this.dbName = ""});

  //A,B,C  หา path ตำแหน่ง user account
  //dbLocation = C:/users/Napaphorn/transaction.db
  //dbName = transaction.db
  Future<Database> openDatabase() async {
    //หาตำแหน่งที่จัดเก็บข้อมูล
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    // สร้าง database
    DatabaseFactory dbFactory = await databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);

    return db;

    ///data/user/0/com.example.flutter_database/app_flutter/transactions.db

    //บันทึกข้อมูล
    // ignore: dead_code
  }

  Future<int> InsertData(Transactions statement) async {
    //ฐานข้อมููล => Store
    //transaction.db => store ข้างในชื่อว่า expense
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    //json
    var keyID = store.add(db, {
      "title": statement.title,
      "amount": statement.amount,
      "date": statement.date.toIso8601String() //มาตรฐานนิยาม date
    });
    db.close(); //ปิดฐานข้อมูล
    return keyID; // เรียงลำดับ 1,2,3,4,5  จากน้อยไปมาก
  }

  //ดึงข้อมูล
  //ใหม่ => เก่า false มาก => น้อย
  //เก่า =>ใหม่ true น้อย =>มาก
  Future<List<Transactions>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [
          SortOrder(Field.key, false)
        ])); //find ดึงข้อมูลเรียงลำดับจากน้อยไปมาก เรียงจากเก่าไปใหม่  false เรียงจากใหม่ไปเก่า true เก่าไปใหม่
    List<Transactions> transactionList = <Transactions>[];
    //ดึงมาทีละแถว
    for (var record in snapshot) {
      transactionList.add(Transactions(
          title: record["title"] as String,
          amount: record["amount"] as double,
          date: DateTime.parse(record["date"] as String)));
    }
    print(snapshot);
    return transactionList;
  }
}
