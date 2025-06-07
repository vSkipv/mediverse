import 'package:flutter/foundation.dart';

class NewDoctor{

  String firstName;
  String lastName;
  String description;
  String city;
  String country;
  String fullAdress;
  String password;
  String specialist;

  NewDoctor({required this.firstName, required this.lastName, required this.description, required this.city,
      required this.country, required this.fullAdress, required this.password, required this.specialist});

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
     specialist: json["specialist"]
   );
 }

 Map<String,dynamic> toJson(){
   return{
     "firstName":firstName,
     "lastName": lastName,
     "description": description,
     "city": city,
     "country": country,
     "fullAdress": fullAdress,
     "password": password,
     "specialist": specialist
   };
 }

}