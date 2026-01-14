import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🏷️ Types de notes
enum NoteType {
  personnel,
  etudes,
  travail,
  eglise,
  idee,
  projet,
}

class NoteForm extends StatefulWidget {
  final Map<String, dynamic>? note;
  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late NoteType selectedType;
  bool hasChanged = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.note?['title'] ?? '');
    descriptionController =
        TextEditingController(text: widget.note?['description'] ?? '');

    selectedType = widget.note?['type'] ?? NoteType.personnel;

    titleController.addListener(_markChanged);
    descriptionController.addListener(_markChanged);
  }

  void _markChanged() {
    setState(() => hasChanged = true);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.note != null && !hasChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modifiez au moins un champ')),
      );
      return;
    }

    Navigator.pop(context, {
      'title': titleController.text,
      'description': descriptionController.text,
      'type': selectedType,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Nouvelle note' : 'Modifier la note',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field('Titre', titleController),
              _field('Description', descriptionController, maxLines: 5),

              const SizedBox(height: 16),

              DropdownButtonFormField<NoteType>(
                value: selectedType,
                decoration: _decoration('Type de note'),
                items: NoteType.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(
                      e.name.toUpperCase(),
                      style: GoogleFonts.inter(),
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedType = v!;
                    hasChanged = true;
                  });
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  widget.note == null
                      ? 'Créer la note'
                      : 'Valider la modification',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: _decoration(label),
        validator: (v) =>
            v == null || v.isEmpty ? 'Champ obligatoire' : null,
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
