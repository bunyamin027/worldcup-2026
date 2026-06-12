import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/mock_data.dart';

// ─── IP Sanitization Utility ────────────────────────────────────────────────
extension IpSanitizer on String {
  String sanitizeIp() {
    String text = this;
    text = text.replaceAll(RegExp(r'FIFA\s*World\s*Cup', caseSensitive: false), 'International Tournament');
    text = text.replaceAll(RegExp(r'World\s*Cup\s*2026', caseSensitive: false), 'Global Football 2026');
    text = text.replaceAll(RegExp(r'World\s*Cup', caseSensitive: false), 'Global Football');
    text = text.replaceAll(RegExp(r'WC\s*2026', caseSensitive: false), 'GF 2026');
    text = text.replaceAll(RegExp(r'WC26', caseSensitive: false), 'GF26');
    text = text.replaceAll(RegExp(r'FIFA', caseSensitive: false), 'Global');
    return text;
  }
}

dynamic sanitizeData(dynamic data) {
  if (data is String) {
    return data.sanitizeIp();
  } else if (data is List) {
    return data.map((item) => sanitizeData(item)).toList();
  } else if (data is Map<String, dynamic>) {
    return data.map((key, value) => MapEntry(key, sanitizeData(value)));
  }
  return data;
}

// ─── API Service – Cloudflare Worker Proxy ──────────────────────────────────
class ApiService {
  // Buraya kendi Cloudflare Worker URL'ini koyacaksın
  static const String baseUrl = 'https://worldcup-2026.bunyaminkahraman027.workers.dev';
  static const Duration _timeout = Duration(seconds: 12);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Tüm turnuva fikstürünü tek seferde çeker
  static Future<List<dynamic>> getAllFixtures() async {
    // API devredışı, mock data döndür
    return sanitizeData(MockData.fixtures) as List<dynamic>;
  }

  // ── Generic GET ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return sanitizeData(decoded) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('İstek zaman aşımına uğradı', statusCode: 408);
    } on FormatException {
      throw ApiException('Geçersiz JSON yanıtı', statusCode: 0);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Bağlantı hatası: $e', statusCode: 0);
    }
  }

  // ── Fixtures (Maçlar) ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getFixtures({
    required String date,
    int? league,
    int? season,
  }) {
    final params = <String, String>{'date': date};
    if (league != null) params['league'] = league.toString();
    if (season != null) params['season'] = season.toString();
    return _get('/fixtures', queryParams: params);
  }

  // ── Single Fixture ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getFixtureById({required int id}) {
    return _get('/fixtures', queryParams: {'id': id.toString()});
  }

  // ── Live Fixtures (Canlı Maçlar) ──────────────────────────────────────────
  Future<Map<String, dynamic>> getLiveFixtures() {
    return _get('/fixtures', queryParams: {'live': 'all'});
  }



  // ── Fixture Events (Maç Olayları) ─────────────────────────────────────────
  Future<Map<String, dynamic>> getFixtureEvents({
    required int fixtureId,
  }) {
    return _get('/fixtures/events', queryParams: {
      'fixture': fixtureId.toString(),
    });
  }

  // ── Fixture Lineups (Kadrolar) ────────────────────────────────────────────
  Future<Map<String, dynamic>> getLineups({
    required int fixtureId,
  }) {
    return _get('/fixtures/lineups', queryParams: {
      'fixture': fixtureId.toString(),
    });
  }

  // ── Fixture Statistics (İstatistikler) ────────────────────────────────────
  Future<Map<String, dynamic>> getFixtureStats({
    required int fixtureId,
  }) {
    return _get('/fixtures/statistics', queryParams: {
      'fixture': fixtureId.toString(),
    });
  }

  // ── Top Scorers (Gol Krallığı) ───────────────────────────────────────────
  Future<Map<String, dynamic>> getTopScorers({
    required int league,
    required int season,
  }) {
    return _get('/players/topscorers', queryParams: {
      'league': league.toString(),
      'season': season.toString(),
    });
  }

  // ── Teams (Takımlar) ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getTeamInfo({
    required int teamId,
  }) {
    return _get('/teams', queryParams: {
      'id': teamId.toString(),
    });
  }

  // ── Dispose ───────────────────────────────────────────────────────────────
  void dispose() {
    _client.close();
  }
}

// ─── Custom Exception ───────────────────────────────────────────────────────
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, {required this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
