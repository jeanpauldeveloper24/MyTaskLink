import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final List<Map<String, dynamic>> _contacts = [];
  final Set<int> _selected = {};

  final Map<ContactType, Color> typeColors = {
    ContactType.famille: Colors.blue,
    ContactType.ami: Colors.green,
    ContactType.collegue: Colors.orange,
    ContactType.collaborateur: Colors.purple,
    ContactType.employe: Colors.red,
    ContactType.connaissance: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_selected.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.person_add),
      ),

      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (_, i) {
          final c = _contacts[i];
          final color = typeColors[c['type']]!;

          return Card(
            color: color.withOpacity(0.12),
            margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Checkbox(
                value: _selected.contains(i),
                onChanged: (_) => setState(() {
                  _selected.contains(i)
                      ? _selected.remove(i)
                      : _selected.add(i);
                }),
              ),
              title: Text(c['name']),
              subtitle: Text('${c['phone']} • ${c['job']}'),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.sms),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editContact(c, i),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteOne(i),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContactForm()),
    );

    if (result != null) {
      setState(() => _contacts.add(result));
    }
  }

  Future<void> _editContact(Map<String, dynamic> c, int i) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactForm(contact: c)),
    );

    if (result != null) {
      setState(() => _contacts[i] = result);
    }
  }

  void _deleteOne(int i) {
    setState(() => _contacts.removeAt(i));
  }

  void _deleteSelected() {
    setState(() {
      _selected.toList()
        ..sort((a, b) => b.compareTo(a))
        ..forEach(_contacts.removeAt);
      _selected.clear();
    });
  }
}