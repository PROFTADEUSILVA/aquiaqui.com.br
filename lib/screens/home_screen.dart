import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tag_service.dart';
import '../models/tag_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<TagService>();
    final ativas = service.tags.where((t) => t.isActive).toList();
    final expiradas = service.tags.where((t) => !t.isActive).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: const Color(0xFF1D9E75),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.child_care, color: Colors.white, size: 28),
                          SizedBox(width: 8),
                          Text('SafeTag',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${ativas.length} pulseira${ativas.length != 1 ? 's' : ''} ativa${ativas.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Botão gerar
                Card(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/gerar'),
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFE1F5EE),
                            child: Icon(Icons.add, color: Color(0xFF1D9E75)),
                          ),
                          SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gerar nova pulseira',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                              Text('Criar QR Code para a criança',
                                  style: TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (ativas.isNotEmpty) ...[
                  const Text('Pulseiras ativas',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...ativas.map((tag) => _TagCard(tag: tag)),
                  const SizedBox(height: 20),
                ],

                if (expiradas.isNotEmpty) ...[
                  const Text('Histórico',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 10),
                  ...expiradas.map((tag) => _TagCard(tag: tag, expirada: true)),
                ],

                if (service.tags.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        const Icon(Icons.child_care, size: 72, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Nenhuma pulseira ainda',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        const Text('Gere a primeira pulseira para rastrear sua criança.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed('/gerar'),
                          icon: const Icon(Icons.add),
                          label: const Text('Gerar pulseira'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D9E75),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/gerar'),
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nova pulseira'),
      ),
    );
  }
}

class _TagCard extends StatelessWidget {
  final TagModel tag;
  final bool expirada;
  const _TagCard({required this.tag, this.expirada = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: expirada ? Colors.grey.shade100 : const Color(0xFFE1F5EE),
              child: Icon(Icons.child_care,
                  color: expirada ? Colors.grey : const Color(0xFF1D9E75)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag.childName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text(tag.timeLeft,
                      style: TextStyle(
                          color: expirada ? Colors.grey : const Color(0xFF1D9E75),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  Text('ID: ${tag.id}',
                      style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            if (!expirada)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => context.read<TagService>().deleteTag(tag.id),
              ),
          ],
        ),
      ),
    );
  }
}
