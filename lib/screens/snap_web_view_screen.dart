import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapWebViewScreen extends StatefulWidget {
  static const routeName = '/snap-webview';
  String? url;

  SnapWebViewScreen({Key? key, this.url}) : super(key: key);

  @override
  State<SnapWebViewScreen> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<SnapWebViewScreen> {
  int loadingPercentage = 0;
  WebViewController _controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webView();
  }

  webView() {
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final host = Uri.parse(request.url).toString();
            print("track_url = " + host);
            if (host.contains('gojek://') ||
                host.contains('shopeeid://') ||
                host.contains('//wsa.wallet.airpay.co.id/') ||
                // This is handle for sandbox Simulator
                host.contains('/gopay/partner/') ||
                host.contains('/shopeepay/') ||
                host.contains('/pdf')) {
              _launchInExternalBrowser(Uri.parse(request.url));
              return NavigationDecision.prevent;
            }
            if (host.startsWith('blob:')) {
              _fetchBlobData(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            //   height: 30,
            //   width: 60,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF0A2852),
            //       ),
            //       child: const Text('Exit', style: TextStyle(fontSize: 10))),
            // ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInExternalBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  void _fetchBlobData(String blobUrl) async {
    final script = '''
      (async function() {
        const response = await fetch('$blobUrl');
        const blob = await response.blob();
        const reader = new FileReader();
        reader.onloadend = function() {
          const base64data = reader.result.split(',')[1];
          BlobDataChannel.postMessage(base64data);
        };
        reader.readAsDataURL(blob);
      })();
    ''';
    _controller.runJavaScript(script);
  }
}
