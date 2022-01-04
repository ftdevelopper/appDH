part of 'shippings_bloc.dart';

@immutable
abstract class ShippingsState extends Equatable {
  const ShippingsState();

  @override
  List<Object?> get props => [];
}

class ShippingsInitial extends ShippingsState {}

class ShippingsLoading extends ShippingsState {
  @override
  String toString() => 'Shippings Loading';
}

class ShippingsLoaded extends ShippingsState {
  final List<Shipping> shippings;

  const ShippingsLoaded({required this.shippings});

  @override
  List<Object?> get props => [shippings];

  @override
  String toString() => 'Shippings Loaded';
}

class ShippingsNotLoaded extends ShippingsState {
  @override
  String toString() => 'Shippings Not Loaded';
}
