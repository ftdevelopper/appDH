part of 'shippings_bloc.dart';

@immutable
abstract class ShippingsEvent extends Equatable{
  const ShippingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadShippings extends ShippingsEvent {
  
}
