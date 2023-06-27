class BankAccountModel{

  String? id;
  String? name;
  String? status;
  String? user;

  BankAccountModel({
    this.name,
    this.id,
    this.status,
    this.user,
  });

  Map<String, dynamic> toMap() => {
    'name' : name,
    'id' : id,
    'status' : status,
    'user' : user,
  };

  BankAccountModel.fromMap(Map snapshot) :
    name = snapshot['name'],
    id = snapshot['id'],
    status = snapshot['status'],
    user = snapshot['user'];

}