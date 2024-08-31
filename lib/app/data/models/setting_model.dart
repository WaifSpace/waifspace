class Setting {
  int? id;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Setting({this.id, this.key, this.value, this.createdAt, this.updatedAt});

  Setting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
