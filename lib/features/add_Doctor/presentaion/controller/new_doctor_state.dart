abstract class NewDoctorState{
  const NewDoctorState();
}

class NewDoctorInitialState extends NewDoctorState{

}

class NewDoctorLoadState extends NewDoctorState{

}

class NewDoctorSuccessState extends NewDoctorState{
  final Map<String, dynamic> data;
  NewDoctorSuccessState(this.data);
}

class NewDoctorErrorState extends NewDoctorState{
  final String message;
NewDoctorErrorState(this.message);
}