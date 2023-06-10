import 'dart:collection';
import 'dart:io';

import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/screens/dashboard/about_us.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewRemotePage extends StatefulWidget {
  static const routeName = '/WebViewRemotePage';
  final ALL_Name_ID arguments;

  const WebViewRemotePage(this.arguments);

  @override
  State<WebViewRemotePage> createState() => _WebViewRemotePageState();
}

class _WebViewRemotePageState extends State<WebViewRemotePage> {
  String url = "";
  double progress = 0;
  int prgresss = 0;
  final urlController = TextEditingController();

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;

  @override
  void initState() {
    super.initState();
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*WebViewWidget(controller: controller),*/
          Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderPart(),
            SizedBox(
              height: 30,
            ),
            widget.arguments.Name=="Terms & Condition"?Container(
              margin: EdgeInsets.all(20),
              child: Text(
                  "This Application  is designed to provide accurate and authoritative information regarding the workers’ compensation law and benefits.  This information is given with the understanding that this Application does not create an attorney client relationship.  Since the details of your situation are fact dependent; you should contact us to advise you how the law affects your particular circumstances."),
            ):
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                  "Kaplan Morrell respects the privacy of our users.  This application does not request, collect, or store any information about or from our users except when the user voluntarily provides feedback.  In that limited case the user’s name and email address would be retained.    Any inputs in the benefit calculators is likewise not stored.   This Privacy Policy does not apply to the third-party online/mobile store from which you install the Application."),
            ),
            Visibility(
              visible: false,
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://www.w3schools.com/about/about_privacy.asp")),
                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    initialOptions: options,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunch(url)) {
                          // Launch the App
                          await launch(
                            url,
                          );

                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController.endRefreshing();

                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                      //Navigator.pop(context123);

                      String pageTitle = "";

                      controller.getTitle().then((value) {
                        setState(() {
                          pageTitle = value;

                          print("sdf567" + pageTitle);
                        });
                      });

                      /*showCommonDialogWithSingleOption(
                                      context, "Email Sent Successfully ",
                                      onTapOfPositiveButton: () {
                                    //Navigator.pop(context);
                                    navigateTo(context, HomeScreen.routeName,
                                        clearAllStack: true);
                                  });*/
                    },
                    onLoadError: (controller, url, code, message) {
                      pullToRefreshController.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController.endRefreshing();
                        this.prgresss = progress;
                        // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                      }

                      //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                      setState(() {
                        this.progress = progress / 100;
                        this.prgresss = progress;

                        urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print("LoadWeb" + consoleMessage.message.toString());
                    },
                    onPageCommitVisible: (controller, url) {},
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  HeaderPart() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          /* border: Border.all(
            color: Colors.red[500],
          ),*/

          color: Color(0xff181142),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        navigateTo(context, AboutUsScreen.routeName);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            widget.arguments.Name,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
