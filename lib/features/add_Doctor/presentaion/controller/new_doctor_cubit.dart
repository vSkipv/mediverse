import 'package:bloc/bloc.dart';
import 'package:mediverse/features/add_Doctor/data/repositories/new_doctor_repo.dart';
import 'package:mediverse/features/add_Doctor/presentaion/controller/new_doctor_state.dart';

import '../../data/model/new_doctor.dart';

class NewDoctorCubit extends Cubit<NewDoctorState>{
  final NewDoctorRepo newDoctorRepo;

  NewDoctorCubit( this.newDoctorRepo):super( NewDoctorInitialState());
  Future<void>addNewDoc({required NewDoctor newDoc})async{
    try{
      emit(NewDoctorLoadState());
      final response = await newDoctorRepo.addDoctor(doctor: newDoc);
      emit(NewDoctorSuccessState(response));
    }catch(e){
      emit(NewDoctorErrorState(e.toString()));
    }
  }

}