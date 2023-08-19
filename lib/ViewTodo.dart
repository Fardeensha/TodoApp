import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewTodo extends StatefulWidget {
  const ViewTodo({super.key, required this.todoData, required this.id});
  final Map<String, dynamic> todoData;
  final String id;

  @override
  State<ViewTodo> createState() => _ViewTodoState();
}

class _ViewTodoState extends State<ViewTodo> {
  late TextEditingController _titlecontroller;
  late TextEditingController _descriptionController;
  late String type;
  late String category;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title = widget.todoData["title"] ?? "Hey There";
    _titlecontroller = TextEditingController(text: title);
    _descriptionController = TextEditingController(text: widget.todoData["Description"]);
    type = widget.todoData["task"];
    category = widget.todoData["Category"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      edit = !edit;
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: edit ? Colors.red : Colors.white,
                  )),
            ],
          ),
          IconButton(
            onPressed: () async {
              final currentUserId = FirebaseAuth.instance.currentUser;
              if (currentUserId != null) {
                final userTodosRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUserId.uid)
                    .collection('todos');

                // Delete the todo item from the user's subcollection
                await userTodosRef.doc(widget.id).delete();

                // After deleting, you can navigate back to the previous page
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          )
        ],
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
              Text(edit ? "Editing" : 'View',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4)),
              const SizedBox(
                height: 8,
              ),
              const Text('Your Todo',
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
                height: 10,
              ),
              TextField(
                controller: _titlecontroller,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                enabled: edit,
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
                height: 10,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: edit
                        ? Border.all(
                            color: Colors.white,
                          )
                        : null),
                child: TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    enabled: edit,
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
                      final userTodosRef = FirebaseFirestore.instance
                          .collection('users') 
                          .doc(currentUserId.uid)
                          .collection('todos');

                
                      await userTodosRef.doc(widget.id).update({
                        "title": _titlecontroller.text,
                        "task": type,
                        "Category": category,
                        "Description": _descriptionController.text,
                        
                      });
                      setState(() {});
                      Navigator.pop(context);
                    }
                    
                  },
                  child: edit
                      ? Card(
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
                                  'Update Todo',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.add)
                              ],
                            ),
                          ))
                      : Container()),
            ],
          ),
        ),
      )),
    );
  }

  Widget titleSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
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
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
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
}
