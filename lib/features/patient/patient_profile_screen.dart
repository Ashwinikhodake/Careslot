import 'package:flutter/material.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({
    super.key,
    required this.patientName,
    required this.email,
  });

  final String patientName;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 42,
                child: Icon(Icons.person, size: 42),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                patientName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 32),
            Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(patientName, style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 24),
            Text(
              'Email Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(email, style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 24),
            Text('Account Role', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Patient', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
