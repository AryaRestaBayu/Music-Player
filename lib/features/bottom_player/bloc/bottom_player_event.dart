part of 'bottom_player_bloc.dart';

@immutable
sealed class BottomPlayerEvent {}

final class BottomPlayerLoadAudioSourceEvent extends BottomPlayerEvent {}

final class BottomPlayerPlayEvent extends BottomPlayerEvent {
  BottomPlayerPlayEvent();
}

final class BottomPlayerPauseEvent extends BottomPlayerEvent {
  BottomPlayerPauseEvent();
}

final class BottomPlayerSeekToEvent extends BottomPlayerEvent {
  final int index;

  BottomPlayerSeekToEvent(this.index);
}

final class BottomPlayerSeekToNextEvent extends BottomPlayerEvent {}

final class BottomPlayerSeekToPreviousEvent extends BottomPlayerEvent {}
