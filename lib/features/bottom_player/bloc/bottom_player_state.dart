part of 'bottom_player_bloc.dart';

@immutable
sealed class BottomPlayerState {}

final class BottomPlayerInitial extends BottomPlayerState {}

final class BottomPlayerPlayingState extends BottomPlayerState {
  BottomPlayerPlayingState();
}

final class BottomPlayerPausedState extends BottomPlayerState {
  BottomPlayerPausedState();
}
