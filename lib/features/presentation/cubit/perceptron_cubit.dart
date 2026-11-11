import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/perceptron_trainer.dart';
import '../../domain/mlp_trainer.dart';
import '../../perceptron/data/models/epoch_snapshot.dart';
import '../../perceptron/data/models/training_point.dart';
import 'perceptron_state.dart';

class PerceptronCubit extends Cubit<PerceptronState> {
  PerceptronCubit() : super(PerceptronInitial());

  final PerceptronTrainer perceptronTrainer = PerceptronTrainer();
  final MLPTrainer mlpTrainer = MLPTrainer();

  final List<TrainingPoint> _dataset = [];
  final List<EpochSnapshot> _history = [];
  late int maxEpochs;

  void loadGateData(String gate) {
    _dataset.clear();

    if (gate == "AND") {
      _dataset.addAll([
        TrainingPoint(x1: 0.0, x2: 0.0, target: 0),
        TrainingPoint(x1: 0.0, x2: 1.0, target: 0),
        TrainingPoint(x1: 1.0, x2: 0.0, target: 0),
        TrainingPoint(x1: 1.0, x2: 1.0, target: 1),
      ]);
    } else if (gate == "NAND") {
      _dataset.addAll([
        TrainingPoint(x1: 0.0, x2: 0.0, target: 1),
        TrainingPoint(x1: 0.0, x2: 1.0, target: 1),
        TrainingPoint(x1: 1.0, x2: 0.0, target: 1),
        TrainingPoint(x1: 1.0, x2: 1.0, target: 0),
      ]);
    } else if (gate == "XOR") {
      _dataset.addAll([
        TrainingPoint(x1: 0.0, x2: 0.0, target: 0),
        TrainingPoint(x1: 0.0, x2: 1.0, target: 1),
        TrainingPoint(x1: 1.0, x2: 0.0, target: 1),
        TrainingPoint(x1: 1.0, x2: 1.0, target: 0),
      ]);
    }

    emit(PerceptronDataLoaded(List.from(_dataset), gate));
  }

  Future<void> startTraining({
    required double learningRate,
    required int maxEpochsParam,
    required String gate,
  }) async {
    _history.clear();
    maxEpochs = maxEpochsParam;
    emit(PerceptronTrainingStarted());

    await Future.delayed(const Duration(milliseconds: 800));
    final bool isXor = gate == "XOR";
    List<EpochSnapshot> fullHistory;

    if (isXor) {
      fullHistory = mlpTrainer.trainWithHistory(
        data: List.from(_dataset),
        learningRate: learningRate,
        maxEpochs: maxEpochs,
        onEpochComplete: (epoch, errors) async {
          await Future.delayed(const Duration(milliseconds: 700));
          final currentSnapshot = mlpTrainer.trainWithHistory(
            data: _dataset,
            learningRate: learningRate,
            maxEpochs: maxEpochs,
            onEpochComplete: (_, __) {},
          ).last;

          _history.add(currentSnapshot);

          emit(PerceptronEpochCompleted(
            snapshot: currentSnapshot,
            history: List.from(_history),
            currentEpoch: epoch,
            totalEpochs: maxEpochs,
            isConverged: errors == 0,
          ));
        },
      );
    } else {
      fullHistory = perceptronTrainer.trainWithHistory(
        data: List.from(_dataset),
        learningRate: learningRate,
        maxEpochs: maxEpochs,
        onEpochComplete: (epoch, errors) async {
          await Future.delayed(const Duration(milliseconds: 700));
          final currentSnapshot = perceptronTrainer.trainWithHistory(
            data: _dataset,
            learningRate: learningRate,
            maxEpochs: maxEpochs,
            onEpochComplete: (_, __) {},
          ).last;

          _history.add(currentSnapshot);

          emit(PerceptronEpochCompleted(
            snapshot: currentSnapshot,
            history: List.from(_history),
            currentEpoch: epoch,
            totalEpochs: maxEpochs,
            isConverged: errors == 0,
          ));
        },
      );
    }

    _history.clear();
    _history.addAll(fullHistory);

    emit(PerceptronTrainingFinished(
      finalSnapshot: _history.last,
      history: List.from(_history),
      gate: gate,
    ));
  }

  int predict(double x1, double x2) {
    if ((state is PerceptronTrainingFinished) &&
        (state as PerceptronTrainingFinished).gate == "XOR") {
      final prob = mlpTrainer.predict(x1, x2);
      return prob >= 0.5 ? 1 : 0;
    } else {
      final net = perceptronTrainer.w1 * x1 +
          perceptronTrainer.w2 * x2 -
          perceptronTrainer.w0;
      return net > 0 ? 1 : 0;
    }
  }

  void reset() {
    _history.clear();
    perceptronTrainer.reset();
    mlpTrainer.reset();
    emit(PerceptronInitial());
  }
}
