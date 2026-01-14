import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ContactType {
  famille,
  ami,
  collegue,
  collaborateur,
  employe,
  connaissance,
}

class ContactForm extends StatefulWidget {
  final Map<String, dynamic>? contact;

  const ContactForm({super.key, this.contact});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController jobCtrl;

  ContactType _type = ContactType.ami;

  bool _modified = false;

  @override
  void initState() {
    super.initState();

    nameCtrl =
        TextEditingController(text: widget.contact?['name'] ?? '');
    emailCtrl =
        TextEditingController(text: widget.contact?['email'] ?? '');
    phoneCtrl =
        TextEditingController(text: widget.contact?['phone'] ?? '');
    jobCtrl =
        TextEditingController(text: widget.contact?['job'] ?? '');

    _type = widget.contact?['type'] ?? ContactType.ami;

    for (var c in [nameCtrl, emailCtrl, phoneCtrl, jobCtrl]) {
      c.addListener(() => _modified = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null
              ? 'Nouveau contact'
              : 'Modifier contact',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field('Nom', nameCtrl),
              _field('Email', emailCtrl,
                  keyboard: TextInputType.emailAddress),
              _field('Téléphone', phoneCtrl,
                  keyboard: TextInputType.phone),
              _field('Profession', jobCtrl),
              const SizedBox(height: 12),

              DropdownButtonFormField<ContactType>(
                value: _type,
                items: ContactType.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _type = v!;
                    _modified = true;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Type de contact'),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submit,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label),
        validator: (v) =>
            v == null || v.isEmpty ? 'Champ requis' : null,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.contact != null && !_modified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modifiez au moins un champ')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': nameCtrl.text,
      'email': emailCtrl.text,
      'phone': phoneCtrl.text,
      'job': jobCtrl.text,
      'type': _type,
      'createdAt':
          widget.contact?['createdAt'] ?? DateTime.now(),
    });
  }
}