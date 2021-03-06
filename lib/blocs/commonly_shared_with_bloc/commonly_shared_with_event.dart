import 'package:equatable/equatable.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

abstract class CommonlySharedWithEvent extends Equatable {
  CommonlySharedWithEvent();

  @override
  List<Object> get props => [];
}

class LoadCommonlySharedWith extends CommonlySharedWithEvent {}

class CommonlySharedWithUpdated extends CommonlySharedWithEvent {
  final List<CommonSharedWith> commonSharedWith;

  CommonlySharedWithUpdated(this.commonSharedWith);

  @override
  List<Object> get props => [commonSharedWith];
}

class CommonlySharedWithShareWithUser extends CommonlySharedWithEvent {
  final UserProfile user;
  final ListMetadata list;

  CommonlySharedWithShareWithUser(this.user, this.list);

  @override
  List<Object> get props => [user, list];
}
