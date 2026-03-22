import 'package:flutter/foundation.dart';
import '../models/tag_model.dart';

class TagService extends ChangeNotifier {
  final List<TagModel> _tags = [];
  List<TagModel> get tags => _tags;

  TagModel generateTag({
    required String childName,
    required int childAge,
    required String responsiblePhone,
    required TagPlan plan,
  }) {
    final id = 'ST-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final now = DateTime.now();
    final tag = TagModel(
      id: id,
      childName: childName,
      childAge: childAge,
      responsiblePhone: responsiblePhone,
      plan: plan,
      createdAt: now,
      expiresAt: now.add(plan.duration),
    );
    _tags.insert(0, tag);
    notifyListeners();
    return tag;
  }

  void deleteTag(String id) {
    _tags.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
