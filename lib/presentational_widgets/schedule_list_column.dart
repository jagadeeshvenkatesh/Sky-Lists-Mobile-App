import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:list_metadata_repository/list_metadata_repository.dart';

import 'package:sky_lists/blocs/list_metadata_bloc/bloc.dart';

import 'package:sky_lists/presentational_widgets/day_of_week_picker.dart';
import 'package:sky_lists/presentational_widgets/time_picker.dart';

class ScheduleListColumn extends StatelessWidget {
  ScheduleListColumn({
    @required this.state,
  });

  final ListLoaded state;
  final _scheduleTypes = [
    'Daily',
    'Weekly',
    'Biweekly',
    'Monthy',
  ];

  @override
  Widget build(BuildContext context) {
    String value;

    if (state.list.schedule == Schedule.DAILY) {
      value = 'Daily';
    } else if (state.list.schedule == Schedule.BIWEEKLY) {
      value = 'Biweekly';
    } else if (state.list.schedule == Schedule.WEEKLY) {
      value = 'Weekly';
    } else if (state.list.schedule == Schedule.MONTHLY) {
      value = 'Monthy';
    } else {
      value = '';
    }
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: value,
          items: _scheduleTypes
              .map(
                (type) => DropdownMenuItem(
                  child: Text(type),
                  value: type,
                ),
              )
              .toList(),
          onChanged: (val) {
            Schedule flag;
            if (val == 'Daily') {
              flag = Schedule.DAILY;
            } else if (val == 'Biweekly') {
              flag = Schedule.BIWEEKLY;
            } else if (val == 'Weekly') {
              flag = Schedule.WEEKLY;
            } else if (val == 'Monthy') {
              flag = Schedule.MONTHLY;
            }
            BlocProvider.of<ListMetadataBloc>(context).add(
              UpdateListMetadata(
                state.list.copyWith(
                  schedule: flag,
                  enableSchedule: state.list.schedule == Schedule.DAILY ||
                      (state.list.schedule != Schedule.DAILY &&
                          state.list.daysOfWeek.containsValue(true) &&
                          state.list.scheduleTime.isNotEmpty),
                ),
              ),
            );
          },
        ),
        if (state.list.schedule != Schedule.DAILY) ...[
          DayOfWeekPicker(
            list: state.list,
            state: state,
          ),
        ],
        if (state.list.daysOfWeek.containsValue(true)) ...[
          TimePicker(state: state),
        ],
      ],
    );
  }
}
