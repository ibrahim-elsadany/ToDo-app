import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:to_do/controller/todo_provider.dart';
import 'package:to_do/screens/setting_screen.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/date_picker.dart';
import '../widgets/list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyAppHome extends StatefulWidget {
  const MyAppHome({Key? key}) : super(key: key);

  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  int _selectedIndex = 0;
  late TodoProvider provider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200),(){
      provider.getDataFromFirestore();
    });
  }



  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addDataToFirestore() {
    try {
      provider.firestore.collection('tasks').doc().set({
        'title': titleController.text,
        'description': descriptionController.text,
        'selectedTime': provider.selectedTime.millisecondsSinceEpoch,
        'isDone': false,
        'id' : provider.firestore.collection('tasks').doc().id
      });
      print('Data added successfully');
    } catch (error) {
      print('Error adding data: $error');
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      provider.getDataFromFirestore();
    });
  }


  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    provider=Provider.of(context,listen: true);
    SettingsProvider settingsProvider= Provider.of(context);
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkPrimaryColor: const Color(0xfffdfecdb),
        extendBody: true,
        body: _selectedIndex == 0
            ? buildColumn(height,appLocalizations)
            :SettingsScreen(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                return Padding(
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: Container(
                    height: height * .45,
                    decoration: BoxDecoration(
                        color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              appLocalizations.addNewTask,
                              style: TextStyle(
                                color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white: Colors.black,
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 20),
                              child: TextFormField(
                                controller: titleController,
                                validator: (string) {
                                  return string?.isEmpty == true
                                      ? "Please Enter Your task title"
                                      : null;
                                },
                                scrollPadding: const EdgeInsets.all(20),
                                decoration: InputDecoration(
                                  labelText: appLocalizations.labelTitle,
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 20),
                              child: TextFormField(
                                controller: descriptionController,
                                validator: (string) {
                                  return string?.isEmpty == true
                                      ? "Please Enter Your task description"
                                      : null;
                                },
                                scrollPadding: const EdgeInsets.all(20),
                                decoration: InputDecoration(
                                  labelText: appLocalizations.labelTask,
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              padding:appLocalizations.lang=="Language"? const EdgeInsets.only(left: 40):const EdgeInsets.only(right: 40),
                              width: double.infinity,
                              child: Text(
                                appLocalizations.selectTime,
                                style: TextStyle(
                                  color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white.withOpacity(0.75):Colors.black,
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                provider.selectedTime = await showDatePicker(
                                      context: context,
                                      initialDate: provider.selectedTime,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)),
                                    ) ??
                                    provider.selectedTime;
                                print(provider.selectedTime);
                                setState(() {});
                              },
                              child: Text(
                                "${provider.selectedTime.day}/${provider.selectedTime.month}/${provider.selectedTime.year}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    _globalKey.currentState!.validate();
                                    if (_globalKey.currentState!.validate()) {
                                      addDataToFirestore();
                                      Navigator.pop(context);
                                    }
                                    titleController.clear();
                                    descriptionController.clear();
                                  },
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        appLocalizations.addTask,
                                        textAlign: TextAlign.center,
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            );
          },
          elevation: 0,
          shape: const StadiumBorder(
            side: BorderSide(color: Colors.white, width: 4),
          ),
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        bottomNavigationBar: DemoBottomAppBar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
  Column buildColumn(double height,AppLocalizations appLocalizations) {
    return Column(
              children: [
                Stack(
                  children: [
                    AppBarBuild("To Do App"),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.12,
                      ),
                      child: const DatePicker(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Slidable(
                        startActionPane: ActionPane(
                          extentRatio: 0.25,
                          motion: const ScrollMotion(),
                          children: [
                            Expanded(
                              child: Container(
                                height: height*0.17,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)
                                  ),
                                  color: Colors.red
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(provider.todos[index].id)
                                            .delete();
                                        provider.getDataFromFirestore();
                                      },
                                        icon: const Icon(Icons.delete,color: Colors.white,size: 50,),
                                    ),
                                    const SizedBox(height: 15,),
                                    Text(appLocalizations.delete,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600
                                    ),
                                    )
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                        // The end action pane is the one at the right or the bottom side.
                        child: ListItem(todoDm: provider.todos[index]),
                      );
                    },
                    itemCount: provider.todos.length,
                  )
                ),
              ],
            );
  }
}
