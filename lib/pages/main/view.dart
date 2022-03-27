import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lovelivemusicplayer/modules/ext.dart';
import 'package:we_slide/we_slide.dart';
import '../../models/music_Item.dart';
import '../../modules/drawer/drawer.dart';
import '../../widgets/refresher_widget.dart';
import '../player/miniplayer.dart';
import '../player/player.dart';
import '../player/widget/bottom_bar1.dart';
import '../player/widget/bottom_bar2.dart';
import 'widget/listview_item_song.dart';
import 'widget/song_library_top.dart';
import 'logic.dart';
import 'widget/custom_underline_tabIndicator.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.put(MainLogic());
  final state = Get.find<MainLogic>().state;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final WeSlideController _controller = WeSlideController();
    const double _panelMinSize = 150;
    final double _panelMaxSize = ScreenUtil().screenHeight;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: const DrawerPage(),
      body: WeSlide(
        controller: _controller,
        panelMinSize: _panelMinSize.h,
        panelMaxSize: _panelMaxSize,
        overlayOpacity: 0.9,
        backgroundColor: const Color(0xFFF2F8FF),
        overlay: true,
        isDismissible: true,
        body: _getTabBarView(() => _scaffoldKey.currentState?.openEndDrawer()),
        blurColor: const Color(0xFFF2F8FF),
        overlayColor: const Color(0xFFF2F8FF),
        panelBorderRadiusBegin: 10,
        panelBorderRadiusEnd: 10,
        panelHeader: MiniPlayer(onTap: _controller.show),
        panel: Player(onTap: _controller.hide),
        footer: _buildTabBarView(),
        footerHeight: 84.h,
        blur: true,
        parallax: true,
        transformScale: true,
        blurSigma: 5.0,
        fadeSequence: [
          TweenSequenceItem<double>(weight: 1.0, tween: Tween(begin: 1, end: 0)),
          TweenSequenceItem<double>(weight: 8.0, tween: Tween(begin: 0, end: 0)),
        ],
      ),
    );
  }

  Widget _getTabBar() {
    return TabBar(
      indicatorWeight: 4.w,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: const Color(0xFFF940A7),
      labelPadding: EdgeInsets.only(left: 4.w, right: 4.w),
      indicator: CustomUnderlineTabIndicator(
          insets: EdgeInsets.only(top: 0.w, bottom: 8.h),
          borderSide: BorderSide(width: 16.w, color: const Color(0xFFF940A7)),
          indicatorWeight: 4.w),
      isScrollable: true,
      labelColor: const Color(0xFFF940A7),
      unselectedLabelColor: const Color(0xFFA9B9CD),
      labelStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle:
          TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      tabs: const [
        Tab(
          text: "歌库",
        ),
        Tab(
          text: "我的",
        ),
      ],
      controller: tabController,
    );
  }

  ///顶部头像
  Widget _getTopHead(GestureTapCallback onTap) {
    return logoIcon("ic_head.jpg", offset: EdgeInsets.only(right: 16.w), onTap: onTap);
  }

  Widget _getTabBarView(GestureTapCallback onTap) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 54.w,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF2F8FF),
        title: _getTabBar(),
        actions: [_getTopHead(onTap)],
      ),
      body: Column(
        children: [
          ///顶部歌曲总数栏
          _buildListTop(),

          ///列表数据
          _buildList(),
        ],
      ),
    );
  }

  ///顶部歌曲总数栏
  Widget _buildListTop() {
    return Song_libraryTop(
      onPlayTap: () {},
      onScreenTap: () {
        logic.openSelect();
      },
      onSelectAllTap: (checked) {
        logic.selectAll(checked);
      },
      onCancelTap: () {
        logic.openSelect();
      },
    );
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  Widget _buildList() {
    return Expanded(
      child: GetBuilder<MainLogic>(builder: (logic) {
        return Container(
          color: const Color(0xFFF2F8FF),
          child: RefresherWidget(
            itemCount: logic.state.items.length,
            enablePullDown: logic.state.items.isNotEmpty,
            listItem: (cxt, index) {
              return ListViewItemSong(
                index: index,
                onItemTap: (valut) {},
                onPlayTap: () {},
                onMoreTap: () {},
              );
            },
            onRefresh: (controller) async {
              await Future.delayed(const Duration(milliseconds: 1000));
              logic.state.items.clear();

              logic.addItem([
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false)
              ]);
              controller.refreshCompleted();
              controller.loadComplete();
            },
            onLoading: (controller) async {
              await Future.delayed(const Duration(milliseconds: 1000));
              logic.addItem([
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false),
                MusicItem(titlle: "", checked: false)
              ]);
              controller.loadComplete();
            },
          ),
        );
      }),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        BottomBar(logic.currentIndex.value, onSelect: (index) {
          logic.currentIndex.value = index;
        }),
        BottomBar2(logic.currentIndex.value, onSelect: (index) {
          logic.currentIndex.value = index + 3;
        }),
      ],
      controller: tabController,
    );
  }
}
