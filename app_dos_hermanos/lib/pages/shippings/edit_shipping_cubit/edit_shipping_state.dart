part of 'edit_shipping_cubit.dart';

abstract class EditShippingState extends Equatable {
  const EditShippingState({required this.shipping});

  final Shipping shipping;

  @override
  List<Object> get props => [shipping];
}

class EditShippingEmpty extends EditShippingState {
  EditShippingEmpty() : super(shipping: Shipping());
}

class EditShippingUploading extends EditShippingState {
  EditShippingUploading({required Shipping shipping}) : super(shipping: shipping);
}

class EditShippingUpdate extends EditShippingState {
  EditShippingUpdate({required this.shipping}) : super(shipping: shipping);
  final Shipping shipping;

  @override
  List<Object> get props => super.props;
}

class EditShippingFailUpload extends EditShippingState {
  EditShippingFailUpload({required Shipping shipping}) : super(shipping: shipping);
}
