import 'package:flutter/material.dart';
import 'package:tipitaka_pali/services/provider/bookmark_provider.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';
import 'package:tipitaka_pali/ui/screens/settings/sync_settings.dart';
import 'package:tipitaka_pali/ui/screens/settings/tools_settings.dart';
import 'package:tipitaka_pali/ui/widgets/select_dictionary_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_language_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_theme_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/data/constants.dart';

import 'download_view.dart';
import 'help_about.dart';
import 'script_setting_view.dart';
import 'general_settings_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sc = ScrollController(); // for auto scroll

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          actions: const [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: sc, // Attach the ScrollController to ListVie
            children: <Widget>[
              const DictionarySettingView(),
              const ThemeSettingView(),
              const DarkModeSettingView(),
              const LanguageSettingView(),
              const ScriptSettingView(),
              const GeneralSettingsView(),
              const HelpAboutView(),
              ChangeNotifierProvider<BookmarkNotifier>(
                create: (context) => BookmarkNotifier(),
                child: const SyncSettingsView(),
              ),
              ToolsSettingsView(scrollController: sc),
            ],
          ),
        ));
  }
}

class ThemeSettingView extends StatelessWidget {
  const ThemeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: const SelectThemeWidget()),
    );
  }
}

class DarkModeSettingView extends StatelessWidget {
  const DarkModeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        leading: const Icon(Icons.brightness_2_outlined),
        trailing: ToggleButtons(
          color: Colors.red,
          onPressed: (int index) {
            Provider.of<ThemeChangeNotifier>(context, listen: false)
                .toggleTheme(index);
          },
          isSelected: context.read<ThemeChangeNotifier>().isSelected,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              child: const Icon(Icons.article, color: Colors.white),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              child: const Icon(Icons.article, color: Color(seypia)),
            ),
            CircleAvatar(
              backgroundColor: Theme.of(context).highlightColor,
              child: const Icon(Icons.article, color: Colors.black),
            ),
          ],
        ),
        title: Text(
          AppLocalizations.of(context)!.darkMode,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class LanguageSettingView extends StatelessWidget {
  const LanguageSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        leading: const Icon(Icons.language_outlined),
        title: Text(
          AppLocalizations.of(context)!.language,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing: SelectLanguageWidget(),
      ),
    );
  }
}

class DictionarySettingView extends StatelessWidget {
  const DictionarySettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ExpansionTile(
        leading: const Icon(Icons.sort_by_alpha_outlined),
        title: Text(AppLocalizations.of(context)!.dictionaries,
            style: Theme.of(context).textTheme.titleLarge),
        children: const [SelectDictionaryWidget()],
      ),
    );
  }
}
