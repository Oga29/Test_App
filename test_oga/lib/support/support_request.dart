class SupportRequest {
  final int id;
  final String message;
  final String createdAt;
  final List<String> images;
  final List<String> documents;

  SupportRequest({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.images,
    required this.documents,
  });

  factory SupportRequest.fromJson(Map<String, dynamic> json) {
    return SupportRequest(
      id: json['id'],
      message: json['message'],
      createdAt: json['created_at'],
      images: List<String>.from(json['images']),
      documents: List<String>.from(json['documents']),
    );
  }
}
