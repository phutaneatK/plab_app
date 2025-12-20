import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_app/injection.dart';
import 'package:plab_app/presentation/nasa_history/bloc/nasa_history_bloc.dart';
import 'package:plab_app/presentation/nasa_history/cubit/nasa_search_query_cubit.dart';
import 'package:plab_app/presentation/nasa_history/pages/nasa_history_page.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Bloc - สร้างใหม่ทุกครั้ง (Factory)
        BlocProvider(
          create: (context) => getIt<NasaHistoryBloc>(),
        ),
        // Cubit - ใช้ instance เดียวกันทั้ง app (Singleton)
        BlocProvider(
          create: (context) => getIt<NasaSearchQueryCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Plab App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const NasaHistoryPage(),
      ),
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