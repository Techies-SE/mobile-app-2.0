import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/schedule/data/datasources/schedule_remote_impl.dart';
import 'package:mobile_app_2/Features/schedule/data/schedule_repo_impl.dart';
import 'package:mobile_app_2/Features/schedule/domain/entites.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_state.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_event.dart';
import 'package:mobile_app_2/app/presentation/screens/schedule/doctor_screen.dart';
import 'package:mobile_app_2/app/presentation/widgets/utilities/hospital_colors.dart';

class Department extends StatelessWidget {
  const Department({super.key});

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
          'Department',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DepartmentBloc, DepartmentState>(
        builder: (context, state) {
          if (state is DepartmentLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(HospitalColors.primaryColor),
              ),
            );
          } else if (state is DepartmentError) {
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
          } else if (state is DepartmentLoaded) {
            return Column(
              children: [
                // Department Header
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.department.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${state.department.doctors.length} Doctors Available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Doctors List
                Expanded(
                  child: state.department.doctors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No doctors available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: HospitalColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: state.department.doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = state.department.doctors[index];
                            return DoctorCard(doctor: doctor);
                          },
                        ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration - replace with actual data from your API
    final double rating = 4.2 + (doctor.id % 8) * 0.1; // Mock rating
    final int experience = 5 + (doctor.id % 15); // Mock experience
    final int price = 50 + (doctor.id % 20) * 10; // Mock price

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: HospitalColors.cardBackground,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header
            Row(
              children: [
                // Doctor Avatar
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: HospitalColors.primarySoft,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: HospitalColors.primaryColor.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: HospitalColors.primaryColor,
                    size: 32,
                  ),
                ),
                SizedBox(width: 16),
                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: HospitalColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctor.specialization,
                        style: TextStyle(
                          fontSize: 14,
                          color: HospitalColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      // Status Badge
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: doctor.status.toLowerCase() == 'active'
                              ? HospitalColors.successGreen.withOpacity(0.15)
                              : Colors.orange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          doctor.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: doctor.status.toLowerCase() == 'active'
                                ? HospitalColors.successGreen
                                : Colors.orange[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Doctor Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.star,
                    label: 'Rating',
                    value: rating.toStringAsFixed(1),
                    color: Colors.amber,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.work_outline,
                    label: 'Experience',
                    value: '$experience years',
                    color: HospitalColors.accentBlue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.attach_money,
                    label: 'Consultation',
                    value: '\$$price',
                    color: HospitalColors.successGreen,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Handle view profile
                      _showDoctorDetails(context, doctor);
                    },
                    icon: Icon(
                      Icons.person_outline,
                      size: 18,
                      color: HospitalColors.primaryColor,
                    ),
                    label: Text(
                      'View Profile',
                      style: TextStyle(
                        color: HospitalColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: HospitalColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: doctor.status.toLowerCase() == 'active'
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => DoctorBloc(
                                    repository: DoctorRepositoryImpl(
                                      remoteDataSource: ScheduleRemoteImpl(),
                                    ),
                                  )..add(FetchDoctorById(doctor.id)),
                                  child: DoctorScreen(),
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HospitalColors.primaryColor,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 2,
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

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: HospitalColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: HospitalColors.textLight,
          ),
        ),
      ],
    );
  }

  void _showDoctorDetails(BuildContext context, DoctorEntity doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                doctor.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: HospitalColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                doctor.specialization,
                style: TextStyle(
                  fontSize: 16,
                  color: HospitalColors.textSecondary,
                ),
              ),
              SizedBox(height: 16),
              _buildContactInfo('Phone', doctor.phoneNo, Icons.phone),
              _buildContactInfo('Email', doctor.email, Icons.email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: HospitalColors.primaryColor, size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: HospitalColors.textLight,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: HospitalColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
