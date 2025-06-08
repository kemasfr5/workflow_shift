import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final List<String> shifts = ['Shift 1', 'Shift 2', 'Shift 3'];
  late DateTime selectedDate;
  var selectedShift = '';
  var _isSelectedShift = false;
  List<DropdownItem<String>> userItems = [];
  List<String> selectedEmployees = [];
  String enteredNotes = '';
  var isAdding = false;

  final TextEditingController _notesController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final controller = MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    loadUsers().then(
      (_) {
        _getInputByDate();
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _getInputByDate() async {
    final doc = await FirebaseFirestore.instance
        .collection('schedule')
        .doc('$selectedDate $selectedShift')
        .get();
    final docMap = doc.data();

    controller.clearAll();
    if (docMap != null) {
      controller.selectWhere(
        (element) =>
            docMap['employees'].contains(element.value) &&
            docMap['shift'] == selectedShift,
      );
      _notesController.text = docMap['notes'];

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Selected date and shift is already inputed. It will update previous data.'),
        ),
      );
    } else {
      _notesController.text = '';
    }
  }

  Future<void> loadUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      userItems = snapshot.docs.map((doc) {
        final String name = doc.data()['name'];
        return DropdownItem<String>(label: name, value: name);
      }).toList();
    });
  }

  void submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isAdding = true;
    });
    _form.currentState!.save();
    try {
      await FirebaseFirestore.instance
          .collection('schedule')
          .doc('$selectedDate $selectedShift')
          .set(
        {
          'date': selectedDate,
          'shift': selectedShift,
          'employees': selectedEmployees,
          'notes': enteredNotes,
        },
        SetOptions(merge: true),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      setState(() {
        isAdding = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'There is something wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Schedule'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: TextButton.icon(
                    label: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    icon: Icon(
                      Icons.calendar_today,
                      size: 25,
                    ),
                    onPressed: () async {
                      await _selectDate(context);
                      _isSelectedShift ? _getInputByDate() : null;
                    },
                  ),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(label: Text('Shift')),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please choose shift';
                    }
                    return null;
                  },
                  items: [
                    for (var shift in shifts)
                      DropdownMenuItem<String>(
                        value: shift,
                        child: Text(shift),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedShift = value!;
                      _isSelectedShift = true;
                      _getInputByDate();
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                userItems.isEmpty
                    ? CircularProgressIndicator()
                    : MultiDropdown<String>(
                        items: userItems,
                        controller: controller,
                        enabled: true,
                        searchEnabled: true,
                        chipDecoration: const ChipDecoration(
                          backgroundColor: Colors.yellow,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Employees',
                          hintStyle: const TextStyle(color: Colors.black87),
                          // prefixIcon: const Icon(CupertinoIcons.flag),
                          showClearIcon: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        dropdownDecoration: const DropdownDecoration(
                          marginTop: 2,
                          maxHeight: 500,
                          header: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Select employees from the list',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        dropdownItemDecoration: DropdownItemDecoration(
                          selectedIcon:
                              const Icon(Icons.check_box, color: Colors.green),
                          disabledIcon:
                              Icon(Icons.lock, color: Colors.grey.shade300),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a value';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          // debugPrint("OnSelectionChange: $selectedItems");
                          selectedEmployees = selectedItems;
                        },
                      ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text('Notes'),
                  ),
                  controller: _notesController,
                  onSaved: (notes) {
                    enteredNotes = notes ?? '';
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (!isAdding)
                  ElevatedButton(
                    onPressed: submit,
                    child: Text('Submit'),
                  ),
                if (isAdding) CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
