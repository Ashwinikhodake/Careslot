import 'package:careslot/features/doctors/doctor_model.dart';
import 'package:careslot/features/doctors/doctor_providers.dart';
import 'package:careslot/features/doctors/widgets/doctor_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditDoctorScreen extends ConsumerStatefulWidget {
  const EditDoctorScreen({required this.doctor, super.key});
  final DoctorModel doctor;

  @override
  ConsumerState<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends ConsumerState<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _specialtyController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _feeController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.doctor.name);
    _specialtyController = TextEditingController(text: widget.doctor.specialty);
    _imageUrlController = TextEditingController(
      text: widget.doctor.profileImageUrl ?? '',
    );
    _feeController = TextEditingController(
      text: widget.doctor.consultationFee?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _imageUrlController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  Future<void> _saveDoctorProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSaving = true;
    });

    final feeText = _feeController.text.trim();
    final double? consultationFee = feeText.isEmpty
        ? null
        : double.parse(feeText);

    final imageUrl = _imageUrlController.text.trim();
    try {
      await ref
          .read(doctorRepositoryProvider)
          .updateDoctorProfile(
            doctorId: widget.doctor.id,
            name: _nameController.text,
            specialty: _specialtyController.text,
            profileImageUrl: imageUrl.isEmpty ? null : imageUrl,
            consultationFee: consultationFee,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor profile updated successfully.')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update doctor profile: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Doctor Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.doctor.email,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter doctor name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Spacialty',
                  prefixIcon: Icon(Icons.medical_services_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter spacialty';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Profile Image URL',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DoctorProfileImage(imageUrl: _imageUrlController.text, size: 100),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Consultation Fee',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final fee = double.tryParse(value.trim());

                  if (fee == null || fee < 0) {
                    return 'Enter a valid consultation fee';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveDoctorProfile,
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
