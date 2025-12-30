import 'package:flutter/material.dart';
import 'package:plab_app/injection.dart';
import 'package:plab_app/core/router/app_router.dart';

void main() {
  initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plab App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: PRouter.router,
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Page'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'Hello, Plab App!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}