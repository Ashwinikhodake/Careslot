import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/auth/auth_screen.dart';
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
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Signed in as $role'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await ref.read(authRepositoryProvider).signOut();
                          },
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
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
