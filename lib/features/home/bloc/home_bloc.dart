import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/model/music.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadEvent>((event, emit) {
      emit(HomeLoadedState(event.listMusic));
    });
  }
}
