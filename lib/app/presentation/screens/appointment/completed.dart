import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_state.dart';
import 'package:mobile_app_2/app/presentation/widgets/appointments/completed_appointment.dart';

class Completed extends StatelessWidget {
  const Completed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentFetching) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state is AppointmentFetchingFail) {
          return Center(
            child: Text('oops! ${state.error}'),
          );
        } else if (state is AppointmentFetchingSuccess) {
          return ListView.separated(
            itemCount: state.appointmentEntityList.length,
            separatorBuilder: (context, index) {
              final appointment = state.appointmentEntityList[index];
              return appointment.status.contains('completed')
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox();
            },
            itemBuilder: (context, index) {
              final appointment = state.appointmentEntityList[index];
              return appointment.status.contains('completed')
                  ? CompletedAppointment(
                      doctor: appointment.doctor,
                      doctor_id: appointment.doctor_id,
                      specialization: appointment.specialization,
                      date: appointment.date,
                      time: appointment.time,
                      status: appointment.status,
                    )
                  : SizedBox();
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
