import 'dart:convert'; // Untuk encoding dan decoding JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  // Daftar todo yang akan disimpan
  List<List<dynamic>> toDoList = [];

  @override
  void initState() {
    super.initState();
    loadData(); // Memuat data dari SharedPreferences ketika app dimulai
  }

  // Fungsi untuk menyimpan todo list ke SharedPreferences
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(toDoList); // Ubah list menjadi JSON
    await prefs.setString('todoList', encodedData);
  }

  // Fungsi untuk memuat todo list dari SharedPreferences
  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('todoList');
    if (encodedData != null) {
      setState(() {
        toDoList = List<List<dynamic>>.from(
            jsonDecode(encodedData).map((item) => List<dynamic>.from(item)));
      });
    }
  }

  // Update checkbox status
  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
    saveData(); // Simpan data setiap kali ada perubahan
  }

  // Tambah task baru
  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        toDoList.add([_controller.text, false]);
        _controller.clear();
      });
      saveData(); // Simpan data setiap kali task baru ditambahkan
    }
  }

  // Hapus task
  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
    saveData(); // Simpan data setelah task dihapus
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text(
          'To Do List',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, index) {
          return TodoList(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (contex) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add new todo items',
                    filled: true,
                    fillColor: Colors.deepPurple.shade200,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(10), // Perbaikan di sini
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                      ),
                      borderRadius: BorderRadius.circular(10), // Perbaikan di sini
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: saveNewTask,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
