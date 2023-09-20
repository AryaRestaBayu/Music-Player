import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/bottom_player/ui/bottom_player.dart';
import 'package:music_player/data/model/music.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/bottom_player_bloc.dart';
import '../data/model/position_data.dart';

class BottomSheetPlayer extends StatefulWidget {
  const BottomSheetPlayer({super.key});

  @override
  State<BottomSheetPlayer> createState() => _BottomSheetPlayerState();
}

class _BottomSheetPlayerState extends State<BottomSheetPlayer> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    _audioPlayer = context.read<BottomPlayerBloc>().audioPlayer;
    super.initState();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            builder: (context) {
              return DetailMusic(
                  positionDataStream: _positionDataStream,
                  audioPlayer: _audioPlayer);
            });
      },
      child: BottomPlayer(
        audioPlayer: _audioPlayer,
        positionDataStream: _positionDataStream,
      ),
    );
  }
}

class DetailMusic extends StatelessWidget {
  const DetailMusic({
    super.key,
    required Stream<PositionData> positionDataStream,
    required AudioPlayer audioPlayer,
  })  : _positionDataStream = positionDataStream,
        _audioPlayer = audioPlayer;

  final Stream<PositionData> _positionDataStream;
  final AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: _audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data?.sequence.isEmpty ?? true) {
            return const Center(child: Text('Error'));
          }
          final music = data?.currentSource?.tag as Music;
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30))),
            height: 550,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.jpg',
                          image: music.imageUrl,
                          fit: BoxFit.cover,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<PositionData>(
                      stream: _positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        final position = positionData?.position;
                        if (position == null) {
                          return const SizedBox();
                        }
                        return ProgressBar(
                          barHeight: 6,
                          baseBarColor: Colors.black45,
                          timeLabelLocation: TimeLabelLocation.below,
                          timeLabelTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                          thumbColor: Colors.red,
                          thumbRadius: 6,
                          progressBarColor: Colors.red,
                          progress: position,
                          total: positionData?.duration ?? Duration.zero,
                          onSeek: _audioPlayer.seek,
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    music.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            context
                                .read<BottomPlayerBloc>()
                                .add(BottomPlayerSeekToPreviousEvent());
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.red,
                            size: 30,
                          )),
                      BlocBuilder<BottomPlayerBloc, BottomPlayerState>(
                        builder: (context, state) {
                          if (state is BottomPlayerPlayingState) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<BottomPlayerBloc>()
                                          .add(BottomPlayerPauseEvent());
                                    },
                                    icon: Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                      size: 28,
                                    )),
                              ),
                            );
                          } else if (state is BottomPlayerPausedState) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<BottomPlayerBloc>()
                                          .add(BottomPlayerPlayEvent());
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 28,
                                    )),
                              ),
                            );
                          } else {
                            return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.play_circle_fill));
                          }
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            context
                                .read<BottomPlayerBloc>()
                                .add(BottomPlayerSeekToNextEvent());
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.red,
                            size: 30,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
