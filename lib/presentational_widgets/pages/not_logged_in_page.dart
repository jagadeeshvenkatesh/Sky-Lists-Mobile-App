import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/login_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/google_sign_in.dart';
import 'package:sky_lists/presentational_widgets/pages/create_account_page.dart';
import 'package:sky_lists/presentational_widgets/pages/logged_in_home_page.dart';

import 'package:sky_lists/repositories/user_repository.dart';

import 'package:sky_lists/stateful_widgets/forms/login_form.dart';

import 'package:sky_lists/utils/authentication_service.dart';

/// Page user sees when not logged in
class NotLoggedInPage extends StatelessWidget {
  /// Name for page route
  static final String routeName = '/not_logged_in_page';

  _routeToHomePage(BuildContext context, FirebaseUser user) async {
    final FirebaseMessaging _fcm = FirebaseMessaging();

    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      final tokens = Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem,
      });
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      LoggedInHomePage.routeName,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(
        userRepository: Provider.of<UserRepository>(context),
      ),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            _routeToHomePage(context, state.user);
          }
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Sky Lists',
                    style: Theme.of(context).primaryTextTheme.display2,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    'simple and connected',
                    style: Theme.of(context).primaryTextTheme.display1,
                  ),
                  SizedBox(height: 15.0),
                  LoginForm(),
                  SizedBox(height: 15.0),
                  OutlineButton.icon(
                    icon: Icon(Icons.email),
                    label: Text('Sign up with Email'),
                    onPressed: () {
                      // Pushes the CreateAccountPage for user to make account
                      Navigator.pushNamed(context, CreateAccountPage.routeName);
                    },
                  ),
                  GoogleSignIn(),
                  FacebookSignInButton(
                    borderRadius: 18,
                    onPressed: () {
                      // Starts facebook login flow
                      loginToFacebook(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
