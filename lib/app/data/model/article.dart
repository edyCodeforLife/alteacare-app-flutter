class Article {
  Article({
    this.status,
    this.message,
    this.meta,
    this.data,
  });

  bool? status;
  String? message;
  Meta? meta;
  List<DatumArticle>? data;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        status: json["status"] as bool,
        message: json["message"] as String,
        meta: Meta.fromJson(json["meta"] as Map<String, dynamic>),
        data: List<DatumArticle>.from((json["data"] as List).map((x) => DatumArticle.fromJson(x as Map<String, dynamic>))),
      );

  factory Article.fromJsonError(Map<String, dynamic> json) => Article(
        status: json["status"] as bool,
        message: json["message"] as String,
      );

  factory Article.fromJsonErrorCatch(String json) => Article(
        message: json,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumArticle {
  DatumArticle({
    this.id,
    this.title,
    this.text,
    this.image,
    this.isPopular,
    this.tags,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  String? id;
  String? title;
  String? text;
  String? image;
  String? slug;
  bool? isPopular;
  List<Tag>? tags;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;

  factory DatumArticle.fromJson(Map<String, dynamic> json) => DatumArticle(
        id: json["id"] as String,
        title: json["title"] as String,
        text: json["text"] as String,
        image: json["image"] as String,
        slug: json['slug'] as String,
        isPopular: json["is_popular"] == null ? false : json["is_popular"] as bool,
        tags: List<Tag>.from((json["tags"] as List).map((x) => Tag.fromJson(x as Map<String, dynamic>))),
        createdAt: json["created_at"] as String,
        updatedAt: json["updated_at"] as String,
        createdBy: json["created_by"] as String,
        updatedBy: json["updated_by"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "image": image,
        "is_popular": isPopular ?? false,
        "tags": List<dynamic>.from(tags!.map((x) => x.toJson())),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

class DatumArticleV2 {
  DatumArticleV2({
    this.id,
    this.title,
    this.text,
    this.image,
    this.imageDescription,
    this.isPopular,
    this.tags,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.peninjauMateri,
    this.editor,
    this.category,
  });

  int? id;
  String? title;
  String? text;
  String? image;
  String? imageDescription;
  String? slug;
  bool? isPopular;
  List<String>? tags;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? peninjauMateri;
  String? editor;
  String? category;

  factory DatumArticleV2.fromJson(Map<String, dynamic> json) => DatumArticleV2(
        id: json["id"] as int,
        title: json["title"] as String,
        text: json["text"] as String,
        image: json["image"] as String,
        slug: json['slug'] as String,
        imageDescription: json['image_description'] as String,
        peninjauMateri: json['peninjau_matery'] as String, //iya, pake y di json-nya
        isPopular: json['is_popular'] == "true",
        tags: (json['tags'] as List).map((e) => e as String).toList(),
        createdAt: json["created_at"] as String,
        updatedAt: json["updated_at"] as String,
        createdBy: json["created_by"] as String,
        updatedBy: json["updated_by"] as String,
        category: json['category'] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "image": image,
        "is_popular": isPopular ?? false,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}

class Tag {
  Tag({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ArticleCategory {
  ArticleCategory({
    this.id,
    this.name,
  });

  String? id;
  String? name;

  factory ArticleCategory.fromJson(Map<String, dynamic> json) => ArticleCategory(
        id: json["id"] as String,
        name: json["name"] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Meta {
  Meta({
    this.page,
    this.perPage,
    this.totalPage,
    this.totalData,
  });

  int? page;
  int? perPage;
  int? totalPage;
  int? totalData;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"] as int,
        perPage: json["per_page"] as int,
        totalPage: json["total_page"] as int,
        totalData: json["total_data"] as int,
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total_page": totalPage,
        "total_data": totalData,
      };
}
