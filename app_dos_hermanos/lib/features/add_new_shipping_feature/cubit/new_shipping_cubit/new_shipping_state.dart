part of 'new_shipping_cubit.dart';

abstract class NewShippingState extends Equatable {
  const NewShippingState({required this.shipping});

  final Shipping shipping;

  @override
  List<Object> get props => [shipping];
}

class NewShippingEmpty extends NewShippingState {
  NewShippingEmpty() : super(shipping: Shipping());

  @override
  List<Object> get props => [shipping];
}

class NewShippingUploading extends NewShippingState {
  NewShippingUploading({required Shipping shipping}) : super(shipping: shipping);

  @override
  List<Object> get props => [shipping];
}

class NewShippingUpdate extends NewShippingState {
  NewShippingUpdate({required Shipping shipping}) : super(shipping: shipping);

  @override
  List<Object> get props => [shipping];
}

class NewShippingFailUpload extends NewShippingState {
  NewShippingFailUpload({required Shipping shipping}) : super(shipping: shipping);

  @override
  List<Object> get props => [shipping];
}