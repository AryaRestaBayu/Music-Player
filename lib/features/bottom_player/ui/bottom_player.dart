import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/bottom_player/data/model/position_data.dart';
import 'package:music_player/data/model/music.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc/bottom_player_bloc.dart';

class BottomPlayer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Stream<PositionData> positionDataStream;
  const BottomPlayer({
    required this.audioPlayer,
    required this.positionDataStream,
    super.key,
  });

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  final textStyle = const TextStyle(color: Colors.white);
  // late AudioPlayer _audioPlayer;

  // @override
  // void initState() {
  //   _audioPlayer = context.read<BottomPlayerBloc>().audioPlayer;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 65,
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.music_note),
                ),
                SizedBox(
                  width: 150,
                  child: Center(
                    child: BlocBuilder<BottomPlayerBloc, BottomPlayerState>(
                      builder: (context, state) {
                        if (state is BottomPlayerPlayingState ||
                            state is BottomPlayerPausedState) {
                          return StreamBuilder<SequenceState?>(
                              stream: widget.audioPlayer.sequenceStateStream,
                              builder: (context, snapshot) {
                                final data = snapshot.data;
                                // final index = data?.currentIndex;
                                final musicItem =
                                    data?.currentSource?.tag == null
                                        ? null
                                        : data?.currentSource?.tag as Music;
                                if (data?.sequence.isEmpty ?? true) {
                                  return Text(
                                    'Choose Music First',
                                    style: textStyle.copyWith(fontSize: 17),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  );
                                }
                                return Text(
                                  musicItem!.title,
                                  style: textStyle.copyWith(fontSize: 17),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                );
                              });
                        } else {
                          return Text(
                            'Choose Music First',
                            style: textStyle.copyWith(fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          );
                        }
                      },
                    ),
                  ),
                ),
                BlocBuilder<BottomPlayerBloc, BottomPlayerState>(
                  builder: (context, state) {
                    if (state is BottomPlayerPlayingState) {
                      return IconButton(
                          onPressed: () {
                            context
                                .read<BottomPlayerBloc>()
                                .add(BottomPlayerPauseEvent());
                          },
                          icon: const Icon(Icons.pause_circle_filled_outlined));
                    } else if (state is BottomPlayerPausedState) {
                      return IconButton(
                          onPressed: () {
                            context
                                .read<BottomPlayerBloc>()
                                .add(BottomPlayerPlayEvent());
                          },
                          icon: const Icon(Icons.play_circle_fill_outlined));
                    } else {
                      return IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.play_circle_fill_outlined));
                    }
                  },
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            BlocBuilder<BottomPlayerBloc, BottomPlayerState>(
                builder: (context, state) {
              if (state is BottomPlayerPlayingState ||
                  state is BottomPlayerPausedState) {
                return StreamBuilder<PositionData>(
                    stream: widget.positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      final position = positionData?.position;
                      if (position == null) {
                        return const SizedBox();
                      }
                      return IgnorePointer(
                        ignoring: true,
                        child: ProgressBar(
                          barHeight: 4,
                          baseBarColor: Colors.grey[800],
                          timeLabelLocation: TimeLabelLocation.none,
                          thumbColor: Colors.red,
                          thumbRadius: 0,
                          progressBarColor: Colors.red,
                          progress: position,
                          total: positionData?.duration ?? Duration.zero,
                        ),
                      );
                    });
              } else {
                return SizedBox(
                  height: 4,
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
