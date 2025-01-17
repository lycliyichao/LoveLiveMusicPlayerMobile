import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lovelivemusicplayer/routes.dart';
import 'package:lovelivemusicplayer/utils/splash_photo_util.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isStartHomePage = false;
  Widget? myWidget;

  @override
  void initState() {
    super.initState();
    SplashPhoto().getRandomPhotoView().then((widget) {
      if (widget != null) {
        myWidget = widget;
        setState(() {});
      }
    }).then(
        (value) => Future.delayed(const Duration(seconds: 3), goToHomePage));
  }

  @override
  Widget build(BuildContext context) {
    return myWidget ?? Container();
  }

  void goToHomePage() {
    if (!isStartHomePage) {
      isStartHomePage = true;
      Get.offNamed(Routes.routeInitial);
    }
  }
}
