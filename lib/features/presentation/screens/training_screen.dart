import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/perceptron_cubit.dart';
import '../cubit/perceptron_state.dart';
import '../widgets/animated_training_button.dart';
import '../widgets/decision_boundary_painter.dart';
import '../widgets/epoch_history_dialog.dart';
import 'visualization_screen.dart';

class TrainingScreen extends StatelessWidget {
  final String gate;

  const TrainingScreen({super.key, required this.gate});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PerceptronCubit>();
    cubit.loadGateData(gate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 30.r),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Training $gate Gate",
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A1B9A), Color(0xFF4A148C), Color(0xFF311B92)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: BlocConsumer<PerceptronCubit, PerceptronState>(
              listener: (context, state) {
                if (state is PerceptronTrainingFinished) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => VisualizationScreen(
                        history: state.history,
                        gate: state.gate,
                      ),
                      transitionDuration: const Duration(milliseconds: 800),
                      transitionsBuilder: (_, a, __, child) =>
                          FadeTransition(opacity: a, child: child),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isTraining =
                    state is PerceptronEpochCompleted ||
                    state is PerceptronTrainingStarted;
                final isCompleted = state is PerceptronEpochCompleted;
                final snapshot = isCompleted
                    ? (state as PerceptronEpochCompleted).snapshot
                    : null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(22.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _paramBox("Learning Rate", "0.5", Icons.speed),
                              SizedBox(width: 16.w),
                              _paramBox(
                                "Max Epochs",
                                gate == "XOR" ? "500" : "100",
                                Icons.repeat,
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          AnimatedTrainingButton(
                            isTraining: isTraining,
                            isConverged:
                                isCompleted &&
                                (state as PerceptronEpochCompleted).isConverged,
                            gate: gate,
                            onPressed: () => cubit.startTraining(
                              learningRate: 0.5,
                              maxEpochsParam: gate == "XOR" ? 500 : 100,
                              gate: gate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      height: 300.h,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 25,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Live Decision Boundary",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.r),
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: DecisionBoundaryPainter(
                                  w1: snapshot?.w1 ?? 0.0,
                                  w2: snapshot?.w2 ?? 0.0,
                                  w0: snapshot?.w0 ?? 0.0,
                                  points: snapshot?.dataset ?? [],
                                  isXor: gate == "XOR",
                                  extraWeights: snapshot?.extraWeights,
                                ),
                                child: snapshot == null
                                    ? Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.play_circle_outline,
                                              size: 90.r,
                                              color: Colors.white60,
                                            ),
                                            SizedBox(height: 20.h),
                                            Text(
                                              "Press Start to Begin Training",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 24.h,
                          horizontal: 28.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(32.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Final Weights",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (!gate.contains("XOR")) ...[
                              _weightLine("w₁", snapshot!.w1),
                              _weightLine("w₂", snapshot.w2),
                              _weightLine("w₀ (Bias)", snapshot.w0),
                            ] else ...[
                              _weightLine("h1→w11", snapshot!.w1),
                              _weightLine("h1→w12", snapshot.w2),
                              _weightLine("h1→bias", snapshot.w0),
                              _weightLine(
                                "h2→w21",
                                snapshot.extraWeights?['w21'] ?? 0,
                              ),
                              _weightLine(
                                "h2→w22",
                                snapshot.extraWeights?['w22'] ?? 0,
                              ),
                              _weightLine(
                                "h2→bias",
                                snapshot.extraWeights?['b2'] ?? 0,
                              ),
                              Divider(color: Colors.white30),
                              _weightLine(
                                "out→wo1",
                                snapshot.extraWeights?['wo1'] ?? 0,
                                color: Colors.greenAccent,
                              ),
                              _weightLine(
                                "out→wo2",
                                snapshot.extraWeights?['wo2'] ?? 0,
                                color: Colors.greenAccent,
                              ),
                              _weightLine(
                                "out→bias",
                                snapshot.extraWeights?['bo'] ?? 0,
                                color: Colors.greenAccent,
                              ),
                            ],
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _infoChip(
                                  "Epoch ${state.currentEpoch}",
                                  Colors.cyanAccent,
                                ),
                                SizedBox(width: 5.w),
                                _infoChip(
                                  "${snapshot.errors} Error${snapshot.errors == 1 ? '' : 's'}",
                                  snapshot.errors == 0
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.history_rounded,
                                    size: 30.r,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (_) => EpochHistoryDialog(
                                      history: state.history,
                                      gate: gate,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _paramBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white70, size: 16.r),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weightLine(
    String label,
    double value, {
    Color color = Colors.cyanAccent,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18.sp, color: Colors.white70),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: color.withOpacity(0.7)),
            ),
            child: Text(
              value.toStringAsFixed(4),
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.withOpacity(0.8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
