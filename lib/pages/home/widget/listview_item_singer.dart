import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/models/Artist.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/utils/color_manager.dart';

///歌手 item
class ListViewItemSinger extends StatefulWidget {
  Artist artist;

  Function(Artist) onItemTap;

  ListViewItemSinger({Key? key, required this.artist, required this.onItemTap})
      : super(key: key);

  @override
  State<ListViewItemSinger> createState() => _ListViewItemSingerState();
}

class _ListViewItemSingerState extends State<ListViewItemSinger> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        showImg(widget.artist.photo, 48, 48,
            radius: 24,
            hasShadow: false,
            onTap: () => widget.onItemTap(widget.artist)),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onItemTap(widget.artist);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15.sp,
                      color:
                          Get.isDarkMode ? Colors.white : ColorMs.color333333,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "${widget.artist.music.length}首歌",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorMs.color999999,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.h,
        ),
      ],
    );
  }
}
