// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/schedule/data/datasources/schedule_remote_impl.dart';
import 'package:mobile_app_2/Features/schedule/data/schedule_repo_impl.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_event.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_state.dart';
import 'package:mobile_app_2/app/presentation/screens/schedule/department.dart';
import 'package:mobile_app_2/app/utilities/constants.dart';

// departments_screen.dart
class AllCategory extends StatelessWidget {
  const AllCategory({super.key});

  @override
  Widget build(BuildContext context) {
    IconData _getDepartmentIcon(String departmentName) {
      switch (departmentName.toLowerCase()) {
        case 'cardiology':
          return Icons.favorite;
        case 'neurology':
          return Icons.psychology;
        case 'orthopedics':
          return Icons.accessibility_new;
        case 'pediatrics':
          return Icons.child_care;
        case 'gynecology':
          return Icons.pregnant_woman;
        case 'emergency':
          return Icons.local_hospital;
        case 'radiology':
          return Icons.medical_services;
        case 'surgery':
          return Icons.local_hospital;
        case 'dermatology':
          return Icons.face;
        case 'psychiatry':
          return Icons.psychology_alt;
        default:
          return Icons.local_hospital;
      }
    }

    return BlocProvider(
      create: (context) => DepartmentBloc(
        repository: DepartmentRepositoryImpl(
          remoteDataSource: ScheduleRemoteImpl(),
        ),
      )..add(FetchAllDepartments()),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Departments',
            style: appbarTestStyle,
          ),
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<DepartmentBloc, DepartmentState>(
          builder: (context, state) {
            if (state is DepartmentLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is DepartmentsLoaded) {
              return ListView.builder(
                itemCount: state.departments.length,
                itemBuilder: (context, index) {
                  final department = state.departments[index];
                  return Card(
                    color: Color(0xffFAFAFA),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color:
                              Color(0xffE8F5F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getDepartmentIcon(department.name),
                          color: Color(0xff2A7A6B),
                          size: 28,
                        ),
                      ),
                      title: Text(
                        department.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${department.doctors.length} ${department.doctors.length == 1 ? 'Doctor' : 'Doctors'} Available',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              Color(0xffE8F5F3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff2A7A6B),
                          size: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => DepartmentBloc(
                                repository: DepartmentRepositoryImpl(
                                  remoteDataSource: ScheduleRemoteImpl(),
                                ),
                              )..add(FetchDepartmentById(state.departments[index].id)),
                              child: Department(),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is DepartmentError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
