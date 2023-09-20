part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeLoadEvent extends HomeEvent {
  final List<Music> listMusic;

  HomeLoadEvent(this.listMusic);
}
