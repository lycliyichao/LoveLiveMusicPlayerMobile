import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lovelivemusicplayer/generated/assets.dart';
import 'package:lovelivemusicplayer/global/global_player.dart';
import 'package:lovelivemusicplayer/models/Music.dart';
import 'package:lovelivemusicplayer/pages/details/logic.dart';
import 'package:lovelivemusicplayer/pages/home/widget/dialog_bottom_btn.dart';
import 'package:lovelivemusicplayer/pages/home/widget/dialog_more_with_music.dart';
import 'package:lovelivemusicplayer/widgets/details_list_top.dart';
import 'package:lovelivemusicplayer/widgets/listview_item_song.dart';

class DetailsBody extends StatelessWidget {
  final DetailController logic;
  final Widget buildCover;
  final List<Music> music;

  const DetailsBody(
      {Key? key,
      required this.logic,
      required this.buildCover,
      required this.music})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.all(0),
      children: getListItems(logic),
    ));
  }

  List<Widget> getListItems(logic) {
    List<Widget> list = [];
    list.add(buildCover);
    list.add(SizedBox(
      height: 10.h,
    ));
    list.add(DetailsListTop(
        selectAll: logic.state.selectAll,
        isSelect: logic.state.isSelect,
        itemsLength: music.length,
        checkedItemLength: logic.getCheckedSong(),
        onPlayTap: () {
          PlayerLogic.to.playMusic(music);
        },
        onScreenTap: () {
          if (logic.state.isSelect) {
            logic.closeSelect();
            SmartDialog.dismiss();
          } else {
            logic.openSelect();
            showSelectDialog(logic);
          }
        },
        onSelectAllTap: (checked) {
          logic.selectAll(checked);
        },
        onCancelTap: () {
          logic.closeSelect();
          SmartDialog.dismiss();
        }));
    list.add(SizedBox(
      height: 10.h,
    ));
    for (var index = 0; index < music.length; index++) {
      list.add(Padding(
        padding: EdgeInsets.only(left: 16.w, bottom: 20.h, right: 16.w),
        child: ListViewItemSong(
          index: index,
          music: music[index],
          checked: logic.isItemChecked(index),
          onItemTap: (index, checked) {
            logic.selectItem(index, checked);
          },
          onPlayNextTap: (music) => PlayerLogic.to.addNextMusic(music),
          onMoreTap: (music) {
            SmartDialog.compatible.show(
                widget: DialogMoreWithMusic(music: music),
                alignmentTemp: Alignment.bottomCenter);
          },
          onPlayNowTap: () {
            PlayerLogic.to.playMusic(music, index: index);
          },
        ),
      ));
    }
    return list;
  }

  showSelectDialog(logic) {
    List<BtnItem> list = [];
    list.add(BtnItem(
        imgPath: Assets.dialogIcAddPlayList2,
        title: "加入播放列表",
        onTap: () async {
          final musicList = logic.state.items;
          await Future.forEach<Music>(musicList, (music) {
            if (music.checked) {
              print(music.musicName);
              // todo: 添加到播放列表
            }
          });
          logic.closeSelect();
        }));
    list.add(BtnItem(
        imgPath: Assets.dialogIcAddPlayList,
        title: "添加到歌单",
        onTap: () async {
          final musicList = logic.state.items;
          await Future.forEach<Music>(musicList, (music) {
            if (music.checked) {
              print(music.musicName);
              // todo: 添加到播放列表
            }
          });
          logic.closeSelect();
        }));
    SmartDialog.compatible.show(
        widget: DialogBottomBtn(
          list: list,
        ),
        isPenetrateTemp: true,
        clickBgDismissTemp: false,
        maskColorTemp: Colors.transparent,
        alignmentTemp: Alignment.bottomCenter);
  }
}