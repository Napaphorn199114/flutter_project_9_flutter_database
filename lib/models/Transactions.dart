
class Transactions{
  String title ;  //ชื่อรายการ
  double amount; // จำนวนเงิน
  DateTime date = DateTime.now(); // วันที่ เวลา บันทึกรายการ

  Transactions({this.title="",this.amount=0,date});

}
