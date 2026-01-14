import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🔹 Classification
enum TaskType {
  sport,
  etudes,
  eglise,
  travail,
  personnel,
  courses,
  sante,
  projet,
}

enum TaskPriority {
  tresImportant,
  important,
  aFaire,
}

/// 🔹 Fréquence
enum RepeatType {
  daily,
  weekly,
  specificDate,
  monthly,
  yearly,
}

class TaskForm extends StatefulWidget {
  final Map<String, dynamic>? task;
  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  late TaskType selectedType;
  late TaskPriority selectedPriority;
  bool reminder = false;
  bool hasChanged = false;

  /// 🔁 Fréquence
  RepeatType repeatType = RepeatType.daily;
  Set<int> selectedDays = {};
  List<TimeOfDay> selectedTimes = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.task?['title'] ?? '');
    descriptionController =
        TextEditingController(text: widget.task?['description'] ?? '');

    selectedType = widget.task?['type'] ?? TaskType.personnel;
    selectedPriority = widget.task?['priority'] ?? TaskPriority.aFaire;
    reminder = widget.task?['reminder'] ?? false;

    titleController.addListener(_markChanged);
    descriptionController.addListener(_markChanged);
  }

  void _markChanged() {
    setState(() => hasChanged = true);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ajoutez au moins une heure')),
      );
      return;
    }

    if (widget.task != null && !hasChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modifiez au moins un champ')),
      );
      return;
    }

    Navigator.pop(context, {
      'title': titleController.text,
      'description': descriptionController.text,
      'type': selectedType,
      'priority': selectedPriority,
      'reminder': reminder,
      'frequency': {
        'repeat': repeatType.name,
        'days': selectedDays.toList(),
        'times': selectedTimes
            .map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}')
            .toList(),
        'date': selectedDate?.toIso8601String(),
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Nouvelle tâche' : 'Modifier la tâche',
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
              _field('Description', descriptionController),

              const SizedBox(height: 12),

              /// 🔁 Type de répétition
              DropdownButtonFormField<RepeatType>(
                value: repeatType,
                decoration: _decoration('Répétition'),
                items: RepeatType.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase(),
                        style: GoogleFonts.inter()),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    repeatType = v!;
                    hasChanged = true;
                  });
                },
              ),

              /// 📅 Jours (hebdomadaire)
              if (repeatType == RepeatType.weekly) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: List.generate(7, (i) {
                    return FilterChip(
                      label: Text(days[i]),
                      selected: selectedDays.contains(i),
                      onSelected: (v) {
                        setState(() {
                          v ? selectedDays.add(i) : selectedDays.remove(i);
                          hasChanged = true;
                        });
                      },
                    );
                  }),
                ),
              ],

              /// 📆 Date précise
              if (repeatType == RepeatType.specificDate) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                        hasChanged = true;
                      });
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? 'Choisir une date'
                        : selectedDate!
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                  ),
                ),
              ],

              const SizedBox(height: 12),

              /// ⏰ Heures
              ElevatedButton.icon(
                icon: const Icon(Icons.access_time),
                label: const Text('Ajouter une heure'),
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedTimes.add(time);
                      hasChanged = true;
                    });
                  }
                },
              ),

              Wrap(
                spacing: 8,
                children: selectedTimes.map((t) {
                  return Chip(
                    label: Text(t.format(context)),
                    onDeleted: () {
                      setState(() {
                        selectedTimes.remove(t);
                        hasChanged = true;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              /// 🏷️ Type
              DropdownButtonFormField<TaskType>(
                value: selectedType,
                decoration: _decoration('Type de tâche'),
                items: TaskType.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase(),
                        style: GoogleFonts.inter()),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedType = v!;
                    hasChanged = true;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// ⚠️ Importance
              DropdownButtonFormField<TaskPriority>(
                value: selectedPriority,
                decoration: _decoration('Importance'),
                items: TaskPriority.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase(),
                        style: GoogleFonts.inter()),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedPriority = v!;
                    hasChanged = true;
                  });
                },
              ),

              SwitchListTile(
                title:
                    Text('Activer le rappel', style: GoogleFonts.inter()),
                value: reminder,
                onChanged: (v) {
                  setState(() {
                    reminder = v;
                    hasChanged = true;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  widget.task == null
                      ? 'Créer la tâche'
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

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
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
