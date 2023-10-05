import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';
import 'package:to_do/controller/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarBuild extends StatelessWidget {
  AppBarBuild(this.title, {super.key});
  String title;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider=Provider.of(context);
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      width: double.infinity,
      color: Colors.blue,
      child: Padding(
        padding: appLocalizations.lang == "Language"? const EdgeInsets.only(top: 60, left: 40) : const EdgeInsets.only(top: 60, right: 40),
        child: Text(
          title,
          style: TextStyle(
              color:settingsProvider.mode =='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
