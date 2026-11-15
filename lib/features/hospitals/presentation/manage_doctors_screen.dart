import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:careslot/features/doctors/doctor_providers.dart';
import 'package:careslot/features/doctors/presentation/add_doctor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageDoctorsScreen extends ConsumerWidget {
  const ManageDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(hospitalDoctorsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Doctors')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddDoctorScreen()),
          );
        },
        label: const Text('Add Doctor'),
        icon: const Icon(Icons.person_add_alt_1),
      ),
      body: doctorsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                const Text(
                  'Unable to load doctors.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(hospitalDoctorsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (doctors) {
          if (doctors.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 56,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No doctors found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Doctors assigned to your hospital will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _DoctorCard(doctor: doctors[index]);
            },
          );
        },
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildProfileImage(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(doctor.specialty),
                  const SizedBox(height: 8),
                  if (doctor.consultationFee != null)
                    Text(
                      'Consultation fee: ₹${doctor.consultationFee!.toStringAsFixed(0)}',
                    ),
                  const SizedBox(height: 8),
                  _buildAvailabilityStatus(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = doctor.profileImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 30,
        child: Icon(Icons.person_outline, size: 30),
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (_, _) {},
      child: null,
    );
  }

  Widget _buildAvailabilityStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: doctor.isAvailable ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 6),
        Text(
          doctor.isAvailable ? 'Available' : 'Unavailable',
          style: TextStyle(
            color: doctor.isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
