class ProfilePageModel {
  List<PageData>? data;
  bool? success;
  int? status;

  ProfilePageModel({this.data, this.success, this.status});

  ProfilePageModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PageData>[];
      json['data'].forEach((v) {
        data!.add(PageData.fromJson(v));
      });
    }
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}

class PageData {
  int? id;
  String? title;
  String? slug;
  String? content;
  String? metaTitle;
  String? metaDescription;

  PageData(
      {this.id,
        this.title,
        this.slug,
        this.content,
        this.metaTitle,
        this.metaDescription});

  PageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['content'] = content;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    return data;
  }
}
