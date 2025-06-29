import 'dart```nvert';

class Horse {
  final String id;
  final String name;```final String breed;
  final int? knownAge;```final String color;
  final String notes;
  final DateTime createdAt``` final DateTime updatedAt``` final List<String> analys```ds;

  Horse({
    required this.id,
    required this.name,
    require```his.breed,
    this.```wnAge,
    required this```lor,
    required this.```es,
    required this.createdAt,```  required this.updatedAt,
    required this```alysisIds,
  });

  Horse copyWith({
    String? i```    String? name,
    String? bree```    int? knownAge```   String? color,```  String? notes,
    DateTime? createdAt```   DateTime? updatedAt,
    List```ring>? analysisIds,
  }) {
    return Horse(
      id: id ?? this.id,```    name: name ?? this.name,
      bree```breed ?? this.breed,
      knownAge```nownAge ?? this.kn```Age,
      color: color ?? this.color```     notes: notes ?? this.notes,```    createdAt: createdAt``` this.createdAt,
      updatedAt```pdatedAt ?? this.updatedAt,```    analysisIds: analysisIds``` this.analysisIds,
    );
  }

  Map<String, dynamic> toJson```{
    return {
      'id': i```      'name': name,```    'breed': breed,```    'knownAge': known```,
      'color': color```     'notes': notes,
      'cre```dAt': createdAt.to```8601String(),
      'updatedAt': updatedAt```Iso8601String(),
      'analys```ds': analysisIds,
    };
  }

  factory Horse.fromJson(Map<String```ynamic> json) {
    return Horse(
      id: json```d'] as String,
      name: json```ame'] as String,
      breed: json['breed'] as String```     knownAge: json```nownAge'] as int?,```    color: json['color'] as String,
      notes: json```otes'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String```      updatedAt: DateTime.parse(json['updatedAt'] as String),
      analysisIds: List<String>.from```on['analysisIds'] as List),
    );
  }

  String toJson```ing() => jsonEncode(toJson());

  factory Horse.fromJson```ing(String source) =>
      Horse.fromJson(jsonDecode(source) as Map<String```ynamic>);

  @override```String toString() {
    return 'Horse```: $id, name:```ame, breed: $breed,```ownAge: $knownAge```
           'color: $```or, notes: $notes, cre```dAt: $createdAt,```           'up```edAt: $updatedAt,```alysisIds: $analysisIds```
  }

  @override
  bool operator ==(Object other) {
    if (identical```is, other)) return true;```  return other is Horse &&```her.id == id;
  }

  @override```int get hashCode => id.```hCode;
  
  static```rse createNew({
    required String name,
    required String breed,
    int?```ownAge,
    required String```lor,
    required String notes,```}) {
    final now = DateTime.now();
    return```rse(
      id: _```erateId(),
      name: name```     breed: breed,
      knownAge```nownAge,
      color```olor,
      notes: notes```     createdAt: now```     updatedAt: now```     analysisIds: [],
    );
  }

  static String _generateI``` {
    final timestamp = DateTime.now```millisecondsSinceEpoch;```  final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'horse_${timestamp}_$random';
  }
}
