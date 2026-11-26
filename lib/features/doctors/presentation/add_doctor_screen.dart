import 'package:careslot/features/auth/auth_providers.dart';
import 'package:careslot/features/doctors/doctor_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDoctorScreen extends ConsumerStatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  ConsumerState<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends ConsumerState<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _spacialtyController = TextEditingController();
  final _feeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _spacialtyController.dispose();
    _feeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _addDoctor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final userProfile = await ref.read(userProfileProvider.future);
      if (userProfile == null ||
          userProfile['role'] != 'hospital' ||
          userProfile['hospitalId'] is! String) {
        throw StateError('Hospital profile not found.');
      }

      final hospitalId = userProfile['hospitalId'] as String;
      final feeText = _feeController.text.trim();
      final fee = feeText.isEmpty ? null : double.parse(feeText);

      await ref
          .read(doctorRegistrationServiceProvider)
          .registerDoctor(
            name: _nameController.text,
            email: _emailController.text,
            specialty: _spacialtyController.text,
            hospitalId: hospitalId,
            profileImageUrl: _imageUrlController.text.trim().isEmpty
                ? null
                : _imageUrlController.text.trim(),
            consultationFee: fee,
          );

      ref.invalidate(hospitalDoctorsProvider);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Doctor created successfully. password reset email sent.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to add doctor: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Doctor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Doctor Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter doctor name.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email address.';
                  }
                  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _spacialtyController,
                decoration: const InputDecoration(
                  labelText: 'Spacialty',
                  prefixIcon: Icon(Icons.medical_services_outlined),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter doctor specialty.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Profile Image Url(optional)',
                  hintText: 'https://example.com/doctor.jpg',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                decoration: const InputDecoration(
                  labelText: 'Consultation Fee (Optional)',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final fee = double.tryParse(value.trim());

                  if (fee == null || fee < 0) {
                    return 'Enter a valid consultation fee.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _addDoctor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Doctor Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
