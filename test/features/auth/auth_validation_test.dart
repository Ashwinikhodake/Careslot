import 'package:careslot/features/auth/auth_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidation.name', () {
    test('rejects an empty name', () {
      expect(AuthValidation.name(''), isNotNull);
    });

    test('rejects a name shorte than two characters', () {
      expect(AuthValidation.name('A'), isNotNull);
    });

    test('accepts a valid name', () {
      expect(AuthValidation.name('Ashwini'), isNull);
    });
  });

  group('AuthValidation.email', () {
    test('rejects an empty email', () {
      expect(AuthValidation.email(''), isNotNull);
    });

    test('rejects an invalid email', () {
      expect(AuthValidation.email('invalid-email'), isNotNull);
    });

    test('accepts a valid email', () {
      expect(AuthValidation.email('patient@example.com'), isNull);
    });
  });

  group('AuthValidation.password', () {
    test('rejects an empty password', () {
      expect(AuthValidation.password(''), isNotNull);
    });

    test('rejects an short password', () {
      expect(AuthValidation.password('abc123'), isNotNull);
    });

    test('accepts a password with eight characters', () {
      expect(AuthValidation.password('abc12345'), isNull);
    });
  });
}
