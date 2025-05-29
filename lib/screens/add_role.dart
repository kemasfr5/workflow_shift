import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({super.key});

  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final _form = GlobalKey<FormState>();
  var isAdding = false;
  var _enteredRole = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      isAdding = true;
    });
    try {
      await FirebaseFirestore.instance.collection('role').add(
        {
          'title': _enteredRole,
        },
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'There is something wrong'),
        ),
      );
      setState(() {
        isAdding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Role'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Role Title'),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredRole = value!;
                },
              ),
              SizedBox(
                height: 20,
              ),
              if (isAdding) CircularProgressIndicator(),
              if (!isAdding)
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer),
                  child: Text(
                    'Submit',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
