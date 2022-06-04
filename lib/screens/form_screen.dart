import 'package:flutter/material.dart';
import 'package:flutter_database/main.dart';
import 'package:flutter_database/models/Transactions.dart';
import 'package:flutter_database/provider/transaction_provider.dart';
import 'package:flutter_database/screens/home_screen.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  //controller จำนวนอ้างอิงตาม fidld มี 2 
  final titleController = TextEditingController(); //รับค่าชื่อรายการ
  final amountContraller = TextEditingController(); //รับตัวเลขจำนวนเงิน
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("แบบฟอร์มบันทึกข้อมูล"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),   // padding ครอบ form ไม่ให้ติดขอบ all คือทั้ง 4 ทิศทาง บน ล่าง ซ้าย ขวา
          child: Form(
            key:formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: new InputDecoration(labelText: "ชื่อรายการ"),
                  autofocus: false,   //ให้เคอเซอร์มาอยู่ที่บรรทัดแรก และเตรียมคีย์บอร์ดไว้ ใช้ true
                  controller: titleController,
                  validator: (value){    //กรองข้อมูล
                    if(value==null || value.isEmpty){
                      return "กรุณาป้อนชื่อรายการ";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: "จำนวนเงิน"),
                  keyboardType: TextInputType.number,   //keyboard ป้อนได้แค่ตัวเลข
                  controller: amountContraller,
                  validator: (value){    //กรองข้อมูล
                    if(value==null || value.isEmpty){
                      return "กรุณาป้อนจำนวนเงิน";
                    }
                    if(double.parse(value)<=0){
                      return "กรุณาป้อนตัวเลขมากกว่า 0";
                    }
                    return null;
                  },
                ),
                TextButton(
                  child: Text(
                    "เพิ่มข้อมูล",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {           
                    if(formKey.currentState!.validate()){  //validate เอาไว้เช็คข้อผิดพลาดตอนกรอกข้อมูล
                      var title = titleController.text;
                      var amount = amountContraller.text;
                      print(title);
                      print(amount);

                      //เตรียมข้อมูล
                      Transactions statement = Transactions(
                        title: title,
                        amount: double.parse(amount),
                        date: DateTime.now()
                      );  //object

                      //เรียก Provider
                      var provider = Provider.of<TransactionProvider>(context,listen: false);
                      provider.addTransaction(statement);  //object trasaction ที่ป้อนข้อมูลมา
                      //Navigator.pop(context);              //pop หน้าที่2 ออกกลับไปหน้าที่ 1
                      Navigator.push(context,MaterialPageRoute(
                        fullscreenDialog : true,
                        builder: (context){
                        return MyHomePage(title: '',);
                      })); 
                    }
                   
                  },
                )
              ],
            ),
          ),
        ));
  }
}
