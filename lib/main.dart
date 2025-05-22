import 'package:flutter/material.dart';
import 'home_page.dart';
import 'ai_page.dart';
import 'my_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF5DEB3), // 米色
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFFFFF8E1), // 更浅的米色背景
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFB8860B), // 深米色/金色
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    AIPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, color: Color(0xFFB8860B)), // 选中时米色
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            activeIcon: Icon(Icons.smart_toy, color: Color(0xFFB8860B)),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person, color: Color(0xFFB8860B)),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey, // 选中时文字颜色
        unselectedItemColor: Colors.grey,     // 未选中时文字颜色
        onTap: _onItemTapped,
      ),
    );
  }
}
