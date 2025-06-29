import 'dart:convert';
class Horse {
  final String id;
  final String name;
  final String breed;
  final int? knownAge;
  final String color;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> analysisIds;

  Horse({
    required this.id,
    required this.name,
    required this.breed,
    this.knownAge,
    required this.color,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.analysisIds,
  });

  Horse copyWith({
    String? name,
    String? breed,
    int? knownAge,
    String? color,
    String? notes,
    DateTime? updatedAt,
    List<String>? analysisIds,
  }) {
    return Horse(
      id: id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      knownAge: knownAge ?? this.knownAge,
      color: color ?? this.color,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      analysisIds: analysisIds ?? this.analysisIds,
    );
  }

  factory Horse.fromJson(Map<String, dynamic> json) => Horse(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
        knownAge: json['knownAge'],
        color: json['color'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        analysisIds: List<String>.from(json['analysisIds'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'breed': breed,
        'knownAge': knownAge,
        'color': color,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'analysisIds': analysisIds,
      };

  factory Horse.fromJsonString(String source) =>
      Horse.fromJson(jsonDecode(source));

  String toJsonString() => jsonEncode(toJson());

  static Horse createNew({
    required String name,
    required String breed,
    int? knownAge,
    required String color,
    required String notes,
  }) {
    final now = DateTime.now();
    return Horse(
      id: _generateId(),
      name: name,
      breed: breed,
      knownAge: knownAge,
      color: color,
      notes: notes,
      createdAt: now,
      updatedAt: now,
      analysisIds: [],
    );
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
