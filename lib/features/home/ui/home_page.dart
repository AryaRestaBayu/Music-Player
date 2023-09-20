import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/features/bottom_player/bloc/bottom_player_bloc.dart';
import 'package:music_player/features/bottom_player/ui/bottom_sheet_player.dart';
import 'package:music_player/data/datasource/list_music.dart';

import '../../bottom_player/ui/bottom_player.dart';
import '../bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textStyle = TextStyle(color: Colors.white);
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    context.read<HomeBloc>().add(HomeLoadEvent(listMusic));
    context.read<BottomPlayerBloc>().add(BottomPlayerLoadAudioSourceEvent());
    _audioPlayer = context.read<BottomPlayerBloc>().audioPlayer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadedState) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      itemCount: state.listMusic.length,
                      itemBuilder: (context, index) {
                        final music = state.listMusic[index];
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<BottomPlayerBloc>()
                                .add(BottomPlayerSeekToEvent(index));
                          },
                          child:
                              BlocBuilder<BottomPlayerBloc, BottomPlayerState>(
                            builder: (context, state) {
                              if (state is BottomPlayerPlayingState ||
                                  state is BottomPlayerPausedState) {
                                return StreamBuilder<SequenceState?>(
                                    stream: _audioPlayer.sequenceStateStream,
                                    builder: (context, snapshot) {
                                      return Text(
                                        music.title,
                                        style: textStyle.copyWith(
                                            fontSize: 18,
                                            color: index ==
                                                    _audioPlayer.currentIndex
                                                ? Colors.red
                                                : Colors.white),
                                      );
                                    });
                              }
                              return Text(
                                music.title,
                                style: textStyle.copyWith(fontSize: 18),
                              );
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Column(
                          children: [
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Error'));
                }
              },
            ),
            const BottomSheetPlayer()
          ],
        ),
      ),
    );
  }
}
