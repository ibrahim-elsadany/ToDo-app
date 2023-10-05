import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:to_do/controller/todo_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_bar.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Map args;
  late DateTime newSelectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context)!.settings.arguments as Map;
      _titleController.text = args['title'];
      _descriptionController.text = args['desc'];
      newSelectedTime = args['date'];
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void updateDocument() {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('tasks').doc(args['id']);

    docRef.update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'selectedTime': newSelectedTime.millisecondsSinceEpoch
    }).then((value) {
      print('Document successfully updated!');
    }).catchError((error) {
      print('Error updating document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    TodoProvider provider = Provider.of(context, listen: true);
    SettingsProvider settingsProvider=Provider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor:settingsProvider.mode=='Dark' || settingsProvider.mode=='مظلم'? AppColors.darkPrimaryColor: const Color(0xfffdfecdb),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  AppBarBuild("To Do App"),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.19,
                    ),
                    child: Center(
                      child: Container(
                        height: height * 0.65,
                        width: width * 0.80,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: width,
                              child: Text(
                                appLocalizations.editTask,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                  color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.black,
                                ),
                              ),
                            ),
                            TextField(
                              style: TextStyle(
                                color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.black,
                                fontSize: 20
                              ),
                              controller: _titleController,
                              onTap: () {
                                setState(() {
                                  _titleController.text = args['title'];
                                });
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            TextField(
                              style: TextStyle(
                                  color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.black,
                                  fontSize: 20
                              ),
                              controller: _descriptionController,
                              onTap: () {
                                setState(() {
                                  _descriptionController.text = args['desc'];
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: width,
                              child: Text(
                                appLocalizations.selectTime,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white:Colors.black,
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                newSelectedTime = await showDatePicker(
                                      context: context,
                                      initialDate: newSelectedTime,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    ) ??
                                    newSelectedTime;
                                setState(() {});
                              },
                              child: Text(
                                "${provider.selectedTime.day}-${provider.selectedTime.month}-${provider.selectedTime.year}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 60.0),
                                ),
                                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0), // Set the border radius here
                                    ),),
                              ),
                                onPressed: () {
                                  updateDocument();
                                  Navigator.pop(context);
                                },
                                child: Text(appLocalizations.saveChanges,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
