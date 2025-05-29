// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_state.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/hospital_colors.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: HospitalColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(HospitalColors.primaryColor),
              ),
            );
          } else if (state is DoctorError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: HospitalColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: HospitalColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DoctorLoaded) {
            return Column(
              children: [
                // Doctor Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HospitalColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.doctor.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                state.doctor.specialization,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8 (127 reviews)',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Calendar and Schedule Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Calendar Section
                        Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: HospitalColors.primaryColor,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Select Date',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: HospitalColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(Duration(days: 90)),
                                focusedDay: _focusedDay,
                                calendarFormat: _calendarFormat,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                availableGestures: AvailableGestures.all,
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _selectedTimeSlot =
                                        null; // Reset time slot selection
                                  });
                                },
                                onFormatChanged: (format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                },
                                calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                  // Selected day styling
                                  selectedDecoration: BoxDecoration(
                                    color: HospitalColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  // Today styling
                                  todayDecoration: BoxDecoration(
                                    color: HospitalColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  todayTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  // Default day styling
                                  defaultTextStyle: TextStyle(
                                    color: HospitalColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // Weekend styling
                                  weekendTextStyle: TextStyle(
                                    color: HospitalColors.textSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // Outside days styling
                                  outsideTextStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                  // Marker styling
                                  markerDecoration: BoxDecoration(
                                    color: HospitalColors.successGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  markersMaxCount: 3,
                                  markerSize: 6.0,
                                  markerMargin:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  // Cell styling
                                  cellMargin: EdgeInsets.all(4.0),
                                  cellPadding: EdgeInsets.zero,
                                  cellAlignment: Alignment.center,
                                ),
                                headerStyle: HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  leftChevronVisible: true,
                                  rightChevronVisible: true,
                                  leftChevronIcon: Icon(
                                    Icons.chevron_left,
                                    color: HospitalColors.primaryColor,
                                    size: 24,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.chevron_right,
                                    color: HospitalColors.primaryColor,
                                    size: 24,
                                  ),
                                  titleTextStyle: TextStyle(
                                    color: HospitalColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  headerPadding:
                                      EdgeInsets.symmetric(vertical: 8.0),
                                  headerMargin: EdgeInsets.only(bottom: 8.0),
                                ),
                                // Days of week styling - THIS IS THE KEY ADDITION
                                daysOfWeekStyle: DaysOfWeekStyle(
                                  weekendStyle: TextStyle(
                                    color: HospitalColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  weekdayStyle: TextStyle(
                                    color: HospitalColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  dowTextFormatter: (date, locale) {
                                    // This will show abbreviated day names (Sun, Mon, Tue, etc.)
                                    return DateFormat.E(locale)
                                        .format(date)
                                        .toUpperCase();
                                  },
                                ),
                                // Row height for better spacing
                                rowHeight: 48.0,
                                daysOfWeekHeight: 32.0,
                                eventLoader: (day) {
                                  return _getEventsForDay(
                                      day, state.doctor.schedules ?? []);
                                },
                              ),
                            ],
                          ),
                        ),

                        // Available Time Slots
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: HospitalColors.primaryColor,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Available Time Slots',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: HospitalColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  _getSelectedDateText(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: HospitalColors.textSecondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildTimeSlots(state.doctor.schedules ?? []),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),

                        SizedBox(height: 100), // Space for floating button
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          if (state is DoctorLoaded) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: FloatingActionButton.extended(
                onPressed: _selectedTimeSlot != null
                    ? () => _requestAppointment(context, state.doctor)
                    : null,
                backgroundColor: _selectedTimeSlot != null
                    ? HospitalColors.primaryColor
                    : Colors.grey[400],
                icon: Icon(
                  Icons.event_available,
                  color: Colors.white,
                ),
                label: Text(
                  'Request Appointment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<String> _getEventsForDay(DateTime day, List<ScheduleEntity> schedules) {
    String dayName = _getDayName(day.weekday);
    return schedules
        .where((schedule) =>
            schedule.dayOfWeek.toLowerCase() == dayName.toLowerCase())
        .map((schedule) => '${schedule.startTime}-${schedule.endTime}')
        .toList();
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getSelectedDateText() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return '${_getDayName(_selectedDay.weekday)}, ${_selectedDay.day} ${months[_selectedDay.month - 1]} ${_selectedDay.year}';
  }

  Widget _buildTimeSlots(List<ScheduleEntity> schedules) {
    String selectedDayName = _getDayName(_selectedDay.weekday);
    List<ScheduleEntity> daySchedules = schedules
        .where((schedule) =>
            schedule.dayOfWeek.toLowerCase() == selectedDayName.toLowerCase())
        .toList();

    if (daySchedules.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 12),
            Text(
              'No available slots for this day',
              style: TextStyle(
                fontSize: 16,
                color: HospitalColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: daySchedules.map((schedule) {
          List<String> timeSlots =
              _generateTimeSlots(schedule.startTime, schedule.endTime);
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: timeSlots.map((timeSlot) {
              bool isSelected = _selectedTimeSlot == timeSlot;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = isSelected ? null : timeSlot;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? HospitalColors.primaryColor
                        : HospitalColors.primarySoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? HospitalColors.primaryColor
                          : HospitalColors.primaryColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    timeSlot,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : HospitalColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  List<String> _generateTimeSlots(String startTime, String endTime) {
    List<String> slots = [];

    // Parse start and end times
    List<String> startParts = startTime.split(':');
    List<String> endParts = endTime.split(':');

    int startHour = int.parse(startParts[0]);
    int startMinute = int.parse(startParts[1]);
    int endHour = int.parse(endParts[0]);
    int endMinute = int.parse(endParts[1]);

    DateTime start = DateTime(2023, 1, 1, startHour, startMinute);
    DateTime end = DateTime(2023, 1, 1, endHour, endMinute);

    // Generate 30-minute slots
    while (start.isBefore(end)) {
      DateTime slotEnd = start.add(Duration(minutes: 30));
      if (slotEnd.isAfter(end)) break;

      String startStr =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      String endStr =
          '${slotEnd.hour.toString().padLeft(2, '0')}:${slotEnd.minute.toString().padLeft(2, '0')}';

      slots.add('$startStr - $endStr');
      start = slotEnd;
    }

    return slots;
  }

  void _requestAppointment(BuildContext context, DoctorEntity doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.event_available,
              color: HospitalColors.primaryColor,
            ),
            SizedBox(width: 12),
            Text('Confirm Appointment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor: Dr. ${doctor.name}',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('Date: ${_getSelectedDateText()}'),
            SizedBox(height: 8),
            Text('Time: $_selectedTimeSlot'),
            SizedBox(height: 16),
            Text(
              'Please confirm your appointment request. You will receive a confirmation once the doctor approves.',
              style: TextStyle(
                color: HospitalColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: HospitalColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: HospitalColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: HospitalColors.successGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: HospitalColors.successGreen,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Appointment Requested!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HospitalColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your appointment request has been sent successfully. You will receive a confirmation soon.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HospitalColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HospitalColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
