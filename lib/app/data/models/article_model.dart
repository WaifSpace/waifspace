class Article {
  int? id;
  String? title;
  String? cnTitle;
  String? content;
  String? cnContent;
  String? url;
  String? imageUrl;
  bool? isRead;
  bool? isFavorite;
  int? sourceId;
  String? sourceName;
  String? sourceUid;
  String? pubDate;
  String? createdAt;
  String? updatedAt;

  Article(
      {this.id,
      this.title,
      this.cnTitle,
      this.content,
      this.cnContent,
      this.url,
      this.imageUrl,
      this.isRead,
      this.isFavorite,
      this.sourceId,
      this.sourceName,
      this.sourceUid,
      this.pubDate,
      this.createdAt,
      this.updatedAt});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cnTitle = json['cn_title'];
    content = json['content'];
    cnContent = json['cn_content'];
    url = json['url'];
    imageUrl = json['image_url'];
    isRead = json['is_read'];
    isFavorite = json['is_favorite'];
    sourceId = json['source_id'];
    sourceName = json['source_name'];
    sourceUid = json['source_uid'];
    pubDate = json['pub_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['cn_title'] = cnTitle;
    data['content'] = content;
    data['cn_content'] = cnContent;
    data['url'] = url;
    data['image_url'] = imageUrl;
    data['is_read'] = isRead;
    data['is_favorite'] = isFavorite;
    data['source_id'] = sourceId;
    data['source_name'] = sourceName;
    data['source_uid'] = sourceUid;
    data['pub_date'] = pubDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
