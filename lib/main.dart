import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyCFsYnn6AC-jpUAeDH9R0DEop-pATVAVsg",
            authDomain: "careslot-bd932.firebaseapp.com",
            projectId: "careslot-bd932",
            storageBucket: "careslot-bd932.firebasestorage.app",
            messagingSenderId: "425592125219",
            appId: "1:425592125219:web:21802b8140d29a4927be96",
          )
        : null,
  );
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareSlot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0E7C86),
      ),
      home: const Scaffold(body: Center(child: Text('Firebase connected'))),
    );
  }
}
