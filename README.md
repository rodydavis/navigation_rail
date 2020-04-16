[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20Me%20A%20Coffee-yellow.svg)](https://www.buymeacoffee.com/rodydavis)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=WSH3GVC49GNNJ)
[![navigation_rail](https://img.shields.io/pub/v/navigation_rail.svg)](https://pub.dev/packages/navigation_rail)

# navigation_rail

An example of how to use the navigation rail.

Material Spec: https://material.io/components/navigation-rail/

Demo: https://rodydavis.github.io/navigation_rail/

## Example

```dart
import 'package:flutter/material.dart';
import 'package:navigation_rail/navigation_rail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NavigationRail Demo',
      theme: _theme(ThemeData.light().copyWith(
        accentColor: Colors.red,
      )),
      home: MyHomePage(title: 'Navigation Rail Demo'),
    );
  }

  ThemeData _theme(ThemeData base) {
    return ThemeData(
      primarySwatch: Colors.blue,
      appBarTheme: base.appBarTheme.copyWith(elevation: 0.0),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        elevation: 2.0,
        backgroundColor: base.accentColor,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavRail(
      drawerHeaderBuilder: (context) {
        return Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Steve Jobs"),
              accountEmail: Text("jobs@apple.com"),
            ),
          ],
        );
      },
      drawerFooterBuilder: (context) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About"),
            ),
          ],
        );
      },
      currentIndex: _currentIndex,
      onTap: (val) {
        if (mounted)
          setState(() {
            _currentIndex = val;
          });
      },
      title: Text(widget.title),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Container(color: Colors.blue[300]),
          Container(color: Colors.red[300]),
          Container(color: Colors.purple[300]),
          Container(color: Colors.grey[300]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      tabs: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          title: Text("Folders"),
          icon: Icon(Icons.folder),
        ),
        BottomNavigationBarItem(
          title: Text("History"),
          icon: Icon(Icons.history),
        ),
        BottomNavigationBarItem(
          title: Text("Gallery"),
          icon: Icon(Icons.photo_library),
        ),
        BottomNavigationBarItem(
          title: Text("Camera"),
          icon: Icon(Icons.camera),
        ),
      ],
    );
  }
}

```
