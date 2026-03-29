import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:journal/core/services/ai_service.dart';
import 'package:journal/core/services/secure_storage_service.dart';

class OllamaService implements AIService {
  final Dio dio;
  final SecureStorageService storageService;
  final String _baseUrl = "https://ollama.com/api/chat";
  OllamaService(this.dio, this.storageService);

  @override
  Future<AIResult> process(String content) async {
    final prompt = """
You are an AI assistant that rewrites personal journals in a casual, first-person diary style.

TASK:
- Rewrite the journal entry in FIRST PERSON (use "I", "me", "my").
- Keep it casual, natural, and engaging — like a real diary entry.
- NEVER add any titles, headings, or labels (like "Daily Reflection", "Journal Entry", or anything similar).
- Do NOT add hashtags on your own.
- Keep the original meaning and emotions intact.
- Do NOT write in second person or as an outside narrator.

PRIVACY RULES:
- Replace any sensitive personal information with safe imaginary data:
  - Names → imaginary names
  - Phone numbers → dummy numbers
  - Exact locations → generic or fictional places
  - Emails or IDs → placeholders
- Never reveal real personal information.

LENGTH RULES:
- Short journals → concise, flowing summary
- Long journals → expand naturally while keeping diary feel
- Keep the writing smooth and human, do not force extra words

EXTRA INFO:
- Extract 3–6 relevant tags from the content (ONLY based on the journal text)
- Determine the mood in ONE word (e.g., happy, reflective, anxious, sad, excited)

OUTPUT FORMAT:
Return STRICT JSON ONLY, no extra text:

{
  "summary": "...",
  "tags": ["...", "..."],
  "mood": "..."
}
""";
    final token = await storageService.getOllamaToken();

    final response = await dio.post(
      _baseUrl,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          // "Content-Type": "application/json",
        },
        contentType: "application/json",
      ),
      data: {
        "model": "gpt-oss:120b",
        "messages": [
          {"role": "system", "content": prompt},
          {"role": "user", "content": "Journal: $content"},
        ],
        "stream": false,
      },
    );

    final text = response.data['message']['content'];
    final parsed = jsonDecode(text);
    return AIResult.fromJson(parsed);
  }

  @override
  Future<bool> checkConnection({String? apiKey}) async {
    try {
      final token = apiKey ?? await storageService.getOllamaToken();
      if (token == null) return false;
      final response = await dio.post(
        _baseUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            // "Content-Type": "application/json",
          },
          contentType: "application/json",
        ),
        data: {
          "model": "gpt-oss:120b",
          "messages": [
            {"role": "user", "content": "Hi"},
          ],
          "stream": false,
        },
      );
      return response.statusCode != null && response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
