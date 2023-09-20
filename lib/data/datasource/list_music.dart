import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/model/music.dart';

final listMusic = [
  Music(
      id: 1,
      title: 'Abadi',
      path: 'assets/abadi.mp3',
      imageUrl: 'https://i.ytimg.com/vi/C92RAUT5wsc/maxresdefault.jpg'),
  Music(
      id: 2,
      title: 'Somebody`s Pleasure',
      path: 'assets/pleasure.mp3',
      imageUrl:
          'https://linkstorage.linkfire.com/medialinks/images/b476a1f1-cea2-47be-bf7c-649edcb2074c/artwork-440x440.jpg'),
];

final listAudioSource = ConcatenatingAudioSource(children: [
  AudioSource.uri(Uri.parse('asset:///assets/abadi.mp3'),
      tag: Music(
          id: 1,
          title: 'Abadi',
          path: '',
          imageUrl: 'https://i.ytimg.com/vi/C92RAUT5wsc/maxresdefault.jpg')),
  AudioSource.uri(Uri.parse('asset:///assets/pleasure.mp3'),
      tag: Music(
          id: 2,
          title: 'Somebody`s Pleasure',
          path: '',
          imageUrl:
              'https://linkstorage.linkfire.com/medialinks/images/b476a1f1-cea2-47be-bf7c-649edcb2074c/artwork-440x440.jpg')),
]);
