import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/datasource/list_music.dart';

part 'bottom_player_event.dart';
part 'bottom_player_state.dart';

class BottomPlayerBloc extends Bloc<BottomPlayerEvent, BottomPlayerState> {
  final audioPlayer = AudioPlayer();

  BottomPlayerBloc() : super(BottomPlayerInitial()) {
    on<BottomPlayerLoadAudioSourceEvent>((event, emit) {
      if (audioPlayer.audioSource == null) {
        audioPlayer.setAudioSource(listAudioSource);
        audioPlayer.setLoopMode(LoopMode.all);
      }
      if (audioPlayer.audioSource?.sequence.length != listAudioSource.length) {
        audioPlayer.setAudioSource(listAudioSource);
        audioPlayer.setLoopMode(LoopMode.all);
      }
    });

    on<BottomPlayerPlayEvent>((event, emit) async {
      audioPlayer.play();
      emit(BottomPlayerPlayingState());
    });

    on<BottomPlayerPauseEvent>((event, emit) {
      audioPlayer.pause();
      emit(BottomPlayerPausedState());
    });

    on<BottomPlayerSeekToEvent>((event, emit) {
      if (!audioPlayer.playing) {
        audioPlayer.play();
        emit(BottomPlayerPlayingState());
      }
      audioPlayer.seek(Duration.zero, index: event.index);
    });

    on<BottomPlayerSeekToNextEvent>((event, emit) {
      if (!audioPlayer.playing) {
        audioPlayer.play();
        emit(BottomPlayerPlayingState());
      }
      audioPlayer.seekToNext();
    });

    on<BottomPlayerSeekToPreviousEvent>((event, emit) {
      if (!audioPlayer.playing) {
        audioPlayer.play();
        emit(BottomPlayerPlayingState());
      }
      audioPlayer.seekToPrevious();
    });
  }
}
