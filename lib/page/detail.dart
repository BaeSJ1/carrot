import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesyy/components/manor_temperature_widget.dart';
import 'package:tesyy/repository/contents_repository.dart';

import '../utils/data_utils.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;
  DetailContentView({super.key, required this.data});


  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late ContentsRepository contentsRepository;
  late Size size;
  late List<Map<String,String>> imgList;
  late int _current;
  double scrollpositionToAlpha = 0;
  ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  bool isMyFavoriteContent = false;

  @override
  void initState() {
    super.initState();
    isMyFavoriteContent = false;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black).animate(_animationController);
    contentsRepository = ContentsRepository();
    _controller.addListener(() {
      setState(() {
        if(_controller.offset>255){
          scrollpositionToAlpha = 255;
        } else{
          scrollpositionToAlpha = _controller.offset;
        }
        _animationController.value = scrollpositionToAlpha / 255;
      });
    });
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async{
    bool ck = await contentsRepository.isMyFavoritecontents(widget.data["cid"]!);
    setState(() {
      isMyFavoriteContent = ck;
    });

  }


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

  _makeIcon(IconData icon){
    return AnimatedBuilder(
    animation: _colorTween,
    builder:(context,child) =>
        Icon(icon, color: _colorTween.value),);
  }


  _appbarWidget(){
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(onPressed: () {
        Navigator.pop(context); //뒤로 나갈때
      }, icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(onPressed: (){}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: (){}, icon: _makeIcon(Icons.more_vert))
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

  _line(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  _contentDetail(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            widget.data["title"].toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Text(
            "디지털/가전 . 22시간 전",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12
            ),
          ),
          SizedBox(height: 15),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다.\n거래는 직거래만 합니다.",
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "채팅 3, 관심 17, 조회 295",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15,)
        ],),
    );
  }

  _otherCellContents(){
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //양끝으로
        children: [
          Text("판매자님의 판매 상품",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Text("모두보기",
              style: TextStyle(
                  fontSize:12,
                  fontWeight: FontWeight.bold
              )),],
      ),
    );
  }

  _bodyWidget(){
    return CustomScrollView(
      controller: _controller,
        slivers: [
          SliverList(delegate: SliverChildListDelegate([
            _makeSliderimage(),
            _sellersSimpleInfo(),

            _contentDetail(),
            _line(),
            _otherCellContents(),
          ],
          ),
          ),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal:15),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing:10, crossAxisSpacing: 10),
              delegate: SliverChildListDelegate(List.generate(20, (index) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey,
                          height: 120,
                        ),
                      ),
                      Text("상품 제목", style: TextStyle(fontSize: 14),),
                      Text("금액", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
                    ],
                  ),
                );
              }).toList()),
            ),
          ),
        ]
    );
  }

  _bottomBarWidget(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(
        children: [
        GestureDetector(
          onTap: () async{

            if(isMyFavoriteContent){
              //제거
              await contentsRepository.deleteMyFavoriteContent(widget.data["cid"]!);
            }else{
              await contentsRepository.addMyFavoriteContent(widget.data);
            }

            setState(() {
              isMyFavoriteContent = !isMyFavoriteContent;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text(
                isMyFavoriteContent
                    ? "관심목록에 추가됐습니다."
                    : "관심목록에서 제거되었습니다.",
              ),
            ));
          },
          child: SvgPicture.asset(
            isMyFavoriteContent
            ? "assets/svg/heart_on.svg"
            : "assets/svg/heart_off.svg",
            width: 25,
            height: 25,
            color: Color(0xfff08f4f),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 10),
          width: 1, height: 40, color: Colors.grey.withOpacity(0.3),
        ),
        Column(children: [
          Text( DataUtils.calcStringToWon(widget.data["price"]??"".toString()),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("가격제안불가",
              style: TextStyle(fontSize: 14, color: Colors.grey))
        ],),
        Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xfff08f4f)),
                  child: Text("채팅으로 거래하기",
                    style: TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),),
              ],
            ))
      ],),
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
      key: scaffoldMessengerKey,
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(context),
    );
  }


}
