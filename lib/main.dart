import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:todo_app/pages/tasks_page.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ja', ''), // Japanese, no country code
      ],
      //debugShowCheckedModeBanner: false,
      title: 'ToDoAPP',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        cardTheme: CardTheme(
          color: Colors.white60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 1,
        ),
      ),
      home: _splashScreenView(),
    );
  }

  SplashScreenView _splashScreenView() {
    return SplashScreenView(
      navigateRoute: const TasksPage(),
      duration: 3000,
      imageSize: 120,
      imageSrc: "assets/logo.png",
      //text: "FUKUJU IoT",
      //textStyle: const TextStyle(
      //  fontSize: 25.0,
      //),
      //textType: TextType.TyperAnimatedText, //アニメーション タイプ
      //textType: TextType.ScaleAnimatedText, //アニメーション ズーム
      /* textType: TextType.ColorizeAnimationText, //アニメーション グラデーション
    colors: const [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ], */
      backgroundColor: Colors.white,
    );
  }
}
