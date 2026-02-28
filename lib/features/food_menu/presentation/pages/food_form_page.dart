import 'package:flutter/material.dart';
import '../../data/food_model.dart';

class FoodFormPage extends StatefulWidget {
  final FoodModel? initial;
  final bool lockId;

  const FoodFormPage({super.key, this.initial, this.lockId = false});

  @override
  State<FoodFormPage> createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _imageCtrl;

  @override
  void initState() {
    super.initState();
    final f = widget.initial;
    _idCtrl = TextEditingController(text: f?.id.toString() ?? '');
    _nameCtrl = TextEditingController(text: f?.nombre ?? '');
    _priceCtrl = TextEditingController(text: f?.precio.toString() ?? '');
    _imageCtrl = TextEditingController(text: f?.imagen ?? '');
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final id = int.tryParse(_idCtrl.text.trim());
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    final image = _imageCtrl.text.trim();

    if (id == null || id <= 0 || name.isEmpty || price == null || price <= 0 || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos con valores válidos.')),
      );
      return;
    }

    Navigator.pop(
      context,
      FoodModel(id: id, nombre: name, precio: price, imagen: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar comida' : 'Agregar comida'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _idCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ID (entero)'),
              enabled: !(isEdit || widget.lockId),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageCtrl,
              decoration: const InputDecoration(labelText: 'URL de imagen'),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}