import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:tesyy/components/manor_temperature_widget.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({super.key, required this.data});


  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<Map<String,String>> imgList;
  late int _current;
  @override
  void didChangeDepencies(){
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      {"id" :"0","url": widget.data["image"].toString()},
      {"id" :"1","url": widget.data["image"].toString()},
      {"id" :"2","url": widget.data["image"].toString()},
      {"id" :"3","url": widget.data["image"].toString()},
      {"id" :"4","url": widget.data["image"].toString()},
    ];
    _current=0;
  }



  _appbarWidget(){
    return AppBar(
      backgroundColor: Colors.transparent, //투명으로 배경 설정
      elevation: 0,
      leading: IconButton(onPressed: () {
        Navigator.pop(context); //뒤로 나갈때
      }, icon: Icon(Icons.arrow_back, color: Colors.white),),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  _makeSliderimage(){
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data['cid'].toString(),
            child: CarouselSlider(
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0, //무한하게 스크롤 되는 옵션
                  enableInfiniteScroll: false, // 무한하게 스크롤 되는 거 막는 거
                  viewportFraction: 1, //정사이즈로
                  onPageChanged: (index,reason){
                    setState(() {
                      _current = index;
                    });
                  }
              ),
              items: imgList.map((map){
                return Image.asset(
                    map["url"].toString(),
                    width: size.width,
                    // widget.data['image']??'',
                    // width: 700,
                    // height: size.width,
                    fit: BoxFit.fill
                );
              },).toList(),
            ),
          ),
          Positioned(
            bottom:0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((map){
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == int.parse(map["id"].toString())
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  _sellersSimpleInfo(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("개발하는남자",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text("제주시 도남동"),
          ],
          ),
          Expanded(child: ManorTemperature(manorTemp: 37.5))
        ],
      ),
    );
  }

  _bodyWidget(){
    return Column(
      children: [
        _makeSliderimage(),
        _sellersSimpleInfo(),
      ],
    );
  }

  _bottomBarWidget(){
    return Container(
      width: size.width,
      height: 55,
      color: Colors.red,
    );
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    imgList = [
      {"id" :"0","url": widget.data["image"].toString()},
      {"id" :"1","url": widget.data["image"].toString()},
      {"id" :"2","url": widget.data["image"].toString()},
      {"id" :"3","url": widget.data["image"].toString()},
      {"id" :"4","url": widget.data["image"].toString()},
    ];
    _current=0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
