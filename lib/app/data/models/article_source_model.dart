class ArticleSource {
  int? id;
  String? name;
  String? url;
  String? type;
  String? image;
  String? description;
  String? homepage;
  String? createdAt;
  String? updatedAt;

  ArticleSource(
      {this.id,
      this.name,
      this.url,
      this.type,
      this.image,
      this.description,
      this.homepage,
      this.createdAt,
      this.updatedAt});

  ArticleSource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    type = json['type'];
    image = json['image'];
    description = json['description'];
    homepage = json['homepage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['type'] = type;
    data['image'] = image;
    data['description'] = description;
    data['homepage'] = homepage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
