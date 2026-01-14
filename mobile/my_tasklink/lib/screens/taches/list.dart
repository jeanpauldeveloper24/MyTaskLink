import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_tasklink/screens/taches/form.dart';


class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Map<String, dynamic>> tasks = [];
  final Set<int> selected = {};

  void _addTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TaskForm()),
    );
    if (result != null) {
      setState(() => tasks.add(result));
    }
  }

  void _editTask(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskForm(task: tasks[index]),
      ),
    );
    if (result != null) {
      setState(() => tasks[index] = result);
    }
  }

  void _deleteSelected() {
    setState(() {
      final indexes = selected.toList()..sort((a, b) => b.compareTo(a));
      for (final i in indexes) {
        tasks.removeAt(i);
      }
      selected.clear();
    });
  }

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.tresImportant:
        return Colors.red;
      case TaskPriority.important:
        return Colors.orange;
      case TaskPriority.aFaire:
        return Colors.blue;
    }
  }

  IconData _typeIcon(TaskType t) {
    switch (t) {
      case TaskType.sport:
        return Icons.fitness_center;
      case TaskType.etudes:
        return Icons.school;
      case TaskType.eglise:
        return Icons.church;
      case TaskType.travail:
        return Icons.work;
      case TaskType.personnel:
        return Icons.person;
      case TaskType.courses:
        return Icons.shopping_cart;
      case TaskType.sante:
        return Icons.favorite;
      case TaskType.projet:
        return Icons.flag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tâches (${tasks.length})',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (selected.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'Aucune tâche',
                style: GoogleFonts.inter(),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final task = tasks[i];
                final isSelected = selected.contains(i);

                return ListTile(
                  leading: Icon(
                    _typeIcon(task['type']),
                    color: _priorityColor(task['priority']),
                  ),
                  title: Text(
                    task['title'],
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${task['frequency']} • ${task['priority'].name}',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'view') {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(task['title']),
                            content: Text(task['description']),
                          ),
                        );
                      } else if (value == 'edit') {
                        _editTask(i);
                      } else if (value == 'delete') {
                        setState(() => tasks.removeAt(i));
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'view', child: Text('Voir')),
                      PopupMenuItem(value: 'edit', child: Text('Modifier')),
                      PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                    ],
                  ),
                  leadingAndTrailingTextStyle: GoogleFonts.inter(),
                  selected: isSelected,
                  onLongPress: () {
                    setState(() {
                      isSelected
                          ? selected.remove(i)
                          : selected.add(i);
                    });
                  },
                );
              },
            ),
    );
  }
}