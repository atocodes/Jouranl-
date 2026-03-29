import 'package:dio/dio.dart';
import 'package:journal/core/services/secure_storage_service.dart';

class TelegramService {
  final Dio dio;
  final SecureStorageService storage;
  final String _baseUrl = "https://api.telegram.org";

  TelegramService(this.dio, this.storage);

  Future<bool> sendMessage(
    String text, {
    String? botToken,
    String? channelId,
  }) async {
    try {
      final token = botToken ?? await storage.getTelegramBotToken();
      final chatId = await storage.getChatId();

      await dio.post(
        "$_baseUrl/bot$token/sendMessage",
        data: {
          "chat_id": channelId ?? chatId,
          "text": text,
          "parse_mode": "Markdown",
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getMe({String? botToken}) async {
    try {
      final token = botToken ?? await storage.getTelegramBotToken();
      if (token == null) return false;
      final res = await dio.get("$_baseUrl/bot$token/getMe");
      return res.data["ok"] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
