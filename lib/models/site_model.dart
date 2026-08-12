class SiteModel {
  final String id;
  final String siteName;
  final String? location;

  SiteModel({
    required this.id,
    required this.siteName,
    this.location,
  });

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      id: map['id'] as String,
      siteName: map['siteName'] as String,
      location: map['location'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'siteName': siteName,
      'location': location,
    };
  }
}
