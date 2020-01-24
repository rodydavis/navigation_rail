import 'package:flutter/material.dart';

const _tabletBreakpoint = 720.0;
const _desktopBreakpoint = 1440.0;
const _minHeight = 400.0;
const _tabletSpacingVertical = 15.0;
const _tabletSpacingHorizontial = 10.0;
const _drawerWidth = 304.0;

class NavigationRail extends StatelessWidget {
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

  const NavigationRail({
    Key key,
    @required this.currentIndex,
    @required this.tabs,
    @required this.onTap,
    this.actions,
    this.isDense = false,
    this.floatingActionButton,
    this.drawerFooterBuilder,
    this.drawerHeaderBuilder,
    this.body,
    this.title,
    this.bottomNavigationBarColor,
    this.tabletBreakpoint = _tabletBreakpoint,
    this.desktopBreakpoint = _desktopBreakpoint,
    this.drawerWidth = _drawerWidth,
    this.bottomNavigationBarType = BottomNavigationBarType.fixed,
    this.bottomNavigationBarSelectedColor,
    this.bottomNavigationBarUnselectedColor,
    this.minHeight = _minHeight,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Positioned.fill(
                        child: Scaffold(
                          appBar: AppBar(
                            title: title,
                            actions: actions,
                            automaticallyImplyLeading: false,
                          ),
                          body: body,
                        ),
                      ),
                      if (floatingActionButton != null) ...[
                        Positioned(
                          top: kToolbarHeight - kToolbarHeight / 2,
                          right: kToolbarHeight / 2,
                          child: floatingActionButton,
                          width: 50,
                          height: 50,
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        if (dimens.maxWidth >= tabletBreakpoint &&
            dimens.maxHeight > minHeight) {
          return Scaffold(
            appBar: AppBar(
              title: title,
              actions: actions,
              automaticallyImplyLeading: true,
            ),
            drawer: drawerHeaderBuilder != null || drawerFooterBuilder != null
                ? _buildDrawer(context, false)
                : null,
            body: Row(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      if (floatingActionButton != null) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: _tabletSpacingVertical,
                            horizontal: _tabletSpacingHorizontial,
                          ),
                          child: floatingActionButton,
                        ),
                      ],
                      for (var tab in tabs) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: _tabletSpacingVertical,
                            horizontal: _tabletSpacingHorizontial,
                          ),
                          child: _buildTab(
                              currentIndex == tabs.indexOf(tab), context, tab),
                        ),
                      ],
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
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
          bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  Widget _buildTab(
      bool selected, BuildContext context, BottomNavigationBarItem item) {
    final _theme = Theme.of(context);
    final _color = selected
        ? _theme.primaryColor
        : _theme.brightness == Brightness.dark
            ? Colors.tealAccent[200]
            : Colors.grey;
    final _iconTheme = IconThemeData(
      color: _color,
      size: _theme.iconTheme.size,
      opacity: _theme.iconTheme.opacity,
    );
    final _icon = Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: Container(
        child: IconTheme(
          data: _iconTheme,
          child: selected ? item.activeIcon : item.icon,
        ),
      ),
    );
    if (isDense) {
      return _icon;
    }
    return Column(
      children: <Widget>[
        _icon,
        Container(height: 4.0),
        DefaultTextStyle(
          style: TextStyle(color: _color),
          child: item?.title,
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context, bool showTabs) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (drawerHeaderBuilder != null) ...[
                drawerHeaderBuilder(context),
              ],
              if (showTabs) ...[
                for (var tab in tabs) ...[
                  ListTile(
                    dense: isDense,
                    selected: currentIndex == tabs.indexOf(tab),
                    leading: tab?.icon,
                    title: tab?.title,
                    onTap: () => onTap(tabs.indexOf(tab)),
                  ),
                ]
              ],
              if (drawerFooterBuilder != null) ...[
                drawerFooterBuilder(context),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
