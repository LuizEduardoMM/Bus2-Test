import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'modules/core/injection/injection.config.dart';
import 'modules/core/injection/injection.dart';
import 'modules/home/presentation/cubit/home_page_cubit.dart';
import 'modules/home/presentation/pages/home_page.dart';

void main() {
  final getIt = GetIt.instance;
  $initGetIt(getIt);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus2 Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),

      home: BlocProvider.value(value: getIt<HomePageCubit>(), child: HomePage()),
    );
  }
}
