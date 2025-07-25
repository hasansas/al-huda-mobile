import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PurchasedDigitalProductCard extends StatefulWidget
    with WidgetsBindingObserver {
  int? id;
  String? image;
  String? name;

  PurchasedDigitalProductCard({Key? key, this.id, this.image, this.name})
      : super(key: key);

  @override
  _PurchasedDigitalProductCardState createState() =>
      _PurchasedDigitalProductCardState();
}

class _PurchasedDigitalProductCardState
    extends State<PurchasedDigitalProductCard> {
  List<Map> downloadsListMaps = [];
  ReceivePort _port = ReceivePort();
  bool isDownloaded = false;

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void initState() {
    var k = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen(
      (dynamic data) {
        print(data.toString() + "llkk");
        if (data[2] >= 100) {
          ToastComponent.showDialog("File has downloaded successfully.",
              gravity: ToastGravity.CENTER, duration: Toast.LENGTH_LONG);
        }
        setState(() {});
      },
    );

    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48) / 2);
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1().copyWith(),
      child: Column(children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Container(
              width: double.infinity,
              child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6), bottom: Radius.zero),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: widget.image!,
                    fit: BoxFit.cover,
                  ))),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            widget.name!,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w400),
          ),
        ),
        InkWell(
          onTap: () {
            requestDownload();
          },
          child: Container(
            height: 24,
            width: 134,
            margin: EdgeInsets.only(bottom: 14, top: 14),
            decoration: BoxDecoration(
              color: MyTheme.accent_color,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Center(
              child: Text(
                'Download',
                style: TextStyle(
                  fontFamily: 'Public Sans',
                  fontSize: 10,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w500,
                  height: 1.8,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                softWrap: false,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> requestDownload() async {
    var folder = await createFolder();
    print("folder $folder");
    try {
      String? _taskid = await FlutterDownloader.enqueue(
          url: AppConfig.BASE_URL + "/purchased-products/download/${widget.id}",
          saveInPublicStorage: false,
          savedDir: folder,
          showNotification: true,
          headers: {
            "Authorization": "Bearer ${access_token.$}",
            "System-Key": AppConfig.system_key
          });
    } on Exception catch (e) {
      print("e.toString()");
      print(e.toString());
      // TODO
    }
  }

  Future<String> createFolder() async {
    var mPath = "storage/emulated/0/Download/";
    if (Platform.isIOS) {
      var iosPath = await getApplicationDocumentsDirectory();
      mPath = iosPath.path;
    }
    // print("path = $mPath");
    final dir = Directory(mPath);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      await dir.create();
      return dir.path;
    }
  }
}
