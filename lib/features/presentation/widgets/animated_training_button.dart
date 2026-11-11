import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedTrainingButton extends StatelessWidget {
  final bool isTraining;
  final VoidCallback onPressed;
  final bool isConverged;
  final String gate;

  const AnimatedTrainingButton({
    super.key,
    required this.isTraining,
    required this.onPressed,
    this.isConverged = false,
    required this.gate,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.92 + (animationValue * 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isConverged
                    ? [Colors.greenAccent, Colors.green]
                    : [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(32.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(32.r),
                onTap: isTraining ? null : onPressed,
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          _getIcon(),
                          key: ValueKey(_getIcon()),
                          size: 34.r,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          child: Text(_getLabel(), overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      if (isTraining) ...[
                        SizedBox(width: 16.w),
                        SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon() {
    if (isConverged) return Icons.verified_rounded;
    if (isTraining) return Icons.bolt_rounded;
    return Icons.play_arrow_rounded;
  }

  String _getLabel() {
    if (isConverged) return "Training Complete!";
    if (isTraining) return "Training...";
    return "Start Training";
  }
}
