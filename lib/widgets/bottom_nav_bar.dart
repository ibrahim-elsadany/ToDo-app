import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/app_colors.dart';

import '../controller/settings_provider.dart';

class DemoBottomAppBar extends StatelessWidget {

  final int selectedIndex;
  final Function(int) onItemSelected;

  const DemoBottomAppBar({super.key, required this.selectedIndex, required this.onItemSelected});


  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context);
    double h = MediaQuery.of(context).size.height;
    return BottomAppBar(
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      color:settingsProvider.mode=='Dark'|| settingsProvider.mode=='مظلم'? AppColors.darkSecoundaryColor: Colors.white,
      height: h*0.08,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: ImageIcon(const AssetImage("images/icon_list.png"),color: selectedIndex == 0 ? Colors.blue : Colors.grey,),
              onPressed: () {
                onItemSelected(0);
              },
            ),
            IconButton(
              icon: ImageIcon(const AssetImage("images/icon_settings.png"),color: selectedIndex == 1 ? Colors.blue : Colors.grey,),
              onPressed: () {
                onItemSelected(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
