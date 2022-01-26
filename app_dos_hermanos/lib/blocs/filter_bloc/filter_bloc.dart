import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {

    on<ChangeDays>((event, emit) {
      emit(UpdateFilter(days: event.days, destination: state.destination, origin: state.origin));
    });

    on<ChangeDestination>((event, emit){
      emit(UpdateFilter(days: state.days, destination: event.destination, origin: state.origin));
    });

    on<ChangeOrigin>((event, emit){
      emit(UpdateFilter(days: state.days, destination: state.destination, origin: event.origin));
    });
  }
}
