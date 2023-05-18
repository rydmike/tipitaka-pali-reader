import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/ui/screens/reader/mobile_reader_container.dart';

import '../../../business_logic/models/book.dart';
import '../../../business_logic/models/list_item.dart';
import '../../../business_logic/models/sutta.dart';
import '../../../business_logic/view_models/home_page_view_model.dart';
import '../../../routes.dart';
import '../../../services/database/database_helper.dart';
import '../../../services/provider/script_language_provider.dart';
import '../../../services/repositories/sutta_repository.dart';
import '../../../utils/pali_script.dart';
import '../../../utils/platform_info.dart';
import '../../dialogs/sutta_list_dialog.dart';
import '../../widgets/colored_text.dart';
import 'openning_books_provider.dart';
import 'package:tipitaka_pali/services/prefs.dart';

class BookListPage extends StatelessWidget {
  BookListPage({Key? key}) : super(key: key);

  // key will be use for load book list from database
  // value will be use for TabBar Title

  final Map<String, String> _mainCategories = {
    'mula': 'Pāḷi',
    'attha': 'Aṭṭhakathā',
    'tika': 'Ṭīkā',
    'annya': 'Añña'
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: Mobile.isPhone(context)
            ? AppBar(
                title: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.tipitaka_pali_reader),
                    const Spacer(),
                    IconButton(
                      padding: const EdgeInsets.all(4.0),
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.settings),
                      onPressed: () async {
                        await Navigator.pushNamed(context, settingRoute);
                      },
                    ),
                  ],
                ),
              )
            : null,
        drawer: Mobile.isPhone(context) ? _buildDrawer(context) : null,
        body: Column(
          children: [
            Container(
              height: 56,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: TabBar(
                tabs: _mainCategories.entries
                    .map((category) => Tab(
                        text: PaliScript.getScriptOf(
                            script: context
                                .watch<ScriptLanguageProvider>()
                                .currentScript,
                            romanText: category.value)))
                    .toList(),
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                  children: _mainCategories.entries
                      .map((category) => _buildBookList(category.key))
                      .toList()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final sutta = await _openSuttaDialog(context);
            if (sutta != null) {
              final Book book = Book(id: sutta.bookID, name: sutta.bookName);
              final openningBookProvider =
                  context.read<OpenningBooksProvider>();
              openningBookProvider.add(
                book: book,
                currentPage: sutta.pageNumber,
                textToHighlight: sutta.name,
              );

              if (Mobile.isPhone(context) || Mobile.isTablet(context)) {
                // Navigator.pushNamed(context, readerRoute,
                //     arguments: {'book': bookItem.book});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MobileReaderContrainer()));
              }
            }
          },
          child: const Text("Sutta"),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              duration: Duration(
                milliseconds: Prefs.animationSpeed.round(),
              ),
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  ColoredText(
                    AppLocalizations.of(context)!.tipitaka_pali_reader,
                  ),
                  const SizedBox(height: 25.0),
                  Image.asset(
                    "assets/icon/icon.png",
                    height: 90,
                    width: 90,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: ColoredText(AppLocalizations.of(context)!.dictionary,
                style: const TextStyle()),
            onTap: () => _openDictionaryPage(context),
          ),
          ListTile(
            title: ColoredText(AppLocalizations.of(context)!.settings,
                style: const TextStyle()),
            onTap: () => _openSettingPage(context),
          ),
          ListTile(
            title: ColoredText(AppLocalizations.of(context)!.about,
                style: const TextStyle()),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList(String category) {
    return FutureBuilder(
        future: _loadBooks(category),
        builder: (context, AsyncSnapshot<List<ListItem>> snapshot) {
          if (snapshot.hasData) {
            final listItems = snapshot.data!;
            return ListView.separated(
                controller: ScrollController(),
                itemCount: listItems.length,
                itemBuilder: (context, index) => ListTile(
                      title: listItems[index].build(context),
                      onTap: () => _openBook(context, listItems[index]),
                    ),
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey.shade400,
                    height: 1,
                    thickness: 0,
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<List<ListItem>> _loadBooks(String category) async {
    // await Future.delayed(Duration(seconds: 2));
    return await HomePageViewModel().fecthItems(category);
  }

  _openSettingPage(BuildContext context) async {
    await Navigator.pushNamed(context, settingRoute);
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem as BookItem;
      debugPrint('book name: ${bookItem.book.name}');

      final openningBookProvider = context.read<OpenningBooksProvider>();
      openningBookProvider.add(book: bookItem.book);

      if (Mobile.isPhone(context)) {
        // Navigator.pushNamed(context, readerRoute,
        //     arguments: {'book': bookItem.book});
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const MobileReaderContrainer()));
      }
    }
  }

  _openDictionaryPage(BuildContext context) {
    Navigator.pushNamed(context, dictionaryRoute);
  }

  _showAboutDialog(BuildContext context) {
    showAboutDialog(
        context: context,
        applicationName: AppLocalizations.of(context)!.tipitaka_pali_reader,
        applicationVersion: 'Version 1.8',
        children: [ColoredText(AppLocalizations.of(context)!.about_info)]);
  }

  Future<Sutta?> _openSuttaDialog(BuildContext context) async {
    const sideSheetWidth = 350.0;
    return showGeneralDialog<Sutta>(
      context: context,
      barrierLabel: 'TOC',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeIn),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 16.0),
          child: Align(
            alignment: PlatformInfo.isDesktop
                ? Alignment.bottomLeft
                : Alignment.bottomCenter,
            child: SafeArea(
              child: Dialog.fullscreen(
                //shape: const RoundedRectangleBorder(
                //  borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: PlatformInfo.isDesktop ? sideSheetWidth : 500,
                    // decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.background,
                    //     borderRadius: const BorderRadius.only(
                    //       topLeft: Radius.circular(16),
                    //       topRight: Radius.circular(16),
                    //     )),
                    child: SuttaListDialog(
                      suttaRepository:
                          SuttaRepositoryDatabase(DatabaseHelper()),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
