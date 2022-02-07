part of 'shippings_bloc.dart';

@immutable
abstract class ShippingsEvent extends Equatable{
  const ShippingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadShippings extends ShippingsEvent {
  LoadShippings({this.filter});
  final Filter? filter;

  @override
  List<Object?> get props => [filter];
}

class AddShipping extends ShippingsEvent {
  final Shipping shipping;

  AddShipping({required this.shipping});

  @override
  List<Object?> get props => [shipping];

  @override
  String toString() => 'Adding Post';
}

class ShippingsUpdated extends ShippingsEvent {
  final List<Shipping> shippingList;

  const ShippingsUpdated({required this.shippingList});

  @override
  List<Object?> get props => [shippingList];

  @override
  String toString() => 'Updated Shippings';
}

class UpdateShipping extends ShippingsEvent {
  UpdateShipping({required this.shipping});

  final Shipping shipping;

  @override
  List<Object?> get props => [shipping];
}
