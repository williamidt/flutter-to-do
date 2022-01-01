import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_to_do_app/controllers/task_controller.dart';
import 'package:flutter_to_do_app/services/notification_services.dart';
import 'package:flutter_to_do_app/services/theme_services.dart';
import 'package:flutter_to_do_app/ui/add_task_bar.dart';
import 'package:flutter_to_do_app/ui/theme.dart';
import 'package:flutter_to_do_app/ui/widgets/button.dart';
import 'package:flutter_to_do_app/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
      child: Obx((){
        return ListView.builder(
            itemCount: _taskController.taskList.length,

            itemBuilder: (_, index){
               print(_taskController.taskList.length);
                return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                          child: FadeInAnimation(
                            child: Row(
                             children: [
                                GestureDetector(
                                  onTap: (){
                                    print("Tapped");
                                  },
                                  child: TaskTile(_taskController.taskList[index])
                                )
                              ],
                            )
                          )
                      )
                  );
        });
      }),
    );
  }

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        onDateChange: (date){
          _selectedDate=date;
        },
      ),
    );
  }

  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today", style: headingStyle),
              ],
            ),
          ),
          MyButton( label: "+ Add Task", onTap: () async {
            await Get.to(() => AddTaskPage());
            _taskController.getTasks();
          })
        ],
      ),
    );
  }

  _appBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activate Light Theme":"Activated Dark Theme"
          );

          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined: Icons.nightlight_round,
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
}
