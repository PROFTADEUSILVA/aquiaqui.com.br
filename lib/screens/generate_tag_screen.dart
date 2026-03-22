import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/tag_service.dart';
import '../models/tag_model.dart';

class GenerateTagScreen extends StatefulWidget {
  const GenerateTagScreen({super.key});
  @override
  State<GenerateTagScreen> createState() => _GenerateTagScreenState();
}

class _GenerateTagScreenState extends State<GenerateTagScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _racaCtrl = TextEditingController();
  TagPlan _plano = TagPlan.hours24;
  TagModel? _tagGerada;
  int _step = 0;
  String _genero = 'menina';
  String _tipo = 'crianca';
  String _especie = 'cachorro';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _phoneCtrl.dispose();
    _racaCtrl.dispose();
    super.dispose();
  }

  String get _icone {
    if (_tipo == 'crianca') {
      return _genero == 'menino' ? 'menino' : 'menina';
    } else {
      return _especie;
    }
  }

  String get _whatsappLink {
    final phone = _tagGerada?.responsiblePhone.replaceAll(RegExp(r'\D'), '') ?? '';
    final name = Uri.encodeComponent(_tagGerada?.childName ?? '');
    final age = _tagGerada?.childAge.toString() ?? '';
    final id = _tagGerada?.id ?? '';
    return 'https://proftadeusilva.github.io/aquiaqui.com.br?id=$id&name=$name&age=$age&phone=$phone&tipo=$_tipo&icon=$_icone';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova pulseira'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _step == 1
              ? setState(() => _step = 0)
              : Navigator.of(context).pop(),
        ),
      ),
      body: _step == 0 ? _buildForm() : _buildQr(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF1D9E75), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: 4),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)))),
          ]),
          const SizedBox(height: 24),
          const Text('O que deseja cadastrar?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tipo = 'crianca'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _tipo == 'crianca' ? const Color(0xFF1D9E75).withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _tipo == 'crianca' ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: _tipo == 'crianca' ? 2 : 1),
                    ),
                    child: Column(children: [
                      const Text('👶', style: TextStyle(fontSize: 36)),
                      const SizedBox(height: 6),
                      Text('Criança', style: TextStyle(fontWeight: FontWeight.w700, color: _tipo == 'crianca' ? const Color(0xFF1D9E75) : Colors.black87)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _tipo = 'pet'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _tipo == 'pet' ? const Color(0xFF1D9E75).withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _tipo == 'pet' ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: _tipo == 'pet' ? 2 : 1),
                    ),
                    child: Column(children: [
                      const Text('🐾', style: TextStyle(fontSize: 36)),
                      const SizedBox(height: 6),
                      Text('Pet', style: TextStyle(fontWeight: FontWeight.w700, color: _tipo == 'pet' ? const Color(0xFF1D9E75) : Colors.black87)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (_tipo == 'crianca') ...[
            const Text('Dados da criança', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _campo('Nome da criança', _nameCtrl, Icons.child_care, type: TextInputType.name),
            const SizedBox(height: 14),
            _campo('Idade', _ageCtrl, Icons.cake_outlined, type: TextInputType.number),
            const SizedBox(height: 14),
            const Text('Gênero', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _genero = 'menina'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _genero == 'menina' ? const Color(0xFF1D9E75).withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _genero == 'menina' ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: _genero == 'menina' ? 2 : 1),
                      ),
                      child: const Column(children: [
                        Text('👧', style: TextStyle(fontSize: 32)),
                        SizedBox(height: 4),
                        Text('Menina', style: TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _genero = 'menino'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _genero == 'menino' ? const Color(0xFF1D9E75).withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _genero == 'menino' ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: _genero == 'menino' ? 2 : 1),
                      ),
                      child: const Column(children: [
                        Text('👦', style: TextStyle(fontSize: 32)),
                        SizedBox(height: 4),
                        Text('Menino', style: TextStyle(fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            const Text('Dados do pet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _campo('Nome do pet', _nameCtrl, Icons.pets, type: TextInputType.name),
            const SizedBox(height: 14),
            _campo('Raça', _racaCtrl, Icons.info_outline),
            const SizedBox(height: 14),
            const Text('Espécie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _especieCard('cachorro', '🐶', 'Cachorro'),
                _especieCard('gato', '🐱', 'Gato'),
                _especieCard('passaro', '🐦', 'Pássaro'),
                _especieCard('outro', '🐾', 'Outro'),
              ],
            ),
          ],

          const SizedBox(height: 14),
          _campo('Seu WhatsApp (DDD + 9 dígitos)', _phoneCtrl, Icons.phone_outlined, type: TextInputType.phone),
          const SizedBox(height: 6),
          const Text('Ex: 71999990000', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 24),
          const Text('Plano da pulseira', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...TagPlan.values.map((p) => _PlanCard(plan: p, selected: _plano == p, onTap: () => setState(() => _plano = p))),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _gerar,
              icon: const Icon(Icons.qr_code),
              label: const Text('Gerar QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _especieCard(String especie, String emoji, String label) {
    final selected = _especie == especie;
    return GestureDetector(
      onTap: () => setState(() => _especie = especie),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1D9E75).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: selected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? const Color(0xFF1D9E75) : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildQr() {
    final tag = _tagGerada!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF1D9E75), borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: 4),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFF1D9E75), borderRadius: BorderRadius.circular(2)))),
          ]),
          const SizedBox(height: 24),
          const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 52),
          const SizedBox(height: 12),
          const Text('Pulseira gerada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('ID: ${tag.id}', style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'monospace')),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              children: [
                QrImageView(data: _whatsappLink, version: QrVersions.auto, size: 230, backgroundColor: Colors.white),
                const SizedBox(height: 16),
                Text(tag.childName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text(
                  _tipo == 'crianca' ? '${tag.childAge} anos  •  ${tag.plan.label}' : '${_racaCtrl.text}  •  ${tag.plan.label}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(20)),
                  child: Text('Válida por ${tag.plan.label}', style: const TextStyle(color: Color(0xFF1D9E75), fontWeight: FontWeight.w500, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Color(0xFF185FA5), size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('Quando alguém escanear, abre a página Aqui com localização automática.', style: TextStyle(color: Color(0xFF0C447C), fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFFAEEDA), borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.print_outlined, color: Color(0xFF633806), size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('Imprima, plastifique e coloque na pulseira.', style: TextStyle(color: Color(0xFF633806), fontSize: 13))),
            ]),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _step = 0;
                    _nameCtrl.clear();
                    _ageCtrl.clear();
                    _phoneCtrl.clear();
                    _racaCtrl.clear();
                    _tagGerada = null;
                    _genero = 'menina';
                    _tipo = 'crianca';
                    _especie = 'cachorro';
                  }),
                  icon: const Icon(Icons.add),
                  label: const Text('Nova pulseira'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Início'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D9E75), foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _gerar() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }
    final tag = context.read<TagService>().generateTag(
      childName: _nameCtrl.text.trim(),
      childAge: int.tryParse(_ageCtrl.text) ?? 0,
      responsiblePhone: _phoneCtrl.text.trim(),
      plan: _plano,
    );
    setState(() { _tagGerada = tag; _step = 1; });
  }

  Widget _campo(String label, TextEditingController ctrl, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final TagPlan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1D9E75).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF1D9E75) : Colors.grey.shade200, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(
              plan == TagPlan.hours24 ? Icons.wb_sunny_outlined : plan == TagPlan.hours48 ? Icons.weekend_outlined : Icons.luggage_outlined,
              color: selected ? const Color(0xFF1D9E75) : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(plan.label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? const Color(0xFF1D9E75) : Colors.black87))),
            Text(plan.price, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: selected ? const Color(0xFF1D9E75) : Colors.black87)),
            if (selected) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 20)),
          ],
        ),
      ),
    );
  }
}
