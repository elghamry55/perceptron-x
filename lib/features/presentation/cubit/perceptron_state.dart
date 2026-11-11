import 'package:equatable/equatable.dart';
import '../../perceptron/data/models/epoch_snapshot.dart';
import '../../perceptron/data/models/training_point.dart';

abstract class PerceptronState extends Equatable {
  const PerceptronState();

  @override
  List<Object?> get props => [];
}

class PerceptronInitial extends PerceptronState {}

class PerceptronDataLoaded extends PerceptronState {
  final List<TrainingPoint> dataset;
  final String gate;

  const PerceptronDataLoaded(this.dataset, this.gate);

  @override
  List<Object?> get props => [dataset, gate];
}

class PerceptronTrainingStarted extends PerceptronState {}

class PerceptronEpochCompleted extends PerceptronState {
  final EpochSnapshot snapshot;
  final List<EpochSnapshot> history;
  final int currentEpoch;
  final int totalEpochs;
  final bool isConverged;

  const PerceptronEpochCompleted({
    required this.snapshot,
    required this.history,
    required this.currentEpoch,
    required this.totalEpochs,
    required this.isConverged,
  });

  @override
  List<Object?> get props => [
    snapshot,
    history,
    currentEpoch,
    totalEpochs,
    isConverged,
  ];
}

class PerceptronTrainingFinished extends PerceptronState {
  final EpochSnapshot finalSnapshot;
  final List<EpochSnapshot> history;
  final String gate;

  const PerceptronTrainingFinished({
    required this.finalSnapshot,
    required this.history,
    required this.gate,
  });

  @override
  List<Object?> get props => [
    finalSnapshot,
    history,
    gate,
  ];
}
