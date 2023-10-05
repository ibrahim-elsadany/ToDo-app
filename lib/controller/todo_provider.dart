import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/todo_dm.dart';

class TodoProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<TodoDm> todos = [];
  late DateTime selectedTime = DateTime.now();

  void getDataFromFirestore() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('tasks')
        .orderBy('selectedTime')
        .get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    todos = docs.map((docSnapShot) {
      Map json = docSnapShot.data() as Map;
      return TodoDm(
          json['title'],
          json['description'],
          DateTime.fromMillisecondsSinceEpoch(json['selectedTime']),
          json['isDone'],
          docSnapShot.id);
    }).toList();

    // Filter tasks based on selected time
    todos = todos.where((todo) {
      return todo.date.year == selectedTime.year &&
          todo.date.month == selectedTime.month &&
          todo.date.day == selectedTime.day;
    }).toList();

    notifyListeners();
  }
}