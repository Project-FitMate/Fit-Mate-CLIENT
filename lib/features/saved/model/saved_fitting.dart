import 'package:fit_mate_client/features/result/model/result_item.dart';

/// One saved virtual-fitting result: the generated image plus the items worn.
class SavedFitting {
  const SavedFitting({
    required this.id,
    required this.createdAt,
    required this.imageBase64,
    required this.items,
  });

  final String id;
  final DateTime createdAt;
  final String imageBase64;
  final List<ResultItem> items;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'imageBase64': imageBase64,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory SavedFitting.fromJson(Map<String, dynamic> json) => SavedFitting(
        id: (json['id'] ?? '') as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          (json['createdAt'] as num?)?.toInt() ?? 0,
        ),
        imageBase64: (json['imageBase64'] ?? '') as String,
        items: ((json['items'] as List?) ?? const [])
            .map((e) => ResultItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
