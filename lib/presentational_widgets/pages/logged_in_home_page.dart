import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';
import 'package:list_metadata_repository/list_meta_data_repository.dart';
import 'package:sky_lists/presentational_widgets/add_list_fab.dart';
import 'package:sky_lists/presentational_widgets/bottom_nav_bar_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/pages/qr_scanner_page.dart';
import 'package:sky_lists/stateful_widgets/shared_sky_lists_pagination.dart';
import 'package:sky_lists/stateful_widgets/sky_lists_pagination.dart';

class LoggedInHomePage extends StatefulWidget {
  static final String routeName = '/logged_in_home_init';

  @override
  _LoggedInHomePageState createState() => _LoggedInHomePageState();
}

class _LoggedInHomePageState extends State<LoggedInHomePage>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 2,
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ListMetadataBloc>(
                create: (_) => ListMetadataBloc(
                  listsRepository:
                      FirebaseListMetadataRepository(state.user.uid),
                )..add(LoadListsMetadata()),
              ),
            ],
            child: Scaffold(
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
                children: [
                  SafeArea(
                    top: false,
                    bottom: false,
                    child: Container(
                      key: ObjectKey(SkyListsPagination),
                      child: SkyListsPagination(),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    bottom: false,
                    child: Container(
                      key: ObjectKey(SharedSkyListsPagination),
                      child: SharedSkyListsPagination(),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: AddListFab(),
              bottomNavigationBar: BottomNavBarLoggedInPage(
                controller: _controller,
                onTabTapped: onTabTapped,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            NotLoggedInPage.routeName,
            (Route<dynamic> route) => false,
          );
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
