import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../perceptron/data/models/epoch_snapshot.dart';
import '../widgets/decision_boundary_painter.dart';

class VisualizationScreen extends StatefulWidget {
  final List<EpochSnapshot> history;
  final String gate;

  const VisualizationScreen({
    super.key,
    required this.history,
    required this.gate,
  });

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  int selectedEpoch = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _autoPlay();
  }

  void _autoPlay() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (selectedEpoch < widget.history.length - 1) {
        setState(() => selectedEpoch++);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = widget.history[selectedEpoch];
    final finalSnapshot = widget.history.last;
    final isXor = widget.gate == "XOR";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 30.r),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "${widget.gate} Gate",
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A1B9A), Color(0xFF311B92)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Decision Boundary
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.r),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: DecisionBoundaryPainter(
                          w1: finalSnapshot.w1,
                          w2: finalSnapshot.w2,
                          w0: finalSnapshot.w0,
                          points: finalSnapshot.dataset,
                          isXor: isXor,
                          extraWeights: finalSnapshot.extraWeights,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Weights Section
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Epoch ${snapshot.epoch}",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isXor) ...[
                                  _buildWeight("w₁", snapshot.w1),
                                  _buildWeight("w₂", snapshot.w2),
                                  _buildWeight("w₀ (Bias)", snapshot.w0),
                                ] else ...[
                                  _weightSection(
                                    "Hidden Neuron 1",
                                    snapshot.w1,
                                    snapshot.w2,
                                    snapshot.w0,
                                  ),
                                  _weightSection(
                                    "Hidden Neuron 2",
                                    snapshot.extraWeights?['w21'] ?? 0,
                                    snapshot.extraWeights?['w22'] ?? 0,
                                    snapshot.extraWeights?['b2'] ?? 0,
                                  ),
                                  _weightSection(
                                    "Output Neuron",
                                    snapshot.extraWeights?['wo1'] ?? 0,
                                    snapshot.extraWeights?['wo2'] ?? 0,
                                    snapshot.extraWeights?['bo'] ?? 0,
                                    isOutput: true,
                                  ),
                                ],
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _infoChip(
                                        "Errors",
                                        "${snapshot.errors}",
                                        snapshot.errors == 0
                                            ? Colors.greenAccent
                                            : Colors.orangeAccent,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: _infoChip(
                                        "Accuracy",
                                        snapshot.errors == 0 ? "100%" : "Training",
                                        snapshot.errors == 0
                                            ? Colors.greenAccent
                                            : Colors.cyanAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Error Curve
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: widget.history
                                .asMap()
                                .entries
                                .map(
                                  (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.errors.toDouble(),
                              ),
                            )
                                .toList(),
                            isCurved: true,
                            color: Colors.redAccent,
                            barWidth: 4,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.redAccent.withOpacity(0.25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Epoch Slider
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.cyan,
                    inactiveTrackColor: Colors.white30,
                    thumbColor: Colors.white,
                    overlayColor: Colors.cyan.withOpacity(0.3),
                  ),
                  child: Slider(
                    value: selectedEpoch.toDouble(),
                    min: 0,
                    max: (widget.history.length - 1).toDouble(),
                    divisions: widget.history.length - 1,
                    label: "Epoch $selectedEpoch",
                    onChanged: (double value) {
                      setState(() => selectedEpoch = value.round());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _weightSection(
      String title,
      double w1,
      double w2,
      double b, {
        bool isOutput = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            color: isOutput ? Colors.greenAccent : Colors.cyanAccent,
          ),
        ),
        _buildWeight("  • w₁", w1),
        _buildWeight("  • w₂", w2),
        _buildWeight("  • bias", b),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildWeight(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 17.sp, color: Colors.white70)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              value.toStringAsFixed(4),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.white60, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
