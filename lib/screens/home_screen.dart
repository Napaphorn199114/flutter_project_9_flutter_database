import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/provider/transaction_provider.dart';
import 'package:flutter_database/screens/form_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TransactionProvider>(context,listen: false).initData();  //เรียก initData ใน transaction_provider
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แอพบัญชี"),
          actions: [
            //เพิ่ม Icon บน appbar
            IconButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                icon: Icon(Icons.exit_to_app)) // exit
          ],
        ),
        body: Consumer(
          builder: (context, TransactionProvider provider, child) {
            var count = provider.transactions.length; //นับจำนวนข้อมูล
            if (count <= 0) {
              return Center(
                child: Text(
                  "ไม่พบข้อมูล",
                  style: TextStyle(fontSize: 35),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount:
                      count, //itemCount : 4 คือกำหนด ข้อมูลให้มีแค่ 4 เฉยๆ ถ้าไม่กำหนด จะสกอเลื่อนได้เรื่อยๆ provider.transactions.length
                  itemBuilder: (context, int index) {
                    Transactions data = provider.transactions[
                        index]; //ดึงเอารายการแต่ละรายการจาก list trasaction ดึงมาทีละแถว
                    return Card(
                      //ใช้ card จะง่ายกว่า container
                      elevation: 5, //สร้างเงาเพื่อบอกพื้นที่
                      // margin: const EdgeInsets.all(10.0), // all กำหนดระยะห่างบนล่าง ซ้ายขวา
                      margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal:
                              5), // หรือให้ห่างจากแนวตั้ง เท่ากับ 8 แต่ติดขอบซ้ายขวา แนวนอน 5 (ซ้าย ขวา)
                      child: ListTile(
                        leading: CircleAvatar(
                          // สร้างวงกลม
                          radius: 30,
                          child: FittedBox(
                            // บอกว่ามีเนื้อหาอะไรอยู่ข้างใน
                            child: Text(data.amount.toString()),
                          ),
                        ),
                        title: Text(data.title),
                        subtitle: Text(DateFormat("dd/MM/yyyy").format(data.date )),
                      ),
                    );
                  });
            }
          },
        ));
  }
}