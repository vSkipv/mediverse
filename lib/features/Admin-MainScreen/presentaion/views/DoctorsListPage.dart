import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api/api_service.dart';
import '../../data/model/doctor_model.dart';
import '../../data/repositories/doctors_repository_impl.dart';
import '../controller/cubit/doctors_cubit.dart';
import '../controller/cubit/doctors_state.dart';

class DoctorsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dio = Dio();
        final apiService = ApiService(dio);
        final repository = DoctorsRepositoryImpl(apiService: apiService);
        final cubit = DoctorsCubit(repository: repository);
        cubit.getAllDoctors();
        return cubit;
      },
      child: DoctorsListContent(),
    );
  }
}

class DoctorsListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Doctors List'),
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<DoctorsCubit, DoctorsState>(
        listener: (context, state) {
          if (state is DoctorDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Doctor deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DoctorDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoctorsLoaded) {
              if(state.doctors.isNotEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: state.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = state.doctors[index];
                    return _buildDoctorCard(context, doctor);
                  },
                );
              }else{
                return Center(
                  child: Text(
                    'No doctors available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
            } else if (state is DoctorsError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorAdmin doctor) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          '${doctor.firstName} ${doctor.lastName}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('Specialist: ${doctor.specialist}'),
            Text('Location: ${doctor.city}, ${doctor.country}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text('Delete Doctor'),
                content: Text('Are you sure you want to delete this doctor?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.read<DoctorsCubit>().deleteDoctor(doctor.id);
                    },
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
} 