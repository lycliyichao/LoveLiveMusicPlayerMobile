import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lovelivemusicplayer/generated/assets.dart';
import 'package:lovelivemusicplayer/global/const.dart';
import 'package:lovelivemusicplayer/global/global_global.dart';
import 'package:lovelivemusicplayer/global/global_player.dart';
import 'package:lovelivemusicplayer/models/Music.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/pages/home/widget/dialog_playlist.dart';
import 'package:lovelivemusicplayer/utils/color_manager.dart';
import 'package:lovelivemusicplayer/utils/image_util.dart';
import 'package:lovelivemusicplayer/utils/sd_utils.dart';
import 'package:lovelivemusicplayer/utils/text_style_manager.dart';
import 'package:marquee_text/marquee_text.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key, required this.onTap}) : super(key: key);
  final GestureTapCallback onTap;

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final scrollList = <Widget>[];
  ImageProvider? provider;
  double startPosition = 0;
  final maxWidth = ScreenUtil().screenWidth - 85.w - 96.h;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(34.r),
          ),
          child: renderPanel());
    });
  }

  Widget renderPanel() {
    if (GlobalLogic.to.hasSkin.value) {
      final music = PlayerLogic.to.playingMusic.value;
      return FutureBuilder<Decoration>(
        initialData: BoxDecoration(
          color: ColorMs.colorEBF3FE,
          borderRadius: BorderRadius.circular(34.r),
        ),
        builder: (BuildContext context, AsyncSnapshot<Decoration> snapshot) {
          return Container(
            height: 60.h,
            margin: EdgeInsets.only(top: 6.h, left: 16.w, right: 16.w),
            decoration: snapshot.requireData,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(34.r),
                child: BackdropFilter(
                  //背景滤镜
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  //背景模糊化
                  child: body(),
                )),
          );
        },
        future: generateDecoration(music),
      );
    }
    return Container(
      height: 60.h,
      margin: EdgeInsets.only(top: 6.h, left: 16.w, right: 16.w),
      child:
          ClipRRect(borderRadius: BorderRadius.circular(34.r), child: body()),
    );
  }

  Future<Decoration> generateDecoration(Music music) async {
    String coverPath = (music.baseUrl ?? "") + (music.coverPath ?? "");
    if (coverPath.isNotEmpty) {
      coverPath = SDUtils.getImgFile(coverPath).path;
      Uint8List? compressPic = await ImageUtil().compressAndTryCatch(coverPath);
      if (compressPic != null) {
        return BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(compressPic), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(34.r),
        );
      }
    }
    return BoxDecoration(
        color: const Color(Const.noMusicColorfulSkin),
        borderRadius: BorderRadius.circular(34.r));
  }

  Widget body() {
    return Container(
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.15),
        child: Row(
          children: [
            SizedBox(width: 6.w),

            /// 迷你封面
            miniCover(),
            SizedBox(width: 8.w),

            /// 滚动歌名
            marqueeMusicName(),
            SizedBox(width: 14.w),

            /// 播放按钮
            SizedBox(
              width: 24.h,
              height: 24.h,
              child: playButton(),
            ),
            SizedBox(width: 10.w),

            /// 播放列表按钮
            touchIconByAsset(
                path: Assets.playerPlayPlaylist,
                onTap: () {
                  SmartDialog.compatible.show(
                      widget: const DialogPlaylist(),
                      alignmentTemp: Alignment.bottomCenter);
                },
                width: 24,
                height: 24,
                color:
                    Get.isDarkMode ? ColorMs.colorCCCCCC : ColorMs.color333333)
          ],
        ));
  }

  Widget miniCover() {
    final currentMusic = PlayerLogic.to.playingMusic.value;
    final coverPath =
        (currentMusic.baseUrl ?? "") + (currentMusic.coverPath ?? "");
    return showImg(SDUtils.getImgPath(fileName: coverPath), 48, 48,
        radius: 48, hasShadow: false, onTap: widget.onTap);
  }

  Widget marqueeMusicName() {
    return Listener(
      onPointerDown: (event) {
        startPosition = event.position.dx;
      },
      onPointerUp: (event) {
        final playlistSize = PlayerLogic.to.mPlayList.length;
        if (playlistSize <= 1) {
          return;
        }
        final loopMode = PlayerLogic.to.mPlayer.loopMode;
        if (loopMode == LoopMode.one) {
          return;
        }
        final endPosition = event.position.dx;
        if ((endPosition - startPosition).abs() > 130.w) {
          // 距离大于50认为滑动切歌有效
          if (endPosition > startPosition) {
            PlayerLogic.to.playPrev();
          } else {
            PlayerLogic.to.playNext();
          }
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: renderPlayingWidget(PlayerLogic.to.playingMusic.value.musicName),
      ),
    );
  }

  Widget renderPlayingWidget(String? musicName) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold);
    return SizedBox(
      width: maxWidth,
      child: InkWell(
        onDoubleTap: () {
          if (PlayerLogic.to.playingMusic.value.musicId != null) {
            PlayerLogic.to.togglePlay();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MarqueeText(
                text: TextSpan(text: musicName ?? 'no_songs'.tr),
                style: Get.isDarkMode
                    ? TextStyleMs.white_14.merge(textStyle)
                    : TextStyleMs.black_14.merge(textStyle),
                speed: 15)
          ],
        ),
      ),
    );
  }

  Widget playButton() {
    return StreamBuilder<PlayerState>(
      stream: PlayerLogic.to.mPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        final color =
            Get.isDarkMode ? ColorMs.colorCCCCCC : ColorMs.color333333;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 24.h,
            height: 24.h,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return touchIconByAsset(
              path: Assets.playerPlayPlay,
              onTap: () {
                if (PlayerLogic.to.playingMusic.value.musicId != null) {
                  PlayerLogic.to.mPlayer.play();
                }
              },
              width: 24,
              height: 24,
              color: color);
        } else if (processingState != ProcessingState.completed) {
          return touchIconByAsset(
              path: Assets.playerPlayPause,
              onTap: () => PlayerLogic.to.mPlayer.pause(),
              width: 24,
              height: 24,
              color: color);
        } else {
          return touchIconByAsset(
              path: Assets.playerPlayPlay,
              onTap: () => PlayerLogic.to.mPlayer.seek(Duration.zero,
                  index: PlayerLogic.to.mPlayer.effectiveIndices!.first),
              width: 24,
              height: 24,
              color: color);
        }
      },
    );
  }
}
