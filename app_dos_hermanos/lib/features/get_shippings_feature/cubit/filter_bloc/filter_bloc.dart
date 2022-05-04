import 'package:app_dos_hermanos/features/get_shippings_feature/models/filter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {

    on<ChangeDays>((event, emit) {
      state.filter.duration = Duration(days: event.days);
      print('New Filter by date: ${state.filter.duration}');
      emit(new UpdatedFilter(filter: state.filter, days: event.days));
    });

    on<ChangeDestination>((event, emit){
      state.filter.destination = event.destination;
      emit(UpdatedFilter(filter: state.filter, days: state.days));
    });

    on<ChangeOrigin>((event, emit){
      state.filter.origin = event.origin;
      emit(UpdatedFilter(filter: state.filter, days: state.days));
    });
  }
}
