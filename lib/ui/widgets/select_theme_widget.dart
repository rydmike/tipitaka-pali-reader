import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/data/flex_theme_data.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';
import 'package:tipitaka_pali/ui/widgets/colored_text.dart';

class SelectThemeWidget extends StatelessWidget {
  const SelectThemeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;
    final themeChangeNotifier = Provider.of<ThemeChangeNotifier>(context);

    // Extracting the current theme's primary and secondary colors
    final currentPrimaryColor = isLight
        ? myFlexSchemes[themeChangeNotifier.themeIndex].light.primary
        : myFlexSchemes[themeChangeNotifier.themeIndex].dark.primary;
    final currentSecondaryColor = isLight
        ? myFlexSchemes[themeChangeNotifier.themeIndex].light.secondary
        : myFlexSchemes[themeChangeNotifier.themeIndex].dark.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display current theme name and color icons
        ColoredText(
          myFlexSchemes[themeChangeNotifier.themeIndex].name,
        ),
        const SizedBox(width: 8),
        Icon(Icons.lens, color: currentPrimaryColor, size: 26),
        Icon(Icons.lens, color: currentSecondaryColor, size: 20),
        const SizedBox(width: 8),
        // PopupMenuButton for theme selection
        PopupMenuButton<int>(
          padding: EdgeInsets.zero,
          onSelected: (val) {
            Prefs.themeIndex = val;
            Prefs.themeName = myFlexSchemes[val].name;
            themeChangeNotifier.themeIndex = val;
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
            for (int i = 0; i < myFlexSchemes.length; i++)
              PopupMenuItem<int>(
                value: i,
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lens,
                          color: isLight
                              ? myFlexSchemes[i].light.primary
                              : myFlexSchemes[i].dark.primary,
                          size: 35),
                      const SizedBox(width: 8),
                      Icon(Icons.circle,
                          color: isLight
                              ? myFlexSchemes[i].light.secondary
                              : myFlexSchemes[i].dark.secondary,
                          size: 20),
                    ],
                  ),
                  title: ColoredText(myFlexSchemes[i].name),
                ),
              )
          ],
          child: const Icon(
            Icons.arrow_drop_down,
          ),
        ),
      ],
    );
  }
}
