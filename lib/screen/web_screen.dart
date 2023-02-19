import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: webPage(),
  ));
}

// ignore: camel_case_types
class webPage extends StatefulWidget {
  const webPage({Key? key}) : super(key: key);

  @override
  State<webPage> createState() => _webPageState();
}

// ignore: camel_case_types
class _webPageState extends State<webPage> {
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(color: Colors.lightBlue),
        onRefresh: () async {
          await inAppWebViewController?.reload();
        });
  }

  @override
  Widget build(BuildContext context) {
    var webPage = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      bottomNavigationBar: Container(
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(color: Colors.white70),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.goBack();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: Uri.parse('${webPage['link']}'),
                  ),
                );
              },
              icon: const Icon(
                Icons.home,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.goForward();
              },
              icon: const Icon(
                Icons.arrow_forward,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.reload();
              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse('${webPage['link']}'),
          ),
          onWebViewCreated: (controller) {
            setState(() {
              inAppWebViewController = controller;
            });
          },
          pullToRefreshController: pullToRefreshController,
          onLoadStop: (controller, url) async {
            await pullToRefreshController.endRefreshing();
          }),
    );
  }
}
