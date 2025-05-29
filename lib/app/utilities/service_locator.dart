import 'package:get_it/get_it.dart';
import 'package:mobile_app_2/Features/appointment/data/datasources/remote/appointment_remote_data_impl.dart';
import 'package:mobile_app_2/Features/appointment/data/repositories/appointment_repo_impl.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/cancel_reschedule.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/confirm_rescheduled_appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/fetch_appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/request_appointment.dart';
import 'package:mobile_app_2/Features/appointment/domain/usecases/reschedule_appointment.dart';
import 'package:mobile_app_2/Features/appointment/presentation/bloc/appointment_bloc.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/local/auth_local_data_source_impl.dart';
import 'package:mobile_app_2/Features/auth/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:mobile_app_2/Features/auth/data/repositories/auth_repo_impl.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/change_password.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/login.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/logout.dart';
import 'package:mobile_app_2/Features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_app_2/Features/patient/data/datasources/local/patient_local_data_impl.dart';
import 'package:mobile_app_2/Features/patient/data/datasources/remote/patient_remote_data_impl.dart';
import 'package:mobile_app_2/Features/patient/data/repositories/patient_repo_impl.dart';
import 'package:mobile_app_2/Features/patient/domain/usecases/get_patient_info.dart';
import 'package:mobile_app_2/Features/patient/presentaion/bloc/patient_cubit.dart';
import 'package:mobile_app_2/Features/recommendation/data/recommendation_repo_impl.dart';
import 'package:mobile_app_2/Features/recommendation/data/remote/recom_remote_data_impl.dart';
import 'package:mobile_app_2/Features/recommendation/presentation/bloc/recommendation_cubit.dart';
import 'package:mobile_app_2/Features/schedule/data/datasources/schedule_remote_impl.dart';
import 'package:mobile_app_2/Features/schedule/data/schedule_repo_impl.dart';
import 'package:mobile_app_2/Features/schedule/domain/repositories.dart';
import 'package:mobile_app_2/Features/schedule/presentation/department/bloc/department_bloc.dart';
import 'package:mobile_app_2/Features/schedule/presentation/doctor/bloc/doctor_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  //auth
  getIt.registerLazySingleton<AuthLocalDataSourceImpl>(
      () => AuthLocalDataSourceImpl());
  getIt.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl());
  getIt.registerLazySingleton(() => AuthRepoImpl(
      getIt<AuthLocalDataSourceImpl>(), getIt<AuthRemoteDataSourceImpl>()));
  getIt.registerLazySingleton(() => Login(getIt<AuthRepoImpl>()));
  getIt.registerLazySingleton(() => Logout(getIt<AuthRepoImpl>()));
  getIt.registerLazySingleton(() => Changepassword(getIt<AuthRepoImpl>()));
  getIt.registerFactory(() => AuthBloc(
        loginUsecase: getIt<Login>(),
        logoutUsecase: getIt<Logout>(),
        changePasswordUseCase: getIt<Changepassword>(),
      ));

  //patient
  getIt.registerLazySingleton<PatientLocalDataImpl>(
      () => PatientLocalDataImpl());
  getIt.registerLazySingleton<PatientRemoteDataImpl>(
      () => PatientRemoteDataImpl());
  getIt.registerLazySingleton<PatientRepoImpl>(() => PatientRepoImpl(
        getIt<PatientLocalDataImpl>(),
        getIt<PatientRemoteDataImpl>(),
      ));
  getIt.registerLazySingleton(() => GetPatientInfo(getIt<PatientRepoImpl>()));
  getIt.registerFactory(() => PatientCubit(getIt<GetPatientInfo>()));

  //appointment
  getIt.registerLazySingleton<AppointmentRemoteDataImpl>(
      () => AppointmentRemoteDataImpl());
  getIt.registerLazySingleton<AppointmentRepoImpl>(() => AppointmentRepoImpl(
      appointmentRemoteData: getIt<AppointmentRemoteDataImpl>()));
  getIt.registerLazySingleton(
      () => FetchAppointment(getIt<AppointmentRepoImpl>()));
  getIt.registerLazySingleton(
      () => ConfirmRescheduledAppointment(getIt<AppointmentRepoImpl>()));
  getIt.registerLazySingleton(
      () => CancelReschedule(getIt<AppointmentRepoImpl>()));
  getIt.registerLazySingleton(
      () => RequestAppointment(getIt<AppointmentRepoImpl>()));
  getIt.registerLazySingleton(
      () => RescheduleAppointment(getIt<AppointmentRepoImpl>()));
  getIt.registerFactory(() => AppointmentBloc(
        fetchAppointment: getIt<FetchAppointment>(),
        requestAppointment: getIt<RequestAppointment>(),
        rescheduleAppointment: getIt<RescheduleAppointment>(),
        confirmRescheduledAppointment: getIt<ConfirmRescheduledAppointment>(),
        cancelRescheduleAppointment: getIt<CancelReschedule>(),
      ));

  //schedule ( dapartment & doctor)
  getIt.registerLazySingleton<ScheduleRemoteImpl>(() => ScheduleRemoteImpl());
  //department
  getIt.registerLazySingleton<DepartmentRepository>(() =>
      DepartmentRepositoryImpl(remoteDataSource: getIt<ScheduleRemoteImpl>()));
  getIt.registerFactory(
      () => DepartmentBloc(repository: getIt<DepartmentRepositoryImpl>()));
  //doctor
  getIt.registerLazySingleton<DoctorRepositoryImpl>(() =>
      DoctorRepositoryImpl(remoteDataSource: getIt<ScheduleRemoteImpl>()));
  getIt.registerFactory(
      () => DoctorBloc(repository: getIt<DoctorRepositoryImpl>()));

  //recommendations
  getIt.registerLazySingleton<RecomRemoteDataImpl>(() => RecomRemoteDataImpl());
  getIt.registerLazySingleton<RecommendationRepoImpl>(
      () => RecommendationRepoImpl(getIt<RecomRemoteDataImpl>()));
  getIt.registerFactory(
      () => RecommendationCubit(getIt<RecommendationRepoImpl>()));
}
