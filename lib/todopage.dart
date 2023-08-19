import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String type = '';
  String category = '';
  String formattedTime = '';
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('Create',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4)),
              const SizedBox(
                height: 8,
              ),
              const Text('New Todo',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4)),
              const SizedBox(
                height: 30,
              ),
              const Text('Task Title',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                  ),
                  iconColor: Colors.black87,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  labelText: 'Task Title',
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Task Type',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  titleSelect('Important', 0xff2664fa),
                  const SizedBox(
                    width: 20,
                  ),
                  titleSelect('Planned', 0xff2bc8d9),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Description',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.only(left: 20, top: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Description',
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: formattedTime),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[900],
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                          ),
                          iconColor: Colors.black87,
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: 'Select Time'),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (selectedTime != null) {
                          onTimeChanged(selectedTime);
                        }
                      },
                      child: const Icon(
                        Icons.timer_sharp,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('category',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2)),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                runSpacing: 10,
                children: [
                  categorySelect('food', 0xffff6d6e),
                  const SizedBox(
                    width: 20,
                  ),
                  categorySelect('workout', 0xfff29732),
                  const SizedBox(
                    width: 20,
                  ),
                  categorySelect('work', 0xff6557ff),
                  const SizedBox(
                    width: 20,
                  ),
                  categorySelect('Design', 0xff234ebd),
                  const SizedBox(
                    width: 20,
                  ),
                  categorySelect('Run', 0xff2bc8d9),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
             InkWell(
  onTap: () async {
    final currentUserId = FirebaseAuth.instance.currentUser;
    if (currentUserId != null) {
      final todoData = {
        "title": _titlecontroller.text,
        "task": type,
        "Category": category,
        "Description": _descriptionController.text,
        "selectedTime": formattedTime,
      };

      // Add the todo item to the user's subcollection directly
      final userTodosRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId.uid)
          .collection('todos');

      final newTodoRef = await userTodosRef.add(todoData);
      // ignore: unused_local_variable
      String newTodoId = newTodoRef.id;
      setState(() {});
      
      Navigator.pop(context);
    }
  },


                child: Card(
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 30, 103, 212),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Todo',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.add)
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget titleSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
              fontSize: 17, color: type == label ? Colors.black : Colors.white),
        ),
        elevation: 10,
        backgroundColor: type == label ? Colors.white : Color(color),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
              fontSize: 17,
              color: category == label ? Colors.black : Colors.white),
        ),
        elevation: 10,
        backgroundColor: category == label ? Colors.white : Color(color),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
      formattedTime = newTime.format(context);
    });
  }
}
