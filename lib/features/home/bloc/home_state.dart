part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadedState extends HomeState {
  final List<Music> listMusic;

  HomeLoadedState(this.listMusic);
}
