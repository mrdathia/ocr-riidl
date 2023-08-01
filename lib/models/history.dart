class History {
  int? id;
  int? saved;
  int? deleted;
  String? imgPath = "";
  String? fileName = "";
  String? createdAt = "";
  String? updatedAt = "";

  History(
      {this.id,
      this.saved,
      this.deleted,
      this.imgPath,
      this.fileName,
      this.createdAt,
      this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    saved = json['saved'];
    deleted = json['deleted'];
    imgPath = json['imgpath'];
    fileName = json['filename'];
    createdAt = json['createdat'];
    updatedAt = json['updatedat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['saved'] = saved;
    data['deleted'] = deleted;
    data['imgpath'] = imgPath;
    data['filename'] = fileName;
    data['createdat'] = createdAt;
    data['updatedat'] = updatedAt;
    return data;
  }
}
