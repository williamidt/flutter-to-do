import 'package:flutter_to_do_app/db/db_helper.dart';
import 'package:flutter_to_do_app/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  // get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  // delete task
  void delete(Task task){
    DBHelper.delete(task);
  }

}