import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  SecureStorageService(this.storage);

  Future<void> saveTelegramBotToken(String token) =>
      storage.write(key: _Constants.botokenkey, value: token);

  Future<String?> getTelegramBotToken() =>
      storage.read(key: _Constants.botokenkey);

  Future<void> saveOllamaToken(String token) =>
      storage.write(key: _Constants.ollamaApiToken, value: token);

  Future<String?> getOllamaToken() =>
      storage.read(key: _Constants.ollamaApiToken);

  Future<void> saveChatId(String id) =>
      storage.write(key: _Constants.chatIdKey, value: id);

  Future<String?> getChatId() => storage.read(key: _Constants.chatIdKey);
}

class _Constants {
  static final String botokenkey = "bot_token";
  static final chatIdKey = "chat_id";
  static final ollamaApiToken = "ollama_api_token";
}
