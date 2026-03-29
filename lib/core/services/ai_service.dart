abstract class AIService {
  Future<AIResult> process(String content);
  Future<bool> checkConnection({String? apiKey});
}

class AIResult {
  final String summary;
  final List<dynamic> tags;
  final String mood;

  AIResult({required this.summary, required this.tags, required this.mood});

  factory AIResult.fromJson(dynamic json) {
    return AIResult(
      summary: json['summary'],
      tags: json['tags'],
      mood: json['mood'],
    );
  }
}
