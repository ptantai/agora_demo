import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(MainController());
  runApp(const MyApp());
}

const appId = '';
const userId = '';
const agoraToken = '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends GetWidget<MainController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora DEMO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text('Init RTM'),
              onPressed: () {
                controller.initRtm();
              },
            ),
            SizedBox(height: 8),
            TextButton(
              child: Text('Release RTC'),
              onPressed: () {
                controller.releaseRTC();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MainController extends GetxController {
  late RtcEngine engine;
  @override
  void onInit() {
    super.onInit();
    initRtm();
    initRtc();
  }

  void releaseRTC() {
    engine.release();
  }

  Future<void> initRtc() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
  }

  Future<void> initRtm() async {
    final (result, client) = await RTM(appId, userId);
    if (result.error) {
      print('\x1B[32mℹ️ Logger: create ERROR \x1B[0m');
    }
    final (status, loginResult) = await client.login(agoraToken);
    if (status.error) {
      print('\x1B[32mℹ️ Logger: login ERROR \x1B[0m');
    }

    registerListener(client);
  }

  void registerListener(RtmClient client) {
    client.addListener(
      linkState: (event) {
        print('RTM event previousState =>> ${event.previousState?.name}');
        print('RTM event currentState =>> ${event.currentState?.name}');
        print('RTM event operation =>> ${event.operation?.name}');
        print('RTM event serviceType =>> ${event.serviceType?.name}');
        print('RTM event reason =>> ${event.reason}');
      },
      message: (event) {
        print('\x1B[32mℹ️ Logger: ${event.message} \x1B[0m');
        print('\x1B[32mℹ️ Logger: ${event.customType} \x1B[0m');
      },
    );
  }
}
