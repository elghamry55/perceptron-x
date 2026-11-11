import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/presentation/cubit/perceptron_cubit.dart';
import 'features/presentation/screens/home_screen.dart';

void main() {
  runApp(const PerceptronXPro());
}

class PerceptronXPro extends StatelessWidget {
  const PerceptronXPro({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (_) => PerceptronCubit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "PerceptronX Pro",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
