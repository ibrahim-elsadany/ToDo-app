import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:to_do/controller/todo_provider.dart';

import '../model/todo_dm.dart';
import '../screens/details_screen.dart';

class ListItem extends StatefulWidget {
  TodoDm todoDm;
  ListItem({Key? key,required this.todoDm}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  void updateDocument() {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('tasks').doc(widget.todoDm.id);

    docRef.update({
      'isDone': widget.todoDm.isDone,
    })
        .then((value) {
      print('Document successfully updated!');
    })
        .catchError((error) {
      print('Error updating document: $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    TodoProvider provider=Provider.of<TodoProvider>(context,listen: true);
    SettingsProvider settingsProvider = Provider.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    provider.getDataFromFirestore();
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailsScreen(),
            settings: RouteSettings(
                arguments:
                {
                  'title' : widget.todoDm.title,
                  'desc' : widget.todoDm.description,
                  'date' : widget.todoDm.date,
                  'id' : widget.todoDm.id
                }
            ),
          ),
        );
      },
      child: Localizations.override(
          context: context,
        locale: Locale('en'),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          height: height*0.17,
          width: double.infinity,
          decoration: BoxDecoration(
              color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 5,
                height: 90,
                decoration: BoxDecoration(
                    color:widget.todoDm.isDone==true? Colors.lightGreenAccent:Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width*0.40,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.todoDm.title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 22,
                                overflow: TextOverflow.ellipsis,
                                color: widget.todoDm.isDone==true? Colors.lightGreenAccent: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: width*0.42,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.todoDm.description,
                            style: TextStyle(
                                color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'?Colors.white:Colors.black,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12
                            ),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              InkWell(
                onTap: (){
                  widget.todoDm.isDone = !widget.todoDm.isDone;
                  setState(() {});
                  updateDocument();
                },
                child: widget.todoDm.isDone==true?const Text("Done!",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreenAccent
                  ),
                ) :Container(
                  height: 45,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: const ImageIcon(
                    AssetImage(
                      "images/icon_check.png",
                    ),
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
