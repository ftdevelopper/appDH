import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_shipping_state.dart';

class EditShippingCubit extends Cubit<EditShippingState> {
  EditShippingCubit() : super(EditShippingEmpty());
  
  void loadShipping(Shipping shipping){
    emit(EditShippingUpdate(shipping: shipping));
  }

  void updateShippingParameter(Shipping shipping){
    emit(EditShippingUpdate(shipping: state.shipping.copyWith(shipping)));
  }

  void uploadSihpping(){
    emit(EditShippingUploading(shipping: state.shipping));
    try {
      ShippingRepository().updateParameter(shipping: state.shipping);
    } catch (e) {
      emit(EditShippingFailUpload(shipping: state.shipping));
    }
  }
}
