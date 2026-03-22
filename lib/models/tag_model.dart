enum TagPlan { hours24, hours48, days7 }

extension TagPlanExt on TagPlan {
  String get label {
    switch (this) {
      case TagPlan.hours24: return '24 horas';
      case TagPlan.hours48: return '48 horas';
      case TagPlan.days7:   return '7 dias';
    }
  }
  String get price {
    switch (this) {
      case TagPlan.hours24: return 'R\$ 8,00';
      case TagPlan.hours48: return 'R\$ 15,00';
      case TagPlan.days7:   return 'R\$ 32,00';
    }
  }
  Duration get duration {
    switch (this) {
      case TagPlan.hours24: return const Duration(hours: 24);
      case TagPlan.hours48: return const Duration(hours: 48);
      case TagPlan.days7:   return const Duration(days: 7);
    }
  }
}

class TagModel {
  final String id;
  final String childName;
  final int childAge;
  final String responsiblePhone;
  final TagPlan plan;
  final DateTime createdAt;
  final DateTime expiresAt;

  TagModel({
    required this.id,
    required this.childName,
    required this.childAge,
    required this.responsiblePhone,
    required this.plan,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isActive => DateTime.now().isBefore(expiresAt);

  String get timeLeft {
    final diff = expiresAt.difference(DateTime.now());
    if (!isActive) return 'Expirada';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}h${m.toString().padLeft(2, '0')}min';
  }
}
