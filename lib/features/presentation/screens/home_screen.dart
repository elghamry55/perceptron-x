import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/perceptron_cubit.dart';
import 'training_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFF4A148C)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.psychology,
                      size: 70.r,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "PerceptronX",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          blurRadius: 20,
                          color: Colors.white.withOpacity(0.6),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Visual Perceptron Trainer\nLearn How Neural Networks Begin",
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),
                  _gateButton(
                    context: context,
                    gate: "AND",
                    title: "AND Gate",
                    subtitle: "Logical Conjunction",
                    icon: Icons.join_inner_rounded,
                    color: const Color(0xFF42A5F5),
                  ),
                  SizedBox(height: 20.h),
                  _gateButton(
                    context: context,
                    gate: "NAND",
                    title: "NAND Gate",
                    subtitle: "Universal Logic Gate",
                    icon: Icons.difference_rounded,
                    color: const Color(0xFFAB47BC),
                  ),
                  SizedBox(height: 20.h),
                  _gateButton(
                    context: context,
                    gate: "XOR",
                    title: "XOR Gate",
                    subtitle: "Non-Linearly Separable",
                    icon: Icons.auto_awesome,
                    color: const Color(0xFFFF5252),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gateButton({
    required BuildContext context,
    required String gate,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 120.h,
      child: ElevatedButton(
        onPressed: () {
          context.read<PerceptronCubit>().reset();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TrainingScreen(gate: gate),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 20,
          shadowColor: color.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(icon, size: 35.r),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 30.r),
          ],
        ),
      ),
    );
  }
}
