import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../perceptron/data/models/epoch_snapshot.dart';

class EpochHistoryDialog extends StatefulWidget {
  final List<EpochSnapshot> history;
  final String gate;

  const EpochHistoryDialog({
    super.key,
    required this.history,
    required this.gate,
  });

  @override
  State<EpochHistoryDialog> createState() => _EpochHistoryDialogState();
}

class _EpochHistoryDialogState extends State<EpochHistoryDialog> {
  EpochSnapshot? selectedSnapshot;

  @override
  void initState() {
    super.initState();
    if (widget.history.isNotEmpty) {
      selectedSnapshot = widget.history.last;
    }
  }

  bool get isXor => widget.gate == "XOR";

  // ألوان موحدة
  final Color primaryColor = Color(0xFF6A1B9A);
  final Color secondaryColor = Color(0xFF8E24AA);
  final Color accentColor = Colors.cyanAccent;
  final Color successColor = Colors.greenAccent;
  final Color warningColor = Colors.orangeAccent;
  final Color lastEpochColor = Colors.yellowAccent; // لون مميز للـ Epoch الأخير
  final Color whiteText = Colors.white70;
  final Color bgLight = Colors.white12;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 720.h, minHeight: 520.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgLight, bgLight.withOpacity(0.6)],
          ),
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isXor
                          ? [warningColor.withOpacity(0.9), warningColor.withOpacity(0.7)]
                          : [accentColor.withOpacity(0.8), secondaryColor.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isXor ? Icons.auto_awesome : Icons.history_rounded,
                        color: Colors.white,
                        size: 28.r,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          isXor ? "XOR Training History (MLP 2-2-1)" : "Training History Timeline",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Table
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: bgLight,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 20.w,
                            dataRowHeight: 60.h,
                            headingRowHeight: 56.h,
                            headingTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                              fontSize: 14.sp,
                            ),
                            dataTextStyle: TextStyle(
                              fontSize: 13.5.sp,
                              color: whiteText,
                              height: 1.4,
                            ),
                            columns: _buildColumns(),
                            rows: widget.history.asMap().entries.map((entry) {
                              final snapshot = entry.value;
                              final isSelected = selectedSnapshot == snapshot;
                              final isConverged = snapshot.errors == 0;
                              final isLastEpoch = entry.key == widget.history.length - 1;

                              return DataRow(
                                selected: isSelected,
                                color: MaterialStateProperty.resolveWith((states) {
                                  if (isSelected) {
                                    return isXor
                                        ? warningColor.withOpacity(0.3)
                                        : accentColor.withOpacity(0.3);
                                  }
                                  if (isLastEpoch) {
                                    return lastEpochColor.withOpacity(0.3);
                                  }
                                  return null;
                                }),
                                onSelectChanged: (_) => setState(() => selectedSnapshot = snapshot),
                                cells: _buildCells(snapshot, isConverged, isLastEpoch),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    if (isXor) {
      return const [
        DataColumn(label: Text("Epoch")),
        DataColumn(label: Text("w11")),
        DataColumn(label: Text("w12")),
        DataColumn(label: Text("b1")),
        DataColumn(label: Text("w21")),
        DataColumn(label: Text("w22")),
        DataColumn(label: Text("b2")),
        DataColumn(label: Text("wo1")),
        DataColumn(label: Text("wo2")),
        DataColumn(label: Text("bo")),
        DataColumn(label: Text("Errors")),
      ];
    } else {
      return const [
        DataColumn(label: Text("Epoch")),
        DataColumn(label: Text("w₁")),
        DataColumn(label: Text("w₂")),
        DataColumn(label: Text("w₀")),
        DataColumn(label: Text("Errors")),
      ];
    }
  }

  List<DataCell> _buildCells(EpochSnapshot snapshot, bool isConverged, bool isLastEpoch) {
    final extra = snapshot.extraWeights ?? {};
    final Color errorColor = isConverged
        ? successColor
        : isLastEpoch
        ? lastEpochColor
        : warningColor;

    if (isXor) {
      return [
        DataCell(Text("${snapshot.epoch}", style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(snapshot.w1.toStringAsFixed(3))),
        DataCell(Text(snapshot.w2.toStringAsFixed(3))),
        DataCell(Text(snapshot.w0.toStringAsFixed(3))),
        DataCell(Text((extra['w21'] ?? 0).toStringAsFixed(3))),
        DataCell(Text((extra['w22'] ?? 0).toStringAsFixed(3))),
        DataCell(Text((extra['b2'] ?? 0).toStringAsFixed(3))),
        DataCell(Text((extra['wo1'] ?? 0).toStringAsFixed(3), style: TextStyle(color: accentColor))),
        DataCell(Text((extra['wo2'] ?? 0).toStringAsFixed(3), style: TextStyle(color: accentColor))),
        DataCell(Text((extra['bo'] ?? 0).toStringAsFixed(3), style: TextStyle(color: accentColor))),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "${snapshot.errors}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: errorColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ];
    } else {
      return [
        DataCell(Text("${snapshot.epoch}", style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(snapshot.w1.toStringAsFixed(3))),
        DataCell(Text(snapshot.w2.toStringAsFixed(3))),
        DataCell(Text(snapshot.w0.toStringAsFixed(3))),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6),
            decoration: BoxDecoration(
              color: errorColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              "${snapshot.errors}",
              style: TextStyle(fontWeight: FontWeight.bold, color: errorColor),
            ),
          ),
        ),
      ];
    }
  }
}
