import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_shipping_state.dart';

class EditShippingCubit extends Cubit<EditShippingState> {
  EditShippingCubit() : super(EditShippingInitial());
}
