import 'package:flutter/foundation.dart';
import 'package:flutter_database/database/transaction_db.dart';
import 'package:flutter_database/models/Transactions.dart';


class TransactionProvider with ChangeNotifier {   //แจ้งเตือนเมื่อมีการเปลี่ยนแปลงข้อมูล
   // ชื่อรายการ , จำนวนเงิน , วันที่
   // ตัวอย่างข้อมูล
  List<Transactions> transactions = [
   // Transaction(title:"ซื้อหนังสือ", amount:500,date:DateTime.now()),  ตัวอย่าง


  ];

  //ดึงข้อมูล
  List<Transactions>getTransaction(){
    return transactions;
  }
  void initData() async{  //ดึงข้อมูลตอนเริ่มต้น start
    var db = TransactionDB(dbName: "transactions.db");
    //ดึงข้อมูลมาแสดงผล
    transactions =await db.loadAllData();
    notifyListeners();
  }
  void addTransaction(Transactions statement) async{
    //var db = await TransactionDB(dbName: "transactions.db").openDatabase(); // ชื่อฐานข้อมูล transactions.db
   // print(db);    ///data/user/0/com.example.flutter_database/app_flutter/transactions.db
    var db = TransactionDB(dbName: "transactions.db");
    //บันทึกข้อมูล
    await db.InsertData(statement);
    //ดึงข้อมูลมาแสดงผล
    transactions =await db.loadAllData();
   // transactions.insert(0,statement);  //แทรกข้อมูล ให้ตัวล่าสุด อยู่บนสุด
    //แจ้งเตือน Consumer ให้เปลี่ยนแปลงข้อมูลใหม่
    notifyListeners(); 
  }
}