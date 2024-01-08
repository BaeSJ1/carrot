import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesyy/page/detail.dart';
import 'package:tesyy/repository/contents_repository.dart';
import 'package:tesyy/utils/data_utils.dart';

class MyFavoriteContents extends StatefulWidget {
  MyFavoriteContents({super.key});

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  late ContentsRepository contentsRepository;

  @override
  void initState(){
    super.initState();
    contentsRepository= ContentsRepository();
  }

  _appBarWidget() {
    return AppBar(
      title: Text("관심목록",
      style: TextStyle(fontSize: 15),)
    );
  }

  _makeDataList(List<dynamic>? datas){
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index){
        Map<String, dynamic> data = datas?[index];
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return DetailContentView(data: datas?[index],);
            }));
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                      tag: datas?[index]["cid"],
                      child: Image.asset(
                        datas?[index]["image"],
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas?[index]["title"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 5),
                          Text(
                            datas[index]["location"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: Colors.black.withOpacity(0.3)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DataUtils.calcStringToWon(datas[index]["price"]),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Expanded(child: Container(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/svg/heart_off.svg",
                                    width: 13,
                                    height: 13,
                                  ),
                                  SizedBox(width: 5),
                                  Text(datas?[index]["likes"]),
                                ],
                              ),
                            ),
                          ))

                        ],
                      )
                  ))
                ],
              )
          ),
        );
      },
      itemCount: datas!.length,
      separatorBuilder: (BuildContext _context, int index){
        return Container(height: 1, color: Colors.black.withOpacity(0.4));
      },
    );

  }

  _bodyWidget(){
    return FutureBuilder(
        future: _loadMyFavoriteContentList(),
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("데이터 오류"));
          }
          if(snapshot.hasData){
            return _makeDataList(snapshot.data);
          }
          return Center(child: Text("해당 지역에 데이터가 없습니다."));
        });
  }

  Future<List?> _loadMyFavoriteContentList() async{
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
