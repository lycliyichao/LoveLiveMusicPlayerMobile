import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/global/global_global.dart';
import 'package:lovelivemusicplayer/models/Album.dart';
import 'package:lovelivemusicplayer/models/Artist.dart';
import 'package:lovelivemusicplayer/pages/details/album_details/view.dart';
import 'package:lovelivemusicplayer/pages/details/menu_details/view.dart';
import 'package:lovelivemusicplayer/pages/details/singer_details/view.dart';
import 'package:lovelivemusicplayer/pages/home/page_view/home_page_view.dart';
import 'package:lovelivemusicplayer/routes.dart';

class NestedController extends GetxController {
  static NestedController get to => Get.find();

  late Album album;
  late Artist artist;
  late int menuId;
  String currentIndex = Routes.routeHome;
  final routeList = <String>[];
  bool fromGestureBack = true;

  final pages = <String>[
    Routes.routeHome,
    Routes.routeAlbumDetails,
    Routes.routeSingerDetails,
    Routes.routeMenuDetails
  ];

  addNav(String route) {
    routeList.add(route);
    currentIndex = route;
    if (route != Routes.routeHome) {
      GlobalLogic.to.needHomeSafeArea.value = true;
      GlobalLogic.mobileWeSlideFooterController.hide();
    }
  }

  reduceNav() {
    if (currentIndex == Routes.routeHome) {
      GlobalLogic.mobileWeSlideFooterController.show();
    }
    GlobalLogic.to.needHomeSafeArea.value = routeList.last != Routes.routeHome;
  }

  goBack({bool fromBtnBack = false}) {
    routeList.removeLast();
    currentIndex = routeList.last;
    reduceNav();
    if (fromBtnBack) {
      Get.back(id: 1);
    }
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.routeHome) {
      addNav(Routes.routeHome);
      return GetPageRoute(settings: settings, page: () => const HomePageView());
    } else if (settings.name == Routes.routeAlbumDetails) {
      addNav(Routes.routeAlbumDetails);
      album = settings.arguments as Album;
      return GetPageRoute(
        settings: settings,
        page: () => const AlbumDetailsPage(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (settings.name == Routes.routeSingerDetails) {
      addNav(Routes.routeSingerDetails);
      artist = settings.arguments as Artist;
      return GetPageRoute(
        settings: settings,
        page: () => const SingerDetailsPage(),
        transition: Transition.rightToLeftWithFade,
      );
    } else if (settings.name == Routes.routeMenuDetails) {
      addNav(Routes.routeMenuDetails);
      menuId = settings.arguments as int;
      return GetPageRoute(
        settings: settings,
        page: () => const MenuDetailsPage(),
        transition: Transition.rightToLeftWithFade,
      );
    }

    return null;
  }
}
