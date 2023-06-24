class CategoriesModel{

  String? id;
  String? name;
  String? status;

  CategoriesModel({
    this.name,
    this.id,
    this.status,
  });

  Map<String, dynamic> toMap() => {
    'name' : name,
    'id' : id,
    'status' : status,
  };

  CategoriesModel.fromMap(Map snapshot) :
    name = snapshot['name'],
    id = snapshot['id'],
    status = snapshot['status'];

}