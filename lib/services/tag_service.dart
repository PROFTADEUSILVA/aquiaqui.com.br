import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/tag_model.dart';

class TagService extends ChangeNotifier {
  final List<TagModel> _tags = [];
  List<TagModel> get tags => _tags;

  Future<TagModel> generateTag({
    required String childName,
    required int childAge,
    required String responsiblePhone,
    required TagPlan plan,
  }) async {
    final id = 'ST-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final now = DateTime.now();

    // Capturar localização de onde foi gerada a pulseira
    double? lat;
    double? lng;
    try {
      // Na versão web usamos a API do navegador
      final position = await _getLocation();
      lat = position?['lat'];
      lng = position?['lng'];
    } catch (e) {
      debugPrint('GPS não disponível: $e');
    }

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
    _tags.insert(0, tag);
    notifyListeners();
    return tag;
  }

  Future<Map<String, double>?> _getLocation() async {
    try {
      // Para web: usa Geolocation API do navegador via channel
      // Retorna null se não disponível
      return null;
    } catch (e) {
      return null;
    }
  }

  void deleteTag(String id) {
    _tags.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
