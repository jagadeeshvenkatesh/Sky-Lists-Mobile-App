import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:sky_lists/blocs/authentication_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_items_bloc/bloc.dart';
import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/pages/not_logged_in_page.dart';
import 'package:sky_lists/presentational_widgets/share_list_button.dart';
import 'package:sky_lists/presentational_widgets/sky_list_page_leading.dart';

import 'package:sky_lists/stateful_widgets/forms/list_title_form.dart';
import 'package:sky_lists/stateful_widgets/sky_list_pagination.dart';

import 'package:sky_lists/utils/sky_list_page_arguments.dart';

import 'package:list_items_repository/list_items_repository.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

class SkyListPage extends StatelessWidget {
  static final String routeName = '/list';

  @override
  Widget build(BuildContext context) {
    final SkyListPageArguments args = ModalRoute.of(context).settings.arguments;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            NotLoggedInPage.routeName,
            (Route<dynamic> route) => false,
          );
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final repo = FirebaseListMetadataRepository(state.user.uid);
            return MultiBlocProvider(
              providers: [
                BlocProvider<ListMetadataBloc>(
                  create: (_) => ListMetadataBloc(
                    listsRepository: repo,
                  )..add(LoadListMetadata(args.list)),
                ),
                BlocProvider<ListItemsBloc>(
                  create: (_) => ListItemsBloc(
                    itemsRepository: FirebaseListItemsRepository(
                      args.list,
                      state.user.uid,
                    ),
                  )..add(LoadListItems()),
                ),
              ],
              child: Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    ShareListButton(
                      user: state.user,
                      list: args.list,
                    ),
                  ],
                  leading: SkyListPageLeading(),
                  title: ListTitleForm(list: args.list),
                ),
                body: Provider(
                  create: (_) => repo,
                  child: SkyListPagination(),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
