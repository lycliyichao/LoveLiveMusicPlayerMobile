import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/generated/assets.dart';
import 'package:lovelivemusicplayer/global/global_db.dart';
import 'package:lovelivemusicplayer/models/Menu.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/utils/color_manager.dart';
import 'package:lovelivemusicplayer/utils/text_style_manager.dart';
import 'package:lovelivemusicplayer/widgets/new_menu_dialog.dart';

class DialogMoreWithMenu extends StatelessWidget {
  final Menu menu;

  const DialogMoreWithMenu({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
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
            child: Text(menu.name,
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
          _buildItem(Assets.dialogIcEdit, 'rename_menu'.tr, true, () {
            SmartDialog.compatible.dismiss();
            SmartDialog.compatible.show(
                widget: NewMenuDialog(
                    title: 'rename_menu'.tr,
                    onConfirm: (name) {
                      DBLogic.to.updateMenuName(name, menu.id);
                    }),
                clickBgDismissTemp: false,
                alignmentTemp: Alignment.center);
          }),
          _buildItem(Assets.dialogIcDelete2, 'delete_menu'.tr, true, () {
            SmartDialog.compatible.dismiss();
            DBLogic.to.deleteMenuById(menu.id);
          }),
        ],
      ),
    );
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
