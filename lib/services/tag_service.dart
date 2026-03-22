import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tag_model.dart';

class TagService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<TagModel> _tags = [];
  List<TagModel> get tags => _tags;
  bool _loading = false;
  bool get loading => _loading;

  Future<TagModel> generateTag({
    required String childName,
    required int childAge,
    required String responsiblePhone,
    required TagPlan plan,
    double? lat,
    double? lng,
  }) async {
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
      geradaLat: lat,
      geradaLng: lng,
    );

    try {
      await _db.collection('pulseiras').doc(id).set({
        'id': id,
        'childName': childName,
        'childAge': childAge,
        'responsiblePhone': responsiblePhone,
        'plan': plan.name,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(tag.expiresAt),
        'geradaLat': lat,
        'geradaLng': lng,
        'status': 'ativo',
        'scans': 0,
      });
      debugPrint('Tag salva no Firestore: $id');
    } catch (e) {
      debugPrint('Erro ao salvar no Firestore: $e');
    }

    _tags.insert(0, tag);
    notifyListeners();
    return tag;
  }

  Future<void> carregarTags() async {
    try {
      _loading = true;
      notifyListeners();

      final snap = await _db
          .collection('pulseiras')
          .orderBy('createdAt', descending: true)
          .get();

      _tags.clear();
      for (final doc in snap.docs) {
        final data = doc.data();
        final plan = TagPlan.values.firstWhere(
          (p) => p.name == data['plan'],
          orElse: () => TagPlan.hours24,
        );
        _tags.add(TagModel(
          id: data['id'] ?? doc.id,
          childName: data['childName'] ?? '',
          childAge: data['childAge'] ?? 0,
          responsiblePhone: data['responsiblePhone'] ?? '',
          plan: plan,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          expiresAt: (data['expiresAt'] as Timestamp).toDate(),
          geradaLat: data['geradaLat']?.toDouble(),
          geradaLng: data['geradaLng']?.toDouble(),
        ));
      }
    } catch (e) {
      debugPrint('Erro ao carregar tags: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> registrarScan({
    required String tagId,
    required double? lat,
    required double? lng,
  }) async {
    try {
      await _db.collection('pulseiras').doc(tagId).collection('scans').add({
        'tagId': tagId,
        'lat': lat,
        'lng': lng,
        'scannedAt': Timestamp.now(),
      });
      await _db.collection('pulseiras').doc(tagId).update({
        'scans': FieldValue.increment(1),
        'ultimoScanLat': lat,
        'ultimoScanLng': lng,
        'ultimoScanAt': Timestamp.now(),
      });
    } catch (e) {
      debugPrint('Erro ao registrar scan: $e');
    }
  }

  void deleteTag(String id) {
    _db.collection('pulseiras').doc(id).update({'status': 'deletado'});
    _tags.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
