import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../services/prefs.dart';
import '../../../../utils/pali_script.dart';
import '../../../../utils/pali_script_converter.dart';
import '../../../../utils/script_detector.dart';
import '../screens/home/search_page/search_page.dart';

class SearchTypeSegmentedControl extends StatefulWidget {
  const SearchTypeSegmentedControl(
      {Key? key,
      required this.mode,
      required this.wordDistance,
      required this.onModeChanged,
      required this.onDistanceChanged})
      : super(key: key);
  final QueryMode mode;
  final int wordDistance;
  final Function(QueryMode) onModeChanged;
  final Function(int) onDistanceChanged;

  @override
  _SearchTypeSegmentedControlState createState() =>
      _SearchTypeSegmentedControlState();
}

class _SearchTypeSegmentedControlState
    extends State<SearchTypeSegmentedControl> {
  int _selectedIndex = 0;

  final Map<int, String> _segmentValues = {
    0: 'exact',
    1: 'distance',
    2: 'prefix',
    3: 'any part',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _segmentValues.entries.map((entry) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = entry.key;

                    widget.onModeChanged(getQueryModeFromSelection(entry.key));
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == entry.key
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: _selectedIndex == entry.key
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  QueryMode getQueryModeFromSelection(int key) {
    QueryMode qm = QueryMode.exact;
    switch (key) {
      case 1:
        qm = QueryMode.distance;
        break;
      case 2:
        qm = QueryMode.prefix;
        break;
      case 3:
        qm = QueryMode.anywhere;
        break;
    }

    return qm;
  }
}
