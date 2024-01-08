import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tesyy/page/favorite.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  late int _currentpageIndex;

  @override
  void initState(){
    super.initState();
    _currentpageIndex = 0;

  }


  _bodyWidget() {
    switch (_currentpageIndex) {
      case 0:
        return Home();
        break;

      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return MyFavoriteContents();
        break;
    }
    return Container();
  }


  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label){
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg",width: 22),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg",width: 22),
        ),
        label : "${label}"
    );
  }
  
  Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, //애니메이션 기능 고정
      onTap: (int index){
        print(index);
        setState(() { // 약간의 애니메이션 기능추가
          _currentpageIndex = index;
        });
      },
        selectedFontSize: 12,
        currentIndex: _currentpageIndex,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        items: [
          _bottomNavigationBarItem("home","홈"),
          _bottomNavigationBarItem("notes","동네생활"),
          _bottomNavigationBarItem("location","내 근처"),
          _bottomNavigationBarItem("chat","채팅"),
          _bottomNavigationBarItem("user","나의 당근"),
        ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
    );
  }
}
