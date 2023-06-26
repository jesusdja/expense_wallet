class PaymentMonthModel{

  String? id;
  String? title;
  String? amount;
  String? category;
  String? user;
  String? status;
  String? date;

  PaymentMonthModel({
    this.id,
    this.title,
    this.amount,
    this.category,
    this.user,
    this.status,
    this.date,
  });

  Map<String, dynamic> toMap() => {
    'id' : id,
    'title' : title,
    'amount' : amount,
    'category' : category,
    'user' : user,
    'status' : status,
    'date' : date,
  };

  PaymentMonthModel.fromMap(Map snapshot) :
    id = snapshot['id'],
    title = snapshot['title'],
    amount = snapshot['amount'],
    category = snapshot['category'],
    user = snapshot['user'],
    status = snapshot['status'],
    date = snapshot['date'];

}