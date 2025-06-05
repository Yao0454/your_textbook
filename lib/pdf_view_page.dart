import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewPage({super.key, required this.pdfUrl});

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  late Future<void> _loadPdfFuture;

  @override
  void initState() {
    super.initState();
    _loadPdfFuture = _loadPdf();
  }

  Future<void> _loadPdf() async {
    // 等待网络同步 兼容网速慢的手机之类的
    // 后面应该会改成显式等待吧。。。
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF 查看器'),
        backgroundColor: const Color(0xFFF5DEB3),
      ),
      body: FutureBuilder<void>(
        future: _loadPdfFuture,
        builder: (context, snapshot) {
          try {
            log('PDF加载状态: ${snapshot.connectionState}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              log('加载PDF失败: ${snapshot.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('加载PDF失败: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadPdfFuture = _loadPdf();
                        });
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              );
            } else {
              log('开始加载PDF: ${widget.pdfUrl}');
              return SfPdfViewer.asset(
                'assets/data/生物/biology3.pdf',
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  log('PDF加载失败: ${details.error}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('加载PDF失败: ${details.error}')),
                  );
                },
              );
            }
          } catch (e) {
            log('发生未知错误: $e');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('发生未知错误: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadPdfFuture = _loadPdf();
                      });
                    },
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}