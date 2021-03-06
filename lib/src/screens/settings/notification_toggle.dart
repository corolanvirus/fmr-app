import 'package:fmr/src/blocs/app/notification_cubit.dart';
import 'package:fmr/src/blocs/app/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationToggle extends StatelessWidget {
  const NotificationToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
      return Container(
        child: Row(
          children: [
            Switch(
              value: state is NotificationOnState,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (current) {
                context.read<NotificationCubit>().toggleNotification(current);
              },
            ),
            Text("Nofications")
          ],
        ),
      );
    });
  }
}
