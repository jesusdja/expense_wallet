class PaymentModel{

  String? id;
  String? title;
  String? amount;
  String? category;
  String? user;
  String? date;
  String? month;

  PaymentModel({
    this.id,
    this.title,
    this.amount,
    this.category,
    this.user,
    this.date,
    this.month,
  });

  Map<String, dynamic> toMap() => {
    'id' : id,
    'title' : title,
    'amount' : amount,
    'category' : category,
    'user' : user,
    'date' : date,
    'month' : month,
  };

  PaymentModel.fromMap(Map snapshot) :
    id = snapshot['id'],
    title = snapshot['title'],
    amount = snapshot['amount'],
    category = snapshot['category'],
    user = snapshot['user'],
    month = snapshot['month'],
    date = snapshot['date'];

}