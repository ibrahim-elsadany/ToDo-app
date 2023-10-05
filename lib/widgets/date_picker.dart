import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart'; 
import 'package:to_do/controller/settings_provider.dart';
import '../controller/todo_provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);
    SettingsProvider settingsProvider= Provider.of(context);

    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      dayProps: EasyDayProps(
        height: 100,
        activeDayDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.blue:AppColors.darkSecoundaryColor
        ),
        inactiveDayDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.blue,
        ),
      ),
      onDateChange: (selectedDate) {
        provider.selectedTime = selectedDate;
        provider.getDataFromFirestore();
      },
    );
  }
}