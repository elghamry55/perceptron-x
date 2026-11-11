import '../perceptron/data/models/epoch_snapshot.dart';
import '../perceptron/data/models/training_point.dart';

class PerceptronTrainer {
  double w1 = 0.0;
  double w2 = 0.0;
  double w0 = 0.0;

  void _initWeights() {
    final now = DateTime.now().microsecond;
    w1 = (now % 100) / 100 - 0.5;
    w2 = (now % 80) / 80 - 0.5;
    w0 = (now % 60) / 60 - 0.5;
  }

  List<EpochSnapshot> trainWithHistory({
    required List<TrainingPoint> data,
    required double learningRate,
    required int maxEpochs,
    required Function(int epoch, int errors) onEpochComplete,
  }) {
    final List<EpochSnapshot> history = [];
    _initWeights();

    history.add(EpochSnapshot(
      epoch: 0,
      w1: w1,
      w2: w2,
      w0: w0,
      errors: -1,
      dataset: List.from(data),
    ));

    for (int epoch = 1; epoch <= maxEpochs; epoch++) {
      int errors = 0;
      data.shuffle();
      final double currentLR = learningRate * (1.0 - epoch / maxEpochs);

      for (final point in data) {
        final double net = w1 * point.x1 + w2 * point.x2 - w0;
        final int prediction = net > 0 ? 1 : 0;
        final int error = point.target - prediction;

        if (error != 0) {
          errors++;
          w1 += currentLR * error * point.x1;
          w2 += currentLR * error * point.x2;
          w0 -= currentLR * error;
        }
      }

      history.add(EpochSnapshot(
        epoch: epoch,
        w1: w1,
        w2: w2,
        w0: w0,
        errors: errors,
        dataset: List.from(data),
      ));

      onEpochComplete(epoch, errors);
      if (errors == 0) break;
    }

    return history;
  }

  int predict(double x1, double x2) {
    final double net = w1 * x1 + w2 * x2 - w0;
    return net > 0 ? 1 : 0;
  }

  void reset() => _initWeights();
}
