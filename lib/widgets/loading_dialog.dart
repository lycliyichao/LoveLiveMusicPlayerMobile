import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/utils/text_style_manager.dart';

class LoadingDialog extends Dialog {
  String mag = 'loading'.tr;

  LoadingDialog(this.mag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mag.isEmpty) {
      mag = 'loading'.tr;
    }
    //创建透明层
    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: Container(
        width: 108.r,
        height: 108.r,
        decoration: BoxDecoration(
            color: Colors.black38, borderRadius: BorderRadius.circular(10.w)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitRing(color: Colors.white, size: 38.w, lineWidth: 3.w),
            SizedBox(
              height: 8.w,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  mag,
                  style: TextStyleMs.white_17,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ))
          ],
        ),
      )),
    );
  }
}
