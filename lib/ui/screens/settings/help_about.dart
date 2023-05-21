import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../dialogs/about_tpr_dialog.dart';
import '../../widgets/colored_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAboutView extends StatefulWidget {
  const HelpAboutView({Key? key}) : super(key: key);

  @override
  State<HelpAboutView> createState() => _HelpAboutViewState();
}

class _HelpAboutViewState extends State<HelpAboutView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ExpansionTile(
        leading: const Icon(Icons.info),
        title: Text(AppLocalizations.of(context)!.helpAboutEtc,
            style: Theme.of(context).textTheme.titleLarge),
        children: [
          const SizedBox(
            height: 10,
          ),
          _getHelpTile(context),
          _getAboutTile(context),
          _getReportIssueTile(context),
        ],
      ),
    );
  }

  Widget _getQuotesOrRestore() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: ListTile(
        title: const Text("Quote -> Restore:"),
        focusColor: Theme.of(context).focusColor,
        hoverColor: Theme.of(context).hoverColor,
        trailing: Switch(
          onChanged: (value) => {
            //prefs
          },
          value: true,
        ),
      ),
    );
  }

  Widget _getAboutTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: ListTile(
        title: ColoredText(AppLocalizations.of(context)!.about),
        focusColor: Theme.of(context).focusColor,
        hoverColor: Theme.of(context).hoverColor,
        onTap: () => showAboutTprDialog(context),
      ),
    );
  }

  Widget _getHelpTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: ListTile(
        title: ColoredText(AppLocalizations.of(context)!.help),
        focusColor: Theme.of(context).focusColor,
        hoverColor: Theme.of(context).hoverColor,
        onTap: () => launchUrl(
            Uri.parse("https://americanmonk.org/tipitaka-pali-reader/"),
            mode: LaunchMode.externalApplication),
      ),
    );
  }

  Widget _getReportIssueTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: ListTile(
        title: ColoredText(AppLocalizations.of(context)!.reportIssue),
        focusColor: Theme.of(context).focusColor,
        hoverColor: Theme.of(context).hoverColor,
        onTap: () => launchUrl(
            Uri.parse(
                "https://github.com/bksubhuti/tipitaka-pali-reader/issues"),
            mode: LaunchMode.externalApplication),
      ),
    );
  }
}
