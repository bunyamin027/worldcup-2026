import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── API Service – Cloudflare Worker Proxy ──────────────────────────────────
class ApiService {
  static const String _baseUrl = 'https://worldcup-2026.bunyaminkahraman027.workers.dev';
  static const Duration _timeout = Duration(seconds: 12);

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── Generic GET ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
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

  // ── Standings (Puan Durumu) ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getStandings({
    required int league,
    required int season,
  }) {
    return _get('/standings', queryParams: {
      'league': league.toString(),
      'season': season.toString(),
    });
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
