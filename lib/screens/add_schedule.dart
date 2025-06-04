import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _form = GlobalKey<FormState>();
  final controller = MultiSelectController<String>();

  DateTime selectedDate = DateTime.now();
  List<String> selectedEmployees = [];
  String enteredNotes = '';
  var isAdding = false;

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
          .doc(selectedDate.toString())
          .set(
        {
          'date': selectedDate,
          'employees': selectedEmployees,
          'notes': enteredNotes,
        },
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
    var items = [
      DropdownItem(
        label: 'Kemas Fachir Raihan',
        value: 'Kemas Fachir Raihan',
      ),
      DropdownItem(
        label: 'Masayu Savira Amalia',
        value: 'Masayu Savira Amalia',
      ),
      DropdownItem(
        label: 'Febri Purnama',
        value: 'Febri Purnama',
      ),
      DropdownItem(
        label: 'Ahmad Suganda',
        value: 'Ahmad Suganda',
      ),
      DropdownItem(
        label: 'Steve Erawan',
        value: 'Steve Erawan',
      ),
      DropdownItem(
        label: 'Bambang Sutardjo',
        value: 'Bambang Sutardjo',
      ),
      DropdownItem(
        label: 'Erwin Sirajagukguk',
        value: 'Erwin Surajagukguk',
      ),
      DropdownItem(
        label: 'Vera Setiawati',
        value: 'Vera Setiawati',
      ),
    ];

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
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                MultiDropdown<String>(
                  items: items,
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
                    disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a value';
                    }
                    return null;
                  },
                  onSelectionChange: (selectedItems) {
                    debugPrint("OnSelectionChange: $selectedItems");
                    selectedEmployees = selectedItems;
                  },
                ),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text('Notes'),
                  ),
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
