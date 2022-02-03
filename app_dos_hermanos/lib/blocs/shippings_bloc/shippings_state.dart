part of 'shippings_bloc.dart';

@immutable
abstract class ShippingsState extends Equatable {
  ShippingsState({this.filter});

  Filter? filter;
  @override
  List<Object?> get props => [filter];
}

class ShippingsInitial extends ShippingsState {
  ShippingsInitial() : super(filter: Filter());
  Filter? filter = Filter(duration: Duration(days: 3));
}

class ShippingsLoading extends ShippingsState {
  ShippingsLoading({this.filter}) : super(filter: filter);

  final Filter? filter;
  @override
  String toString() => 'Shippings Loading';
}

class ShippingsLoaded extends ShippingsState {
  ShippingsLoaded({required this.shippings, this.filter});

  final List<Shipping> shippings;
  final Filter? filter;

  @override
  List<Object?> get props => [shippings, filter];

  @override
  String toString() => 'Shippings Loaded';
}

class ShippingsNotLoaded extends ShippingsState {
  ShippingsNotLoaded({this.filter}) : super(filter: filter);
  Filter? filter;
  @override
  String toString() => 'Shippings Not Loaded';
}
