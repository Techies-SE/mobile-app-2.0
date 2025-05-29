// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_event.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_state.dart';
import 'package:mobile_app_2/app/presentation/widgets/appointments/pending_appointment.dart';
import 'package:mobile_app_2/app/presentation/widgets/appointments/reschedule_appointment.dart';
import 'package:mobile_app_2/app/presentation/widgets/appointments/scheduled_appointment.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/hospital_colors.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

class Upcoming extends StatelessWidget {
  const Upcoming({super.key});

  @override
  Widget build(BuildContext context) {
    // Loading dialog methods with different decorations
    void _showConfirmingDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  mainBgColor.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: mainBgColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: mainBgColor,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Confirming Appointment',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait while we confirm your appointment...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _showCancellingDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  HospitalColors.primaryLight,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: HospitalColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: HospitalColors.primaryDark,
                      strokeWidth: 3,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Cancelling Appointment',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait while we cancel your appointment...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

// Success and Error SnackBars
    void _showSuccessSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
        ),
      );
    }

    void _showErrorSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
        ),
      );
    }

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is ConfirmingRescheduledAppointment) {
          _showConfirmingDialog(context);
        }
        if (state is CancellingRescheduledAppointment) {
          _showCancellingDialog(context);
        }
        if (state is CancelRescheduledAppointmentSuccess ||
            state is ConfirmRescheduledAppointmentSuccess) {
          Navigator.pop(context);
          _showSuccessSnackBar(context, 'Success');
          context.read<AppointmentBloc>().add(FetchAppointmentByUserIdEvent());
        }
        if (state is CancelRescheduledAppointmentFail) {
          Navigator.pop(context);
          _showErrorSnackBar(context, state.error);
        }
        if (state is ConfirmingRescheduledAppointmentFailed) {
          Navigator.pop(context);
          _showErrorSnackBar(context, state.error);
        }
      },
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
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
            // Filter upcoming appointments
            final upcomingAppointments = state.appointmentEntityList
                .where((appointment) =>
                    appointment.status.contains('pending') ||
                    appointment.status == 'scheduled' ||
                    appointment.status == 'rescheduled')
                .toList();

            if (upcomingAppointments.isEmpty) {
              return Center(
                child: Text('No upcoming appointments'),
              );
            }

            return ListView.separated(
              itemCount: upcomingAppointments.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final appointment = upcomingAppointments[index];

                if (appointment.status.contains('pending')) {
                  return PendinnAppointment(
                    doctor: appointment.doctor,
                    doctor_id: appointment.doctor_id,
                    specialization: appointment.specialization,
                    date: appointment.date,
                    time: appointment.time,
                    status: appointment.status,
                  );
                } else if (appointment.status == 'scheduled') {
                  return ScheduledAppointment(
                    doctor: appointment.doctor,
                    doctor_id: appointment.doctor_id,
                    specialization: appointment.specialization,
                    date: appointment.date,
                    time: appointment.time,
                    status: appointment.status,
                    appointmentId: appointment.appointmentId,
                  );
                } else if (appointment.status == 'rescheduled') {
                  return RescheduleAppointment(
                    doctor: appointment.doctor,
                    doctor_id: appointment.doctor_id,
                    specialization: appointment.specialization,
                    date: appointment.date,
                    time: appointment.time,
                    status: appointment.status,
                    appointmentId: appointment.appointmentId,
                  );
                } else {
                  return SizedBox();
                }
              },
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
