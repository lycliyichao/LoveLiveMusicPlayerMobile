import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/generated/assets.dart';
import 'package:lovelivemusicplayer/global/global_db.dart';
import 'package:lovelivemusicplayer/global/global_player.dart';
import 'package:lovelivemusicplayer/models/Album.dart';
import 'package:lovelivemusicplayer/models/Music.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/pages/home/widget/dialog_add_song_sheet.dart';
import 'package:lovelivemusicplayer/pages/home/widget/dialog_song_info.dart';
import 'package:lovelivemusicplayer/routes.dart';
import 'package:lovelivemusicplayer/utils/color_manager.dart';
import 'package:lovelivemusicplayer/utils/text_style_manager.dart';

class DialogMoreWithMusic extends StatefulWidget {
  final Music music;
  Function(Music)? onRemove;
  Function()? onClosePanel;
  bool? isAlbum;

  DialogMoreWithMusic(
      {Key? key,
      required this.music,
      this.onRemove,
      this.isAlbum,
      this.onClosePanel})
      : super(key: key);

  @override
  State<DialogMoreWithMusic> createState() => _DialogMoreWithMusicState();
}

class _DialogMoreWithMusicState extends State<DialogMoreWithMusic> {
  Album? album;

  @override
  void initState() {
    super.initState();
    DBLogic.to.findAlbumById(widget.music.albumId!).then((mAlbum) {
      album = mAlbum;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var length = 4;
    if (widget.onRemove != null) {
      length++;
    }

    if (widget.isAlbum == null || widget.isAlbum == false) {
      length++;
    }
    return Container(
      height: length * 55.h,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          boxShadow: [
            BoxShadow(
                color: Get.theme.primaryColor, blurRadius: 4, spreadRadius: 4)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.h), topRight: Radius.circular(16.h))),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h),
            child: Text(widget.music.musicName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.isDarkMode
                    ? TextStyleMs.white_17
                    : TextStyleMs.black_17),
          ),
          Divider(
            height: 0.5.h,
            color: Get.isDarkMode ? ColorMs.color737373 : ColorMs.colorCFCFCF,
          ),
          _buildItem(Assets.dialogIcAddPlayList, 'add_to_playlist'.tr, true,
              () {
            SmartDialog.compatible.dismiss();
            PlayerLogic.to.addNextMusic(widget.music, isNext: false);
            SmartDialog.compatible.showToast('add_success'.tr);
          }),
          _buildItem(Assets.dialogIcAddSongSheet, 'add_to_menu'.tr, true, () {
            SmartDialog.compatible.dismiss();
            SmartDialog.compatible.show(
                widget: DialogAddSongSheet(musicList: [widget.music]),
                alignmentTemp: Alignment.bottomCenter);
          }),
          _buildItem(Assets.dialogIcSongInfo, 'music_info'.tr, length > 4, () {
            SmartDialog.compatible.dismiss();
            SmartDialog.compatible.show(
                widget: DialogSongInfo(music: widget.music),
                alignmentTemp: Alignment.bottomCenter);
          }),
          renderWatchAlbum(),
          renderRemoveItem()
        ],
      ),
    );
  }

  Widget renderWatchAlbum() {
    if (widget.isAlbum != null && widget.isAlbum == true) {
      return Container();
    }
    return _buildItem(
        Assets.dialogIcSeeAlbum, 'view_album'.tr, widget.onRemove != null, () {
      SmartDialog.compatible.dismiss();
      if (widget.onClosePanel != null) {
        widget.onClosePanel!();
      }
      if (album != null) {
        Get.toNamed(Routes.routeAlbumDetails, arguments: album, id: 1);
      }
    });
  }

  Widget renderRemoveItem() {
    if (widget.onRemove != null) {
      return _buildItem(Assets.dialogIcDelete2, 'remove_music'.tr, false, () {
        SmartDialog.compatible.dismiss();
        widget.onRemove!(widget.music);
      });
    }
    return Container();
  }

  ///单个条目
  Widget _buildItem(
      String path, String title, bool showLin, GestureTapCallback? onTap) {
    return Padding(
      padding: EdgeInsets.only(left: 16.h, right: 16.h),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14.h,
            ),
            Row(
              children: [
                touchIconByAsset(
                    path: path,
                    onTap: () {},
                    width: 16.h,
                    height: 16.h,
                    color: Get.isDarkMode ? Colors.white : ColorMs.color666666),
                SizedBox(
                  width: 10.h,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: Get.isDarkMode
                        ? TextStyleMs.white_15
                        : TextStyleMs.lightBlack_15,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 14.h,
            ),
            Visibility(
              visible: showLin,
              child: Divider(
                height: 0.5.h,
                color:
                    Get.isDarkMode ? ColorMs.color737373 : ColorMs.colorCFCFCF,
              ),
            )
          ],
        ),
      ),
    );
  }
}
