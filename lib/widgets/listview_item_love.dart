import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/generated/assets.dart';
import 'package:lovelivemusicplayer/models/Music.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/pages/home/home_controller.dart';
import 'package:lovelivemusicplayer/utils/color_manager.dart';
import 'package:lovelivemusicplayer/utils/sd_utils.dart';
import 'package:lovelivemusicplayer/utils/text_style_manager.dart';
import 'package:lovelivemusicplayer/widgets/circular_check_box.dart';

///歌曲
class ListViewItemLove extends StatefulWidget {
  Function(Music music) onPlayNextTap;
  Function(int index) onPlayNowTap;
  Function(Music music) onMoreTap;

  ///条目数据
  Music music;

  ///当前选中状态
  bool checked;

  int index;

  ListViewItemLove(
      {Key? key,
      required this.index,
      required this.onPlayNextTap,
      required this.onPlayNowTap,
      required this.onMoreTap,
      required this.music,
      this.checked = false})
      : super(key: key);

  @override
  State<ListViewItemLove> createState() => _ListViewItemLoveState();
}

class _ListViewItemLoveState extends State<ListViewItemLove> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: Get.theme.primaryColor,
        child: Row(
          children: [
            ///勾选按钮
            _buildCheckBox(),

            ///缩列图
            _buildIcon(),

            SizedBox(width: 10.r),

            ///中间标题部分
            _buildContent(),

            ///右侧操作按钮
            _buildAction(),
          ],
        ),
      );
    });
  }

  clickItem() {
    widget.checked = !widget.checked;
    if (HomeController.to.state.isSelect.value) {
      HomeController.to.selectItem(widget.index, widget.checked);
    } else {
      widget.onPlayNowTap(widget.index);
    }
    setState(() {});
  }

  ///缩列图
  Widget _buildIcon() {
    return InkWell(
      onTap: clickItem,
      child: showImg(
          SDUtils.getImgPath(
              fileName: "${widget.music.baseUrl}${widget.music.coverPath}"),
          48,
          48,
          hasShadow: false,
          radius: 8,
          onTap: clickItem),
    );
  }

  ///勾选按钮
  Widget _buildCheckBox() {
    return Visibility(
      visible: HomeController.to.state.isSelect.value,
      child: Padding(
        padding: EdgeInsets.only(right: 10.h),
        child: CircularCheckBox(
          checkd: widget.checked,
          onCheckd: (value) {
            widget.checked = value;
            HomeController.to.selectItem(widget.index, value);
          },
          checkIconColor: ColorMs.colorF940A7,
          uncheckedIconColor: ColorMs.color999999,
        ),
      ),
    );
  }

  ///中间标题部分
  Widget _buildContent() {
    return Expanded(
      child: InkWell(
        onTap: clickItem,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.music.musicName ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.isDarkMode
                    ? TextStyleMs.white_15
                    : TextStyleMs.black_15),
            SizedBox(
              height: 4.w,
            ),
            Text(
              widget.music.artist ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyleMs.grayBold_12,
            ),
            SizedBox(
              width: 16.w,
            )
          ],
        ),
      ),
    );
  }

  ///右侧操作按钮
  Widget _buildAction() {
    return Visibility(
      visible: !HomeController.to.state.isSelect.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
              child: touchIconByAsset(
                  path: Assets.mainIcAddNext,
                  onTap: () {
                    widget.onPlayNextTap(widget.music);
                  },
                  width: 20,
                  height: 20,
                  color: ColorMs.colorCCCCCC)),
          InkWell(
            onTap: () {
              widget.onMoreTap(widget.music);
            },
            child: Container(
              padding: EdgeInsets.only(
                  left: 12.w, right: 10.w, top: 12.h, bottom: 12.h),
              child: touchIconByAsset(
                  path: Assets.mainIcMore,
                  width: 10,
                  height: 20,
                  color: ColorMs.colorCCCCCC),
            ),
          ),
          SizedBox(width: 4.r)
        ],
      ),
    );
  }
}
