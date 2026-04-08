import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hijri_date/hijri.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'تقويم الإمارات',
          scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          }, scrollbars: false),
          theme: ThemeData(
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: AwqatApp(),
          )
      )
  );
}

class AwqatApp extends StatefulWidget {
  const AwqatApp({super.key});

  @override
  State<AwqatApp> createState() {
    return AwqatAppState();
  }
}

class AwqatAppState extends State<AwqatApp> {

  String city = 'rak';
  final PageController _controller = PageController(
    initialPage: HijriDate
        .now()
        .dayOfYear - 1,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'montaqa@gmail.com',
                queryParameters: {
                  'subject': 'إرسال التقاويم الناقصة',
                  'body': 'نتمتى إرسال التقاويم الناقصة لبقية المدن على هيئة PDF الصادرة من الأوقاف',
                },
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                throw 'Could not launch $emailLaunchUri';
              }
            },
            child: Text('إرسال تقويم'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                city = 'auh';
              });
            },
            child: Text('أبوظبي'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                city = 'shj';
              });
            },
            child: Text('الشارقة'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                city = 'rak';
              });
            },
            child: Text('رأس الخيمة'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                city = 'uaq';
              });
            },
            child: Text('أم القيوين'),
          ),
        ],
      ),
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: _controller,
        padEnds: false,
        itemCount: 355,
        // todo: change every year
        itemBuilder: (context, position) {
          return FittedBox(
            child: (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) ?
            Image.network('https://awqat.cc/assets/$city/$position.webp') :
            Image.asset( // Covers linux/win/Web
              '$city/$position.webp',
            ),
          );
        },
      ),
    );
  }
}
