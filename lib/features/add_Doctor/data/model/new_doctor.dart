import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class NewDoctor{
  String firstName;
  String lastName;
  String description;
  String city;
  String country;
  String fullAdress;
  String password;
  String specialist;
  String email;
  String gender;
  File? image;
  String phoneNumber;

  NewDoctor({required this.firstName, required this.lastName, required this.description, required this.city,
      required this.country, required this.fullAdress, required this.password, required this.specialist, required this.email, required this.gender, this.image, required this.phoneNumber,});

 factory NewDoctor.fromJson(Map<String, dynamic> json){
   String firstName = json['firstName'] ?? '';
   String lastName = json['lastName'] ?? '';

   // If we have a name but not firstName/lastName (for backward compatibility)
   if ((firstName.isEmpty || lastName.isEmpty) && json['name'] != null) {
     List<String> nameParts = (json['name'] as String).split(' ');
     if (nameParts.isNotEmpty) {
       firstName = firstName.isNotEmpty ? firstName : nameParts[0];
       // Join the rest as last name if there are multiple parts
       lastName = lastName.isNotEmpty ? lastName :
       (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
     }
   }

   return NewDoctor(
     firstName: json["firstName"],
     lastName: json["lastName"],
     description: json["description"],
     city: json["city"],
     country: json["country"],
     fullAdress: json["fullAddress"],
     password: json["password"],
     specialist: json["specialist"],
     email: json["email"],
     gender: json["gender"],
     image: json["image"],
     phoneNumber: json["phoneNumber"],
   );
 }

 Map<String,dynamic> toJson(){
   return{
      "firstName": firstName,
      "lastName": lastName,
     "description": description,
     "city": city,
     "country": country,
     "fullAddress": fullAdress,
     "password": password,
      "specialist": specialist,
      "email": email,
      "gender": gender,
      "phoneNumber": phoneNumber,
    };
 }

  Future<FormData> toFormData() async {
    Map<String, dynamic> fields = {
      "firstName": firstName,
      "lastName": lastName,
      "description": description,
      "city": city,
      "country": country,
      "fullAddress": fullAdress,
      "password": password,
      "specialist": specialist,
      "email": email,
      "gender": gender,
      "phoneNumber": phoneNumber,
    };

    if (image != null) {
      String fileName = image!.path.split('/').last;
      fields["image"] = await MultipartFile.fromFile(
        image!.path,
        filename: fileName,
      );
    }

    return FormData.fromMap(fields);
  }
}
