import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'main.dart';

class Display extends StatefulWidget {
  final String lat;
  final String long;

  const Display({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

late AnimationController
    iconController; // make sure u have flutter sdk > 2.12.0 (null safety)

bool isAnimated = false;
bool showPlay = true;
bool shopPause = false;
bool play=false;
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

class _DisplayState extends State<Display> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/Kozhikode_Song_Goodalochana_Title_(getmp3.pro).mp3"),
      autoStart: play,
      showNotification: true,
      respectSilentMode: false,
      volume: 100
    );
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.separated(
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              openmap(widget.lat, widget.long);
            },
            child: Column(
              children: [
                Container(
                  height: mheight * 0.40,
                  width: mwidth * 0.85,
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Image.file(images[index]),
                ),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          InkWell(
          child: Icon(Icons.skip_previous), onTap: () {
          audioPlayer.seekBy(Duration(seconds: -10));
          },),
          GestureDetector(
          onTap: () {
          AnimateIcon();
          },
          child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: iconController,
          size: 50,
          color: Colors.black,
          ),
          ),
          InkWell(
          child: Icon(Icons.skip_next), onTap: () {
          audioPlayer.seekBy(Duration(seconds: 10));
          audioPlayer.seek(Duration(seconds: 10));
          audioPlayer.next();
          },),
          ],
          ),

          ProgressBar(
          progress:Duration.zero,
          buffered:  Duration.zero,
          total:  Duration(milliseconds: 258986),
          progressBarColor: Colors.red,
          baseBarColor: Colors.white.withOpacity(0.24),
          bufferedBarColor: Colors.white.withOpacity(0.24),
          thumbColor: Colors.white,
          barHeight: 3.0,
          thumbRadius: 5.0,
          onSeek: (duration) {
          audioPlayer.seek(duration);
          },
          )]));

        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: mheight * 0.05,
          );
        },
      ),
    );
  }
  void AnimateIcon() {
    setState(() {
      isAnimated =!isAnimated;
play=!play;
      if (isAnimated) {
        iconController.forward();
        audioPlayer.play();
        audioPlayer.seek(Duration(milliseconds: 258986));
      } else {
        iconController.reverse();
        audioPlayer.pause();
      }
    });}

    Future<void> openmap(String lat, String long) async {
    String googleURL =
        "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch$googleURL';
  }
  @override
  void dispose() {
    iconController.dispose();
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
