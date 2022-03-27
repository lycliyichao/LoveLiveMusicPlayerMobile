import 'package:lovelivemusicplayer/models/Music.dart';

import '../../models/music_Item.dart';
import '../../utils/sd_utils.dart';

class MainState {
  MainState() {
    ///Initialize variables
  }
  ///选中词库Tab
  bool isSelectSongLibrary = true;

  ///选择条目模式
  bool isSelect = false;

  ///全选
  bool selectAll = false;

  ///选中歌曲数
  int selectSongNum = 0;

  ///列表数据
  List<MusicItem> items = [MusicItem(titlle: "",checked: false),
    MusicItem(titlle: "",checked: false),
    MusicItem(titlle: "",checked: false),
    MusicItem(titlle: "",checked: false),
    MusicItem(titlle: "",checked: false),
    MusicItem(titlle: "",checked: false)];

  Music playingMusic = Music();
  bool isCanMiniPlayerScroll = true;

  List<Music> playList = [
    Music(uid: "1", name: "START!! True dreams", cover: SdUtils.path + "LoveLive/Cover_1.jpg", singer: "Liella!", totalTime: "03:42", isPlaying: true),
    Music(uid: "2", name: "HOT PASSION!!", cover: SdUtils.path + "LoveLive/Cover_2.jpg", singer: "Sunny Passion", totalTime: "04:18"),
    Music(uid: "3", name: "常夏☆サンシャイン", cover: SdUtils.path + "LoveLive/Cover_3.jpg", singer: "Liella!", totalTime: "04:42")
  ];
}
