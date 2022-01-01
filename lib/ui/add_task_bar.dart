import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/controllers/task_controller.dart';
import 'package:flutter_to_do_app/models/task.dart';
import 'package:flutter_to_do_app/ui/theme.dart';
import 'package:flutter_to_do_app/ui/widgets/button.dart';
import 'package:flutter_to_do_app/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [
    5, 10, 15, 20, 25, 30
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Monthly",
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        margin: EdgeInsets.only(right: 5),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your Note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color: Colors.grey),
                onPressed: () {
                  _getDateFromUser();
                },
             ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey
                          ),
                        ),
                      ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                ],
              ) ,
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(width: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int Value){
                    return DropdownMenuItem<String>(
                    value: Value.toString(),
                    child: Text(Value.toString())
                    );
                  }
                ).toList()),
              ),
              MyInputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(width: 0,),
                    onChanged: (String? newValue){
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items: repeatList.map<DropdownMenuItem<String>>((String? Value){
                      return DropdownMenuItem<String>(
                          value: Value,
                          child: Text(Value!,
                            style: TextStyle(color: Colors.grey))
                      );
                    }
                    ).toList()),
              ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: ()=> _validateDate())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate(){
      if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
        _addTaskToDB();
          Get.back();
      } else {
        Get.snackbar("Required", "All Fields is required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: Icon(Icons.warning_amber_rounded, color: Colors.red,)
        );
      }
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0
        )
    );
    print("My id is "+"$value");
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,
        ),
        SizedBox(width: 8.0),
        Wrap(
          children: List<Widget>.generate(
              3,
                  (int index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedColor=index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                      child: _selectedColor==index?Icon(
                          Icons.done, size: 16
                      ):Container(),
                    ),
                  ),
                );
              }
          ),
        )
      ],
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white: Colors.black
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/profile.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }

  _getDateFromUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2100)
    );

    if (_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {

    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime==null){
      print("Time canceld");
    }else if (isStartTime==true){
      setState(() {
        _startTime = _formatedTime;
      });
    }else if(isStartTime==false){
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]))
    );
  }

}
