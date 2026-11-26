import 'package:flutter/material.dart';

class DoctorProfileImage extends StatelessWidget {
  const DoctorProfileImage({required this.imageUrl, this.size = 60, super.key});
  final String? imageUrl;
  final double size;

  Widget _defaultAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F7FA),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: size * 0.55,
        color: const Color(0xFF0E7C86),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    if (url == null || url.isEmpty) {
      return _defaultAvatar();
    }
    return ClipOval(
      child: Image.network(
        url,
        height: size,
        width: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _defaultAvatar();
        },
      ),
    );
  }
}
