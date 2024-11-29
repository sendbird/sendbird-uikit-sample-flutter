// Copyright (c) 2023 Sendbird, Inc. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sendbird_uikit/sendbird_uikit.dart';
import 'package:sendbird_uikit_sample/utils/widgets.dart';
import 'package:video_player/video_player.dart';

class GroupChannelVideoViewerPage extends StatefulWidget {
  const GroupChannelVideoViewerPage({Key? key}) : super(key: key);

  @override
  State<GroupChannelVideoViewerPage> createState() =>
      GroupChannelVideoViewerPageState();
}

class GroupChannelVideoViewerPageState
    extends State<GroupChannelVideoViewerPage> {
  final url = Get.arguments['url'];
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller.setLooping(false);
    _controller.initialize().then((_) {
      if (mounted) setState(() {});
    });
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Widgets.scaffold(
        noAppBar: true,
        body: Container(
          color: Colors.black,
          child: Stack(children: [
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(color: Colors.black),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Icon(
                          SBUIcons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
