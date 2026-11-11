class TrainingPoint {
  final double x1;
  final double x2;
  final int target;

  TrainingPoint({
    required num x1,
    required num x2,
    required this.target,
  })  : x1 = x1.toDouble(),
        x2 = x2.toDouble();

  @override
  String toString() => '($x1, $x2) → $target';
}
