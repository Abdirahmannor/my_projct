class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String category; // 'school', 'project', 'personal'
  final String filePath;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String? url;
  final List<String> tags;
  final bool isFavorite;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.filePath,
    required this.createdAt,
    required this.modifiedAt,
    this.url,
    this.tags = const [],
    this.isFavorite = false,
  });
}

enum ResourceType { document, image, video, link, note, other }
