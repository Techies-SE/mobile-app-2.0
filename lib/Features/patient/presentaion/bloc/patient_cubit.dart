import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/patient/domain/usecases/get_patient_info.dart';
import 'package:mobile_app_2/Features/patient/presentaion/bloc/patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final GetPatientInfo getInfo;

  PatientCubit(this.getInfo) : super(PatientInitial());

  Future<void> getPatientInfo() async {
    emit(PatientFetching());
    try {
      final patient =  await getInfo.call();
      emit(PatientFetchedSuccess(patient: patient));
    } catch (e) {
      emit(PatientFetchchedFailed(error: e.toString()));
    }
  }
}

