class AttachmentInspectionModel {
  const AttachmentInspectionModel({
    this.id = '',
    this.code = '',
    this.image = '',
    this.imageUrl = '',
  });

  factory AttachmentInspectionModel.fromJson(Map<String, dynamic> json) =>
      AttachmentInspectionModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        image: json['image'] ?? '',
        imageUrl: json['image_url'] ?? '',
      );

  final String id;
  final String code;
  final String image;
  final String imageUrl;

  Map<String, dynamic> toJson() {
    final tempData = <String, dynamic>{};

    tempData['id'] = id;
    tempData['code'] = code;
    tempData['image'] = image;
    tempData['image_url'] = imageUrl;

    return tempData;
  }

  @override
  String toString() {
    return 'AttachmentInspectionModel(id: $id, code: $code, image_url: $imageUrl)';
  }
}
