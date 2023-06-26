class CategoriesModel{

  String? id;
  String? name;
  String? status;
  String? user;

  CategoriesModel({
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

  CategoriesModel.fromMap(Map snapshot) :
    name = snapshot['name'],
    id = snapshot['id'],
    status = snapshot['status'],
    user = snapshot['user'];

}