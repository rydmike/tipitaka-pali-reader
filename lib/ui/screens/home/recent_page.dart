import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/view_models/recent_page_view_model.dart';
import '../../../services/dao/recent_dao.dart';
import '../../../services/database/database_helper.dart';
import '../../../services/repositories/recent_repo.dart';
import '../../dialogs/confirm_dialog.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class RecentPage extends StatelessWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecentPageViewModel>(
      create: (_) => RecentPageViewModel(
          RecentDatabaseRepository(DatabaseHelper(), RecentDao()))
        ..fetchRecents(),
      child: Scaffold(
        appBar: const RecentAppBar(),
        body: Consumer<RecentPageViewModel>(builder: (context, vm, child) {
          final recents = vm.recents;
          return recents.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.recent))
              : ListView.separated(
                  itemCount: recents.length,
                  itemBuilder: (context, index) {
                    final recent = recents[index];
                    return ListTile(
                      dense: true,
                      leading: Text(localScript(context, "${recent.bookName}")),
                      title: Text(
                          "${AppLocalizations.of(context)!.page}: ${localScript(context, recent.pageNumber.toString())}"),
                      onTap: () => vm.openBook(recent, context),
                      trailing: IconButton(
                        onPressed: () => vm.delete(recent),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                );
        }),
      ),
    );
  }

  String localScript(BuildContext context, String s) {
    return PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: s);
  }
}

class RecentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RecentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.recent),
      actions: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final action = await _getConfirmataion(context);
              if (action == OkCancelAction.ok) {
                context.read<RecentPageViewModel>().deleteAll();
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  Future<OkCancelAction?> _getConfirmataion(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: AppLocalizations.of(context)!.confirmation,
            message: AppLocalizations.of(context)!.areSureDelete,
            okLabel: AppLocalizations.of(context)!.delete,
            cancelLabel: AppLocalizations.of(context)!.cancel,
          );
        });
  }
}
