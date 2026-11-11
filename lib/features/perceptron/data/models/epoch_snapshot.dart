import 'package:logic_ai/features/perceptron/data/models/training_point.dart';

class EpochSnapshot {
  final int epoch;
  final double w1;
  final double w2;
  final double w0;
  final int errors;
  final List<TrainingPoint> dataset;
  final Map<String, double>? extraWeights;

  const EpochSnapshot({
    required this.epoch,
    required this.w1,
    required this.w2,
    required this.w0,
    required this.errors,
    required this.dataset,
    this.extraWeights,
  });
}
