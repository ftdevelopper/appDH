part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent extends Equatable {}

class ChangeDays extends FilterEvent {
  ChangeDays({required this.days});

  final int days;
  @override
  List<Object?> get props => [this.days];
}

class ChangeDestination extends FilterEvent {
  ChangeDestination({required this.destination});

  final String? destination;

  @override
  List<Object?> get props => [this.destination];
}

class ChangeOrigin extends FilterEvent {
  ChangeOrigin({required this.origin});

  final String? origin;

  @override
  List<Object?> get props => [this.origin];
}
