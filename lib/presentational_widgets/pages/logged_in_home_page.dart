import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/presentational_widgets/bottom_nav_bar_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';
import 'package:sky_lists/stateful_widgets/forms/new_list_form.dart';
import 'package:sky_lists/stateful_widgets/shared_sky_lists_pagination.dart';
import 'package:sky_lists/stateful_widgets/sky_lists_pagination.dart';

class LoggedInHomePage extends StatefulWidget {
  static final String routeName = '/logged_in_home_init';

  @override
  _LoggedInHomePageState createState() => _LoggedInHomePageState();
}

class _LoggedInHomePageState extends State<LoggedInHomePage>
    with TickerProviderStateMixin {
  final List<Widget> _children = [
    SkyListsPagination(),
    SharedSkyListsPagination(),
  ];

  TabController _controller;

  @override
  initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: _children.length,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  onTabTapped(int index) {
    setState(() {
      _controller.animateTo(index);
      _controller.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Sky Lists',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.camera,
          ),
          onPressed: () {
            Navigator.pushNamed(context, QRScannerPage.routeName);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, AccountPage.routeName);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _controller,
        children: _children.map<Widget>((page) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Container(
              key: ObjectKey(page),
              child: page,
            ),
          );
        }).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Provider.of<FirebaseAnalytics>(context, listen: false)
              .logEvent(name: 'list_create_start');

          showDialog(context: context, builder: (context) => NewListForm());
        },
        icon: Icon(Icons.add),
        label: Text('Add List'),
      ),
      bottomNavigationBar: BottomNavBarLoggedInPage(
        controller: _controller,
        onTabTapped: onTabTapped,
      ),
    );
  }
}
