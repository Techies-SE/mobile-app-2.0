import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:mobile_app_2/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app_2/Features/patient/presentaion/bloc/patient_cubit.dart';
import 'package:mobile_app_2/Features/recommendation/presentation/bloc/recommendation_cubit.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_bloc.dart';
import 'package:mobile_app_2/app/presentation/screens/auth/landing.dart';
import 'package:mobile_app_2/app/utilities/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MobileApp());
}

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<PatientCubit>(create: (_) => getIt<PatientCubit>()),
        BlocProvider<AppointmentBloc>(create: (_) => getIt<AppointmentBloc>()),
        BlocProvider<DepartmentBloc>(create: (_) => getIt<DepartmentBloc>()),
        BlocProvider<DoctorBloc>(create: (_) => getIt<DoctorBloc>()),
        BlocProvider<RecommendationCubit>(create: (_)=> getIt<RecommendationCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Landing(),
      ),
    );
  }
}
