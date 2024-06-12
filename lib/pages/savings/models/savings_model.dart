class SavingModel{

  String? id;
  String? title;
  String? user;
  String? date;
  List<SavingLineModel> lines;

  SavingModel({
    this.id,
    this.title,
    this.user,
    this.date,
    this.lines = const [],
  });

  Map<String, dynamic> toMap() => {
    'id' : id,
    'title' : title,
    'user' : user,
    'date' : date,
    'lines' : lines,
  };

  SavingModel.fromMap(Map snapshot) :
    id = snapshot['id'],
    title = snapshot['title'],
    user = snapshot['user'],
    date = snapshot['date'],
    lines = (snapshot['lines'] as List).map((e) => SavingLineModel.fromMap(e)).toList();
}

class SavingLineModel{

  String? id;
  String? title;
  String? user;
  String? date;
  String? status;
  double? amount;
  String? note;

  SavingLineModel({
    this.id,
    this.title,
    this.user,
    this.date,
    this.status,
    this.amount,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'id' : id,
    'title' : title,
    'user' : user,
    'date' : date,
    'status' : status,
    'amount' : amount,
    'note' : note,
  };

  SavingLineModel.fromMap(Map snapshot) :
        id = snapshot['id'],
        title = snapshot['title'],
        user = snapshot['user'],
        date = snapshot['date'],
        status = snapshot['status'],
        amount = snapshot['amount'],
        note = snapshot['note'];

}