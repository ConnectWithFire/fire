import 'package:dio/dio.dart';
import 'package:fire/pages/lobby.dart';
import 'package:fire/utils.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class LoginCodePage extends StatefulWidget {
  const LoginCodePage({Key? key}) : super(key: key);

  @override
  State<LoginCodePage> createState() => _LoginCodePageState();
}

class _LoginCodePageState extends State<LoginCodePage> {
  final _loginCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(232, 232, 232, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "로그인 코드를 입력해주세요.",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            Pinput(
              controller: _loginCodeController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border:
                    Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
                borderRadius: BorderRadius.circular(8),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: const Color.fromRGBO(234, 239, 243, 1),
                ),
              ),
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: false,
              autofocus: true,
              onCompleted: (code) {
                Dio()
                    .get('http://$fireServerUrl/logincode/$code',
                        options: Options(
                          headers: {
                            "authorization":
                                "Basic 6BB6EEF72AD57F14F4B59F2C1AE2F",
                          },
                        ))
                    .then((response) {
                  userUid = response.data["userUid"];

                  //TODO 유저 데이터 가져오기

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LobbyPage(),
                    ),
                  );
                });
              },
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      title: const Text("어떻게 로그인하나요?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("1. 스마트폰, Mac에서 Fire를 설치한 후 로그인합니다."),
                          Text("2. 오른쪽 아래 '계정' 버튼에서 로그인 코드를 클릭하세요."),
                          Text("3. 화면에 표시되는 코드를 이 디바이스에 입력하세요."),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("확인"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("어떻게 로그인하나요?"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            signInWithGoogle().then((credential) {
              if (credential.credential != null) {
                userUid = credential.user!.uid;

                //TODO 유저 데이터 가져오기

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LobbyPage(),
                  ),
                );
              }
            });
          },
          child: const Text("로그인"),
        ),
      ),
    );
  }
}
