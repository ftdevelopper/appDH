part of 'filter_bloc.dart';

@immutable
abstract class FilterState extends Equatable {
  FilterState({required this.days, required this.destination, required this.origin});

  final int days;
  final String? destination;
  final String? origin;
}

class FilterInitial extends FilterState {
  FilterInitial() : super(days: 2, destination: null, origin: null);

  @override
  List<Object?> get props => [this.days, this.destination, this.origin];
}

class UpdateFilter extends FilterState {
  UpdateFilter({required this.days, this.destination, this.origin}) 
  : super(days: days, destination: destination, origin: origin);

  final int days;
  final String? destination;
  final String? origin;
  
  @override
  List<Object?> get props => [this.days, this.destination, this.origin];
}
