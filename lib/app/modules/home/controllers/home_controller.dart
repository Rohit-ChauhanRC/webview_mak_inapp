import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeController extends GetxController {
  //
  final GlobalKey webViewKey = GlobalKey();

  static final box = GetStorage();

  // var no = box.read(Constants.cred);

  final RxString _mobileNumber = ''.obs;
  String get mobileNumber => _mobileNumber.value;
  set mobileNumber(String mobileNumber) => _mobileNumber.value = mobileNumber;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxInt _progress = 0.obs;
  int get progress => _progress.value;
  set progress(int i) => _progress.value = i;

  // WebViewController webViewController = WebViewController();

  InAppWebViewController? webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone;storage",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;

  Future<void> permisions() async {
    await Permission.storage.request();
    await Permission.camera.request();
    await Permission.mediaLibrary.request();
    await Permission.microphone.request();
    await Permission.photos.request();
  }

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    mobileNumber = box.read(Constants.cred) ?? Get.arguments;
    await permisions();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );

    // webViewController
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onProgress: (int p) {
    //         // Update loading bar.
    //         progress = p;
    //       },
    //       onPageStarted: (String url) {
    //         progress = 1;
    //       },
    //       onPageFinished: (String url) {
    //         circularProgress = false;
    //       },
    //       onWebResourceError: (WebResourceError error) {},
    //       onNavigationRequest: (NavigationRequest request) {
    //         // if (request.url.startsWith('http://app.maklifedairy.in:5011/')) {
    //         //   return NavigationDecision.prevent;
    //         // }
    //         return NavigationDecision.navigate;
    //       },
    //     ),
    //   )
    //   ..loadRequest(
    //     Uri.https('app.maklifedairy.in:5017',
    //         '/index.php/Login/Check_Login/${mobileNumber.toString()}'),
    //     // method: LoadRequestMethod.post,
    //   )
    //   ..reload();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
