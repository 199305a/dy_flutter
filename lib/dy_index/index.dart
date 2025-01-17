/**
 * @discripe: 底部导航
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base.dart';
import 'header.dart';
import 'funny/index.dart';
import 'focus/index.dart';
import 'commend/index.dart';
import 'fishbar/index.dart';

class DyIndexPage extends StatefulWidget {
  final arguments;
  DyIndexPage({Key key, this.arguments}) : super(key: key);

  @override
  _DyIndexPageState createState() => _DyIndexPageState();
}

class _DyIndexPageState extends State<DyIndexPage> with DYBase {
  final _bottomNavList = ["推荐", "娱乐", "关注", "鱼吧", "发现"]; // 底部导航
  DateTime _lastCloseApp; //上次点击时间
  int _currentIndex = 0;  // 底部导航当前页面
  ScrollController _scrollController = ScrollController();  // 首页整体滚动控制器
  PageController _pageController = PageController();

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  // 点击悬浮标回到顶部
  void _indexPageScrollTop() {
    _scrollController.animateTo(.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: DYBase.dessignWidth)..init(context);

    return WillPopScope(
      onWillPop: () async {
        if (_lastCloseApp == null || DateTime.now().difference(_lastCloseApp) > Duration(seconds: 1)) {
          _lastCloseApp = DateTime.now();
          Fluttertoast.showToast(msg: '再次返回退出斗鱼');
          return false;
        }
        return true;
      },
      child: Scaffold(
        // 底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: DYBase.defaultColor,
          unselectedItemColor: Color(0xff333333),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) {
            if (mounted)
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          items: [
            BottomNavigationBarItem(
                title: Text(_bottomNavList[0]),
                icon: _currentIndex == 0
                    ? _bottomIcon('images/nav/nav-12.jpg')
                    : _bottomIcon('images/nav/nav-11.jpg')),
            BottomNavigationBarItem(
                title: Text(_bottomNavList[1]),
                icon: _currentIndex == 1
                    ? _bottomIcon('images/nav/nav-22.jpg')
                    : _bottomIcon('images/nav/nav-21.jpg')),
            BottomNavigationBarItem(
                title: Text(_bottomNavList[2]),
                icon: _currentIndex == 2
                    ? _bottomIcon('images/nav/nav-32.jpg')
                    : _bottomIcon('images/nav/nav-31.jpg')),
            BottomNavigationBarItem(
                title: Text(_bottomNavList[3]),
                icon: _currentIndex == 3
                    ? _bottomIcon('images/nav/nav-42.jpg')
                    : _bottomIcon('images/nav/nav-41.jpg')),
            BottomNavigationBarItem(
                title: Text(_bottomNavList[4]),
                icon: _currentIndex == 4
                    ? _bottomIcon('images/nav/nav-52.jpg')
                    : _bottomIcon('images/nav/nav-51.jpg')),
          ]
        ),
        body: _currentPage(),
        floatingActionButton: _currentIndex != 0 ? null : FloatingActionButton(
          onPressed: _indexPageScrollTop,
          foregroundColor: DYBase.defaultColor,
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: Image.asset(
            'images/syn.webp',
            width: dp(50),
            height: dp(50),
            fit: BoxFit.contain,
          )
        ),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }

  // 底部导航对应的页面
  Widget _currentPage() {
    var pageInDevelop = Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title:Text(_bottomNavList[_currentIndex]),
          backgroundColor: DYBase.defaultColor,
          brightness: Brightness.dark,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xffff8633),
                  Color(0xffff6634)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            DyHeader(decoration: BoxDecoration(
              color: Colors.transparent,
            ),),
          ],
        ),
        preferredSize: Size.fromHeight(dp(55)),
      ),
      body: Center(child: Text(
          '正在建设中...',
          style: TextStyle(fontSize: 20, color: Colors.black45),
        ),
      ),
    );
    var _pages = [
      CommendPage(_scrollController),
      FunnyPage(),
      FocusPage(),
      FishBarPage(),
      pageInDevelop,
    ];

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: _pages.length,
      itemBuilder: (context,index)=>_pages[index]
    );
  }

  Widget _bottomIcon(path) {
    return Padding(
      padding: EdgeInsets.only(bottom: dp(4)),
      child: Image.asset(
        path,
        width: dp(25),
        height: dp(25),
        repeat:ImageRepeat.noRepeat,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      )
    );
  }

}
