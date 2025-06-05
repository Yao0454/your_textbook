import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_view_page.dart';

class EbookPage extends StatefulWidget {
  const EbookPage({super.key});

  @override
  State<EbookPage> createState() => _EbookPageState();
}

class _EbookPageState extends State<EbookPage> {
  String selectedSubject = '语文';
  final List<String> subjects = ['语文', '数学', '英语', '物理', '化学', '生物'];
  List<Map<String, dynamic>> subjectFiles = [];
  bool _mounted = true; // 添加一个标志来追踪 widget 是否已挂载

  @override
  void dispose() {
    _mounted = false; // 在 dispose 时设置标志为 false
    super.dispose();
  }

  Future<void> _loadSubjectFiles() async {
    final url = Uri.parse('http://www.fengqwq.cn:9000/books/' +
        Uri.encodeComponent(selectedSubject) +
        '.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && _mounted) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          subjectFiles = data.cast<Map<String, dynamic>>();
        });
      } else if (_mounted) {
        setState(() {
          subjectFiles = [];
        });
        print('服务器返回错误: ${response.statusCode}');
      }
    } catch (e) {
      if (_mounted) {
        setState(() {
          subjectFiles = [];
        });
        print('请求失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('电子书'),
        backgroundColor: const Color(0xFFF5DEB3),
        foregroundColor: const Color(0xFFB8860B),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: selectedSubject,
              underline: const SizedBox(),
              icon: const Icon(Icons.menu_book, color: Color(0xFFB8860B)),
              dropdownColor: const Color(0xFFFFF8E1),
              style: const TextStyle(color: Color(0xFFB8860B), fontSize: 16),
              items: subjects
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                  .toList(),
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    selectedSubject = value;
                  });
                  await _loadSubjectFiles();
                }
              },
            ),
          ),
        ],
      ),
      body: subjectFiles.isEmpty
          ? const Center(
              child: Text('暂无该科目电子书',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: subjectFiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final file = subjectFiles[index];
                final fileName = file['name'];
                return Material(
                  color: const Color(0xFFF5DEB3),
                  borderRadius: BorderRadius.circular(18),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      final pdfUrl = 'http://www.fengqwq.cn:9000/books/生物/biology3.pdf';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewPage(pdfUrl: pdfUrl),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB8860B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            file['url'],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}