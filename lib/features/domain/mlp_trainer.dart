import 'dart:math' as math;
import '../perceptron/data/models/epoch_snapshot.dart';
import '../perceptron/data/models/training_point.dart';

class MLPTrainer {
  double w11 = 0, w12 = 0, b1 = 0;
  double w21 = 0, w22 = 0, b2 = 0;
  double wo1 = 0, wo2 = 0, bo = 0;

  double _dw11 = 0, _dw12 = 0, _db1 = 0;
  double _dw21 = 0, _dw22 = 0, _db2 = 0;
  double _dwo1 = 0, _dwo2 = 0, _dbo = 0;

  final double momentum = 0.9;
  final _random = math.Random();

  void _initWeights() {
    w11 = _randomNextDouble();
    w12 = _randomNextDouble();
    w21 = _randomNextDouble();
    w22 = _randomNextDouble();
    b1 = _randomNextDouble();
    b2 = _randomNextDouble();
    wo1 = _randomNextDouble();
    wo2 = _randomNextDouble();
    bo = _randomNextDouble();

    _zeroMomentum();
  }

  double _randomNextDouble() {
    return (_random.nextDouble() - 0.5);
  }

  void _zeroMomentum() {
    _dw11 = 0;
    _dw12 = 0;
    _db1 = 0;
    _dw21 = 0;
    _dw22 = 0;
    _db2 = 0;
    _dwo1 = 0;
    _dwo2 = 0;
    _dbo = 0;
  }

  double _sigmoid(double x) => 1 / (1 + math.exp(-x));

  double _sigmoidDeriv(double x) => x * (1 - x);

  List<EpochSnapshot> trainWithHistory({
    required List<TrainingPoint> data,
    required double learningRate,
    required int maxEpochs,
    required Function(int epoch, int errors) onEpochComplete,
  }) {
    final List<EpochSnapshot> history = [];

    _initWeights();

    history.add(_takeSnapshot(0, -1, data));

    for (int epoch = 1; epoch <= maxEpochs; epoch++) {
      int errors = 0;
      data.shuffle();

      for (final point in data) {
        double h1 = _sigmoid(w11 * point.x1 + w12 * point.x2 + b1);
        double h2 = _sigmoid(w21 * point.x1 + w22 * point.x2 + b2);
        double out = _sigmoid(wo1 * h1 + wo2 * h2 + bo);

        if ((out >= 0.5 ? 1 : 0) != point.target) errors++;

        double deltaOut = (point.target - out) * _sigmoidDeriv(out);
        double deltaH1 = deltaOut * wo1 * _sigmoidDeriv(h1);
        double deltaH2 = deltaOut * wo2 * _sigmoidDeriv(h2);

        wo1 += _update(learningRate, deltaOut * h1, _dwo1, (v) => _dwo1 = v);
        wo2 += _update(learningRate, deltaOut * h2, _dwo2, (v) => _dwo2 = v);
        bo += _update(learningRate, deltaOut, _dbo, (v) => _dbo = v);

        w11 += _update(
          learningRate,
          deltaH1 * point.x1,
          _dw11,
          (v) => _dw11 = v,
        );
        w12 += _update(
          learningRate,
          deltaH1 * point.x2,
          _dw12,
          (v) => _dw12 = v,
        );
        b1 += _update(learningRate, deltaH1, _db1, (v) => _db1 = v);

        w21 += _update(
          learningRate,
          deltaH2 * point.x1,
          _dw21,
          (v) => _dw21 = v,
        );
        w22 += _update(
          learningRate,
          deltaH2 * point.x2,
          _dw22,
          (v) => _dw22 = v,
        );
        b2 += _update(learningRate, deltaH2, _db2, (v) => _db2 = v);
      }

      if (epoch % 50 == 0 || errors == 0) {
        history.add(_takeSnapshot(epoch, errors, data));
      }

      onEpochComplete(epoch, errors);

      if (errors == 0) break;
    }

    return history;
  }

  double _update(
    double lr,
    double gradient,
    double prevDelta,
    Function(double) saveDelta,
  ) {
    double change = (lr * gradient) + (momentum * prevDelta);
    saveDelta(change);
    return change;
  }

  EpochSnapshot _takeSnapshot(int epoch, int errors, List<TrainingPoint> data) {
    return EpochSnapshot(
      epoch: epoch,
      w1: w11,
      w2: w12,
      w0: b1,
      errors: errors,
      dataset: List.from(data),
      extraWeights: {
        'w21': w21,
        'w22': w22,
        'b2': b2,
        'wo1': wo1,
        'wo2': wo2,
        'bo': bo,
      },
    );
  }

  double predict(double x1, double x2) {
    double h1 = _sigmoid(w11 * x1 + w12 * x2 + b1);
    double h2 = _sigmoid(w21 * x1 + w22 * x2 + b2);
    return _sigmoid(wo1 * h1 + wo2 * h2 + bo);
  }

  void reset() => _initWeights();
}
