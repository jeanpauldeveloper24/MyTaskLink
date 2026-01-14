import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form.dart';

/// 🔖 Types de notes
enum NoteType { personnel, etudes, travail, eglise, idee, projet }

/// 🔃 Options de tri
enum SortOption { recent, old, titleAZ, titleZA, type }

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final List<Map<String, dynamic>> _notes = [];
  final Set<int> _selectedIndexes = {};

  String _search = '';
  NoteType? _filterType;
  SortOption _sortOption = SortOption.recent;

  // 🎨 Couleurs par type
  final Map<NoteType, Color> typeColors = {
    NoteType.personnel: Colors.blue,
    NoteType.etudes: Colors.green,
    NoteType.travail: Colors.orange,
    NoteType.eglise: Colors.purple,
    NoteType.idee: Colors.amber,
    NoteType.projet: Colors.teal,
  };

  // 🔎 Notes filtrées + triées
  List<Map<String, dynamic>> get _filteredNotes {
    List<Map<String, dynamic>> list = _notes.where((note) {
      final matchesSearch =
          note['title'].toLowerCase().contains(_search.toLowerCase()) ||
          note['description'].toLowerCase().contains(_search.toLowerCase());

      final matchesType =
          _filterType == null || note['type'] == _filterType;

      return matchesSearch && matchesType;
    }).toList();

    switch (_sortOption) {
      case SortOption.recent:
        list.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
        break;
      case SortOption.old:
        list.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
        break;
      case SortOption.titleAZ:
        list.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case SortOption.titleZA:
        list.sort((a, b) => b['title'].compareTo(a['title']));
        break;
      case SortOption.type:
        list.sort(
          (a, b) => a['type'].index.compareTo(b['type'].index),
        );
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_selectedIndexes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          _searchBar(),
          _filters(),
          Expanded(child: _listView()),
        ],
      ),
    );
  }

  // 🔍 Barre de recherche
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Rechercher une note...',
          hintStyle: GoogleFonts.inter(),
        ),
        onChanged: (v) => setState(() => _search = v),
      ),
    );
  }

  // 🎛️ Filtres & tri
  Widget _filters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _dropdown<SortOption>(
            value: _sortOption,
            hint: 'Trier',
            items: SortOption.values,
            label: (v) => v.name,
            onChanged: (v) => setState(() => _sortOption = v!),
          ),
          _dropdown<NoteType>(
            value: _filterType,
            hint: 'Type',
            items: NoteType.values,
            label: (v) => v.name,
            onChanged: (v) => setState(() => _filterType = v),
          ),
        ],
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(label(e)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // 📋 Liste des notes
  Widget _listView() {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return Center(
        child: Text(
          'Aucune note',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (_, index) {
        final note = notes[index];
        final color = typeColors[note['type']]!;

        return Card(
          color: color.withOpacity(0.12),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Checkbox(
              value: _selectedIndexes.contains(index),
              onChanged: (_) => setState(() {
                _selectedIndexes.contains(index)
                    ? _selectedIndexes.remove(index)
                    : _selectedIndexes.add(index);
              }),
            ),
            title: Text(
              note['title'],
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              note['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 13),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editNote(note, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteOne(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ➕ Ajouter une note
  Future<void> _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NoteForm()),
    );

    if (result != null) {
      setState(() => _notes.add(result));
    }
  }

  // ✏️ Modifier
  Future<void> _editNote(Map<String, dynamic> note, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteForm(note: note)),
    );

    if (result != null) {
      setState(() => _notes[index] = result);
    }
  }

  // 🗑️ Suppression
  void _deleteOne(int index) {
    setState(() => _notes.removeAt(index));
  }

  void _deleteSelected() {
    setState(() {
      _selectedIndexes.toList()
        ..sort((a, b) => b.compareTo(a))
        ..forEach(_notes.removeAt);
      _selectedIndexes.clear();
    });
  }
}
