import 'package:flutter/material.dart';
import 'ebook_page.dart';
import 'package:intl/intl.dart'; // 需要在pubspec.yaml添加intl依赖
import 'package:geolocator/geolocator.dart'; // 需要在pubspec.yaml添加geolocator依赖

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _date = '';
  String _weather = '晴'; // 这里用假数据，实际可接入API
  String _location = '未知';
  String _quote = '每天进步一点点！';

  @override
  void initState() {
    super.initState();
    _date = DateFormat('yyyy年MM月dd日').format(DateTime.now());
    _getLocation();
    // _getWeather(); // 实际天气可接入API
    // _getQuote();   // 实际金句可接入API
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _location = '(${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)})';
      });
    } catch (e) {
      setState(() {
        _location = '定位失败';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部信息栏
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF5DEB3),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 日期和天气
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _date,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB8860B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20, color: Color(0xFFB8860B)),
                          Text(
                            _location,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.wb_sunny, size: 20, color: Color(0xFFB8860B)),
                          Text(
                            _weather,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 分隔线
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: 1,
                  height: 48,
                  color: Color(0xFFEDD9A3),
                ),
                // 每日金句
                Container(
                  constraints: const BoxConstraints(maxWidth: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    _quote,
                    style: const TextStyle(fontSize: 18, color: Color(0xFFB8860B)),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 磁贴区
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildTile(context, Icons.book, '电子书', width: 100, height: 100),
                _buildTile(context, Icons.forum, '讨论', width: 100, height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String label, {double width = 100, double height = 100}) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Color(0xFFF5DEB3),
        borderRadius: BorderRadius.circular(20),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (label == '电子书') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const EbookPage()),
              );
            }
            // 其他磁贴可在此添加跳转
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Color(0xFFB8860B)),
              const SizedBox(height: 18),
              Text(
                label,
                style: const TextStyle(fontSize: 22, color: Color(0xFFB8860B), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
