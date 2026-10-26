import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:careslot/features/doctors/doctor_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorListScreen extends ConsumerWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(availableDoctorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Doctor')),
      body: doctorsAsync.when(
        data: (doctors) {
          if (doctors.isEmpty) {
            return const Center(
              child: Text('No doctors are available right now.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return DoctorCard(doctor: doctor);
            },
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('Unable to load doctors. Please try again.'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});

  final DoctorModel doctor;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: doctor.profileImageUrl != null
              ? NetworkImage(doctor.profileImageUrl!)
              : null,
          child: doctor.profileImageUrl == null
              ? const Icon(Icons.person_outline)
              : null,
        ),
        title: Text(doctor.name),
        subtitle: Text(doctor.specialty),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Selected Dr. ${doctor.name}. Booking will be added next.',
              ),
            ),
          );
        },
      ),
    );
  }
}
