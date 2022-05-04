part of 'filter_bloc.dart';

@immutable
abstract class FilterState extends Equatable {
  FilterState({required this.filter, required this.days});
  int days;
  Filter filter;

  @override
  // TODO: implement props
  List<Object?> get props => [this.filter, this.days];
}

class FilterInitial extends FilterState {
  FilterInitial() : super(filter: Filter(duration: Duration(days: 3)),days: 3);

  Filter filter = Filter(duration: Duration(days: 3));

  @override
  List<Object?> get props => [this.filter];
}

class UpdatedFilter extends FilterState {
  UpdatedFilter({required this.filter, required this.days}) 
  : super(filter: filter, days: days);

  Filter filter;
  final days;
  
  @override
  List<Object?> get props => [this.filter, this.days];
}