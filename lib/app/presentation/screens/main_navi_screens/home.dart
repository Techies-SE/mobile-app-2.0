// ignore_for_file: unused_element, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/service_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_2/Features/appointment/domain/entities/appointment_entity.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_event.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_state.dart';
import 'package:mobile_app_2/app/presentation/screens/main_navi_bar.dart';
import 'package:mobile_app_2/app/presentation/widgets/appointments/appointment_card.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //ScrollController _scrollController = ScrollController();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();

    // Delay is recommended to ensure context is available
    Future.microtask(() {
      context.read<AppointmentBloc>().add(FetchAppointmentByUserIdEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            text: ' MFU ',
            style: GoogleFonts.inter(
              color: mainBgColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Wellness Center',
                style: GoogleFonts.inter(
                  color: goldenColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                top: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Appointment',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainNaviBar(
                              pageIndex: 2,
                            ),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      'Viewall',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: mainBgColor,
                        decoration: TextDecoration.underline,
                        decorationColor: mainBgColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                if (state is AppointmentFetching) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (state is AppointmentFetchingSuccess) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.appointmentEntityList.length,
                          itemBuilder: (context, index) {
                            final appointment =
                                state.appointmentEntityList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.91,
                                child: AppointmentCard(
                                  doctor: appointment.doctor,
                                  specialization: appointment.specialization,
                                  date: appointment.date,
                                  time: appointment.time,
                                  status: appointment.status,
                                  doctor_id: appointment.doctor_id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: state.appointmentEntityList.length,
                        effect: WormEffect(
                          dotHeight: 11.31,
                          dotWidth: 11.31,
                          dotColor: Color(0x80C7BABA),
                          activeDotColor: Color(0xFF50BEAF).withAlpha(130),
                        ),
                      ),
                    ],
                  );
                } else if (state is AppointmentFetchingFail) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.error}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => context
                              .read<AppointmentBloc>()
                              .add(FetchAppointmentByUserIdEvent()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                top: 10.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 23,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quick Actions',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNaviBar(),
                              ),
                            );
                          },
                          child: ServiceCard(
                            image: 'assets/images/checkUp.png',
                            service: 'Medical Checkup',
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainNaviBar(
                                    pageIndex: 2,
                                  ),
                                ),
                                (route) => false);
                          },
                          child: ServiceCard(
                            image: 'assets/images/calendar.png',
                            service: 'Appoitment',
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: ServiceCard(
                            image: 'assets/images/search.png',
                            service: 'Find Doctor',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Color(0xffF9E3E3),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/emergency.png',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'Get immediate medical support ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffE65454),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {},
                            child: Text(
                              'Call Now',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Card(
                    color: Color(0xffF9E3E3),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: mainBgColor,
                            child: Image.asset(
                              'assets/images/robot.png',
                              color: Colors.white,
                              width: 20,
                              height: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendation',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'Check reliable AI Recommendations',
                                   maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: ElevatedButton(
                              
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                                backgroundColor: mainBgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {},
                            child: Text(
                              'View Now',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildAppointmentList(List<AppointmentEntity> appointments) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total Appointments: ${appointments.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCard(appointment);
          },
        ),
      ),
    ],
  );
}

Widget _buildAppointmentCard(AppointmentEntity appointment) {
  // Format the date and time
  final date = DateFormat('MMM d, y').format(DateTime.parse(appointment.date));
  final time = DateFormat('h:mm a').format(
    DateFormat('HH:mm:ss').parse(appointment.time.split('.')[0]),
  );

  // Color based on status
  Color statusColor;
  switch (appointment.status.toLowerCase()) {
    case 'scheduled':
      statusColor = Colors.green;
      break;
    case 'pending':
      statusColor = Colors.orange;
      break;
    case 'canceled':
      statusColor = Colors.red;
      break;
    default:
      statusColor = Colors.grey;
  }

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.doctor,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(appointment.specialization),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text(date),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 8),
              Text(time),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  appointment.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
