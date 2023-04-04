import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class WebViewRemotePage extends StatefulWidget {
  static const routeName = '/WebViewRemotePage';
  final ALL_Name_ID arguments;

  const WebViewRemotePage(this.arguments);

  @override
  State<WebViewRemotePage> createState() => _WebViewRemotePageState();
}

class _WebViewRemotePageState extends State<WebViewRemotePage> {
  /* WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ),
    )
    ..loadRequest(Uri.parse("https://www.soundczech.cz/temp/lorem-ipsum.pdf"));
*/
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
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
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
                        navigateTo(context, HomeScreen.routeName);
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
