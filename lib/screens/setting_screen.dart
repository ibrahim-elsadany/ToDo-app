import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:to_do/widgets/app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static String routeName= "setting_screen" ;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsProvider settingsProvider;

  List<String> langList =["English","Arabic"];

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context,listen: true);
    AppLocalizations appLocalizations =AppLocalizations.of(context)!;
    List<String> modeList=[appLocalizations.light,appLocalizations.dark];



    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'?AppColors.darkPrimaryColor :Color(0xfffdfecdb),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              AppBarBuild(AppLocalizations.of(context)!.settings),
            ],
          ),
          Padding(
              padding:appLocalizations.lang == "Language"? const EdgeInsets.only(
                  left: 30,
                  top: 30
              ) : const EdgeInsets.only(
                  right: 30,
                  top: 30
              ) ,
              child: Text(
                AppLocalizations.of(context)!.lang,
                style: TextStyle(
                    fontSize: 23,
                    color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white:Colors.black,
                    fontWeight: FontWeight.w600
                ),

              )),
          const SizedBox(height: 20,),
          Center(
            child: DropdownMenu<String>(
              width: width * 0.7,
              initialSelection: settingsProvider.language,
              onSelected: (String? value) {
                settingsProvider.toggleLanguage(value!);
                print(settingsProvider.language);
                  if(appLocalizations.lang== "Language"){
                    langList=["English","Arabic"];
                  } else if(appLocalizations.lang== "اللغة"){
                    langList=["اللغة الإنجليزية","اللغة العربية"];
                  }
              },
              textStyle: const TextStyle(
                color: Colors.blue,
              ).copyWith(
                decorationColor: Colors.blue,
              ),
              dropdownMenuEntries: langList.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ),
          Padding(
              padding:appLocalizations.lang == "Language"? const EdgeInsets.only(
                  left: 30,
                  top: 30
              ) : const EdgeInsets.only(
                  right: 30,
                  top: 30
              ) ,
              child: Text(appLocalizations.mode,
              style: TextStyle(
                fontSize: 23,
                color: settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? Colors.white:Colors.black,
                fontWeight: FontWeight.w600
              ),

              )),
          const SizedBox(height: 20,),
          Center(
            child: DropdownMenu<String>(
              width: width * 0.7,
              initialSelection: settingsProvider.mode,
              onSelected: (String? value) {
                settingsProvider.toggleTheme(value!);
                print(settingsProvider.mode);
              },
              textStyle: const TextStyle(
                color: Colors.blue,
              ).copyWith(
                decorationColor: Colors.blue,
              ),
              dropdownMenuEntries: modeList.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(
                  value: value,
                  label: value,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

