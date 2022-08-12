import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/global/global_db.dart';
import 'package:lovelivemusicplayer/models/Artist.dart';
import 'package:lovelivemusicplayer/models/Music.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:lovelivemusicplayer/pages/details/logic.dart';
import 'package:lovelivemusicplayer/pages/details/widget/details_body.dart';
import 'package:lovelivemusicplayer/pages/details/widget/details_header.dart';

class SingerDetailsPage extends StatefulWidget {
  const SingerDetailsPage({Key? key}) : super(key: key);

  @override
  State<SingerDetailsPage> createState() => _SingerDetailsPageState();
}

class _SingerDetailsPageState extends State<SingerDetailsPage> {
  final Artist artist = Get.arguments;
  final music = <Music>[];
  final logic = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      music.addAll(await DBLogic.to.findAllMusicByArtistBin(artist.artistBin));
      logic.state.items = music;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GetBuilder<DetailController>(builder: (logic) {
      return Column(
        children: [
          DetailsHeader(title: artist.name),
          DetailsBody(
              logic: logic,
              buildCover: _buildCover(),
              music: music
          )
        ],
      );
    });
  }

  Widget _buildCover() {
    return Container(
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showImg(artist.photo, 240, 240, radius: 120),
        ],
      ),
    );
  }
}