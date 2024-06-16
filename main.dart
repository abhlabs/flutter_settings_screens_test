 Program to test flutter_settings_screens.

    Trying to offer two radio button choices to the user, 
    A and B, and based on which option they select, we need
    to present either two text input fields (A1 and A2),
    or onetext input field (B).

    I'm not able to make this work.  I have a setState() 
    call in the onChanged event for the radio button,
    I have unique ValueKeys in each of the 3 text
    input fields, and even tried a "refreshable" 
    UniqueKey in the column widget that contains the
    radio tile and the 3 text input tiles.

    If you click outside the settings dialog, and go
    back in, the correct text input tiles are visible,
    and any text you type in will be properly saved
    as part of that widget's state.

    But nothing I've tried triggers an update of the
    screen in response to the radio button change.

*/

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as setpkg;

void main() {
  initSettings().then((_) {
    runApp(const MyApp());
  });
}

Future<void> initSettings() async {
  await setpkg.Settings.init(
// Note that cacheProvider is ~optional~.
// To just use shared preferences, omit this parameter
//  cacheProvider: SharePreferenceCache(),
  );
}



void dbgPrint (String dbgMsg) {
  debugPrint (dbgMsg);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Screens Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Settings Screens Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _optionSelected = setpkg.Settings.getValue<int> ('fsstest-option', defaultValue: 0)!;

// refresh key concept suggested by:
// https://stackoverflow.com/questions/43778488/how-to-force-flutter-to-rebuild-redraw-all-widgets
  Key _refreshKey = UniqueKey();
  void _forceRefresh () => setState((){ 
    _refreshKey = UniqueKey();
    dbgPrint("refreshed key: $_refreshKey");
  });


Widget getSettings () {
  _optionSelected = setpkg.Settings.getValue<int> ('fsstest-option', defaultValue: 0)!;
  return Column (crossAxisAlignment: CrossAxisAlignment.start,

// This should force a rebuild of the column when _refreshKey
// is changed by calling _forceRefresh.  It really shouldn't be
// needed, the ValueKeys in the text input tiles plus the
// setState that updates state variable _optionSelected, should
// be enough to trigger the rebuild.
////      key:  _refreshKey, 
    children: [

      setpkg.RadioSettingsTile(
        settingKey: 'fsstest-option',
        title: 'Select Option A or B',
        values: const <int, String> {
          0: 'Option A (2 fields)',
          1: 'Option B (1 field)'
        },
        selected: _optionSelected,
        leading: const Icon(Icons.question_mark),
        onChange: (value) async {
          int iValue = int.parse (value.toString());
          await setpkg.Settings.setValue<int>('fsstest-option', iValue,);
          setState (() {
// This is not forcing the getSettings widget to
// rebuild with updated _optionSelected.
            _optionSelected = iValue;
          });
          _forceRefresh();
          dbgPrint('fsstest-option: $iValue');
          dbgPrint("_optionSelected = $_optionSelected");
        }, // onChange
      ),

// ValueKeys are needed in the TextInputSettingsTile, because
// we'll be changing which one(s) are showing when _optionSelected
// changes.
// For this teset, initialValues are hard coded, for production
// they should com from the corresponding settingKeys.
      if (_optionSelected == 0)
      setpkg.TextInputSettingsTile (
        key: const ValueKey(1), 
        title: 'Option A field #1',
        settingKey: 'fsstest-optionA1',
        initialValue: "A1",
        keyboardType: TextInputType.text,
        onChange: (value) async {
          dbgPrint('Option A1 changed, fsstest-optionA1: $value');
          await setpkg.Settings.setValue('fsstest-optionA1', value,);
        },        
        ),

      if (_optionSelected == 0)
        setpkg.TextInputSettingsTile (
        key: const ValueKey(2), 
        title: 'Option A field #2',
        settingKey: 'fsstest-optionA2',
        initialValue: "A2",
        keyboardType: TextInputType.text,
        onChange: (value) async {
          dbgPrint('Option A1 changed, fsstest-optionA2: $value');
          await setpkg.Settings.setValue('fsstest-optionA2', value,);
        },        
        ),

      if (_optionSelected == 1)
      setpkg.TextInputSettingsTile (
        key: const ValueKey(3),
        title: 'Option B only one field',
        settingKey: 'fsstest-optionB',
        initialValue: "B",
        keyboardType: TextInputType.text,
        onChange: (value) async {
          dbgPrint('Option B changed, fsstest-optionB: $value');
          await setpkg.Settings.setValue('fsstest-OptionB', value,);
        },        
        ),
    ],
  );
}


Widget appBody() {
  return SingleChildScrollView(
    child: Column (
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          setpkg.ModalSettingsTile(
            key: _refreshKey,
            title: 'Flutter_settings_screens Test',
            subtitle: '       Testing variable text entries ',
            children: [
              getSettings(),
            ], 
          ),
        ],
      ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screens Test'),
      ),
      drawer: null, // AppDrawer(),
      body: appBody(),
    );
  }

}
