import 'package:flutter/material.dart';

const _tabletBreakpoint = 720.0;
const _desktopBreakpoint = 1440.0;
const _minHeight = 400.0;
const _drawerWidth = 270.0;
const _railSize = 72.0;
const _denseRailSize = 56.0;

class NavRail extends StatelessWidget {
  final FloatingActionButton floatingActionButton;
  final int currentIndex;
  final Widget body;
  final Widget title;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> tabs;
  final WidgetBuilder drawerHeaderBuilder, drawerFooterBuilder;
  final Color bottomNavigationBarColor;
  final double tabletBreakpoint, desktopBreakpoint, minHeight, drawerWidth;
  final List<Widget> actions;
  final BottomNavigationBarType bottomNavigationBarType;
  final Color bottomNavigationBarSelectedColor,
      bottomNavigationBarUnselectedColor;
  final bool isDense;
  final bool hideTitleBar;
  final bool hideBottomNavigationBar;
  final double navigationRailElevation;
  final double drawerElevation;
  final NavigationRailLabelType navigationRailLabelType;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const NavRail({
    Key key,
    @required this.currentIndex,
    @required this.tabs,
    @required this.onTap,
    this.scaffoldKey,
    this.actions,
    this.isDense = false,
    this.floatingActionButton,
    this.drawerFooterBuilder,
    this.drawerHeaderBuilder,
    this.body,
    this.title,
    this.bottomNavigationBarColor,
    this.navigationRailLabelType,
    this.tabletBreakpoint = _tabletBreakpoint,
    this.desktopBreakpoint = _desktopBreakpoint,
    this.drawerWidth = _drawerWidth,
    this.bottomNavigationBarType = BottomNavigationBarType.fixed,
    this.bottomNavigationBarSelectedColor,
    this.bottomNavigationBarUnselectedColor,
    this.minHeight = _minHeight,
    this.hideTitleBar = false,
    this.hideBottomNavigationBar = false,
    this.navigationRailElevation = 0.0,
    this.drawerElevation = 0.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(context),
      child: LayoutBuilder(
        builder: (_, dimens) {
          if (dimens.maxWidth >= desktopBreakpoint &&
              dimens.maxHeight > minHeight) {
            return Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: <Widget>[
                  Container(
                    width: _drawerWidth,
                    child: _buildDrawer(context, true),
                  ),
                  Expanded(
                    child: Scaffold(
                      key: scaffoldKey,
                      floatingActionButton: floatingActionButton,
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.startTop,
                      appBar: hideTitleBar
                          ? null
                          : AppBar(
                              title: title,
                              actions: actions,
                              automaticallyImplyLeading: false,
                            ),
                      body: body,
                    ),
                  ),
                ],
              ),
            );
          }
          if (dimens.maxWidth >= tabletBreakpoint &&
              dimens.maxHeight > minHeight) {
            return Scaffold(
              key: scaffoldKey,
              appBar: hideTitleBar
                  ? null
                  : AppBar(
                      title: title,
                      actions: actions,
                      automaticallyImplyLeading: true,
                    ),
              drawer: drawerHeaderBuilder != null || drawerFooterBuilder != null
                  ? _buildDrawer(context, false)
                  : null,
              floatingActionButton: floatingActionButton,
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              body: Row(
                children: <Widget>[
                  buildRail(context, false),
                  Expanded(child: body),
                ],
              ),
            );
          }
          return Scaffold(
            key: scaffoldKey,
            appBar: hideTitleBar
                ? null
                : AppBar(
                    title: title,
                    actions: actions,
                    automaticallyImplyLeading: true,
                  ),
            drawer: drawerHeaderBuilder != null || drawerFooterBuilder != null
                ? _buildDrawer(context, false)
                : null,
            body: body,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: hideBottomNavigationBar
                ? null
                : BottomNavigationBar(
                    type: bottomNavigationBarType,
                    backgroundColor: bottomNavigationBarColor,
                    currentIndex: currentIndex,
                    onTap: onTap,
                    items: tabs,
                    unselectedItemColor: bottomNavigationBarUnselectedColor,
                    selectedItemColor: bottomNavigationBarSelectedColor,
                  ),
          );
        },
      ),
    );
  }

  Widget buildRail(
    BuildContext context,
    bool extended, {
    bool isDrawer = false,
  }) {
    return NavigationRail(
      extended: extended,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      minWidth: isDense ? _denseRailSize : _railSize,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      selectedLabelTextStyle: TextStyle(
        color: Theme.of(context).accentColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey,
      ),
      labelType: isDrawer
          ? extended
              ? null
              : NavigationRailLabelType.all
          : this.navigationRailLabelType ?? NavigationRailLabelType.all,
      selectedIndex: currentIndex,
      onDestinationSelected: (val) => onTap(val),
      destinations: tabs
          .map(
            (e) => NavigationRailDestination(
              label: Text(e.label),
              icon: e.icon,
            ),
          )
          .toList(),
    );
  }

  Widget _buildDrawer(BuildContext context, bool showTabs) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            if (drawerHeaderBuilder != null) ...[
              drawerHeaderBuilder(context),
            ],
            if (showTabs) ...[
              Expanded(
                child: buildRail(
                  context,
                  true,
                  isDrawer: true,
                ),
              ),
            ],
            if (drawerFooterBuilder != null) ...[
              drawerFooterBuilder(context),
            ],
          ],
        ),
      ),
    );
  }
}
