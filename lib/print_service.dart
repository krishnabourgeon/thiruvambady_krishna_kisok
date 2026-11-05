import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'services/app_config.dart';

class PrinterService {
  static const MethodChannel _channel = MethodChannel('masung_printer');

  static Future<bool> connect() async {
    return await _channel.invokeMethod('connect');
  }

  static Future<void> printText(String text) async {
    await _channel.invokeMethod('printText', {'text': text});
  }

  static Future<void> cutPaper() async {
    await _channel.invokeMethod('cutPaper');
  }

  /// Turns the API's `bill_image` into raw image bytes for the printer.
  /// Accepts a full URL, a server-relative path, or base64 (with or without
  /// a `data:image/...;base64,` prefix). Returns null if it can't be loaded,
  /// so the receipt still prints without the logo.
  static Future<Uint8List?> loadBillImage(String? src) async {
    if (src == null || src.trim().isEmpty) return null;
    var value = src.trim();
    // The API sometimes glues the website in front of an already-full URL,
    // e.g. "https://site.org/http://other.in/a.jpeg". Keep the last full URL.
    final lastUrl = value.lastIndexOf(RegExp(r'https?://'));
    if (lastUrl > 0) value = value.substring(lastUrl);
    try {
      if (value.startsWith('data:')) {
        return base64Decode(value.substring(value.indexOf(',') + 1));
      }
      Uri uri;
      if (value.startsWith('http://') || value.startsWith('https://')) {
        uri = Uri.parse(value);
      } else if (value.contains('/') || value.contains('.')) {
        // Relative path — resolve against the server root (baseUrl minus "api/").
        final root = AppConfig.baseUrl.replaceFirst(RegExp(r'api/?$'), '');
        uri = Uri.parse(root).resolve(value.replaceFirst(RegExp(r'^/'), ''));
      } else {
        return base64Decode(value);
      }
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
        return res.bodyBytes;
      }
      log('bill_image fetch failed: ${res.statusCode} $uri');
    } catch (e) {
      log('bill_image load error: $e');
    }
    return null;
  }

  static Future<void> printReceipt({
    String? temple,
    String? templeAddress,
    String? templePlace,
    int? id,
    String? today,
    String? mode,
    String? total,
    String? website,
    String? billImage,
    List<Map<String, dynamic>>? items,
  }) async {
    final imageBytes = await loadBillImage(billImage);
    await _channel.invokeMethod('printReceipt', {
      'temple': temple,
      'templeAddress': templeAddress,
      'templePlace': templePlace,
      'billNo': id.toString(),
      'date': today,
      'mode': mode,
      'total': total,
      'website': website,
      'image': imageBytes,
      'items': items,
    });
  }
}
