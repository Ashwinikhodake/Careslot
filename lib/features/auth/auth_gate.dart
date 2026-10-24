import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/auth/auth_screen.dart';
import 'package:careslot/features/patient/patient_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const AuthScreen();
        }
        return ref
            .watch(userProfileProvider)
            .when(
              data: (profile) {
                if (profile == null) {
                  return const Scaffold(
                    body: Center(
                      child: Text(
                        'User profile not found. Please contact support.',
                      ),
                    ),
                  );
                }
                final role = profile['role'];
                if (role != 'patient' &&
                    role != 'doctor' &&
                    role != 'hospital') {
                  return const Scaffold(
                    body: Center(
                      child: Text('Invalid user role. Please contact support.'),
                    ),
                  );
                }

                if (role == 'patient') {
                  final name = profile['name'] as String? ?? 'Patient';
                  return PatientDashboard(patientName: name);
                }
                return Scaffold(
                  body: Center(
                    child: Text('Dashboard for $role is comming soon.'),
                  ),
                );
              },
              error: (erro, stackTrace) => const Scaffold(
                body: Center(
                  child: Text(
                    'Unable to load your profile. Please try again later.',
                  ),
                ),
              ),
              loading: () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
      },

      error: (error, stackTrace) => const Scaffold(
        body: Center(child: Text('Unable to check authentication status.')),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
