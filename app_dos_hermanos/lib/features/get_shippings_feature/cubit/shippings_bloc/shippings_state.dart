part of 'shippings_bloc.dart';

@immutable
abstract class ShippingsState extends Equatable {
  ShippingsState({this.filter, required this.shippingList});
  List<Shipping> shippingList;
  Filter? filter;
  @override
  List<Object?> get props => [filter, shippingList];
}

class ShippingsInitial extends ShippingsState {
  ShippingsInitial() : super(filter: Filter(), shippingList: []);
  Filter? filter = Filter(duration: Duration(days: 3));
}

class ShippingsLoading extends ShippingsState {
  ShippingsLoading({this.filter, required this.shippingList}) : super(filter: filter, shippingList: shippingList);
  
  List<Shipping> shippingList;
  final Filter? filter;
  @override
  String toString() => 'Shippings Loading';
}

class ShippingsLoaded extends ShippingsState {
  ShippingsLoaded({required this.shippings, this.filter}) : super(shippingList: shippings, filter: filter);

  final List<Shipping> shippings;
  final Filter? filter;

  @override
  List<Object?> get props => [shippings, filter];

  @override
  String toString() => 'Shippings Loaded';
}

class ShippingsNotLoaded extends ShippingsState {
  ShippingsNotLoaded({this.filter, required this.shippingList}) : super(filter: filter, shippingList: shippingList);
  
  List<Shipping> shippingList;
  Filter? filter;
  @override
  String toString() => 'Shippings Not Loaded';
}
