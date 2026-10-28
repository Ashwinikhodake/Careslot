import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/hospitals/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HospitalDashboard extends ConsumerWidget {
  const HospitalDashboard({super.key, required this.hospital});

  final HospitalModel hospital;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareSlot Hospital'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'hospital.name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('hospital.address'),
            const SizedBox(height: 4),
            Text('Contact: hospital.contactnumber'),
            const SizedBox(height: 4),
            Text('Email: hospital.email'),
            const SizedBox(height: 24),
            _buildManageDoctorsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildManageDoctorsCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.medical_services_outlined),
        title: const Text('Manage Doctors'),
        subtitle: const Text('Manage doctors profile and availability.'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Doctor management will be available soon.'),
            ),
          );
        },
      ),
    );
  }
}
