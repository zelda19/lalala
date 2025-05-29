import 'dart:convert';
import 'package:http/http.dart' as http;

class ThingsboardService {
  final String baseUrl = 'https://thingsboard.cloud';
  final String deviceToken = '81gjqw8op1xuuz43zu3f';

  Future<Map<String, dynamic>?> fetchLatestTelemetry() async {
    final url = Uri.parse('$baseUrl/api/v1/$deviceToken/telemetry?keys=gas');
    print('Fetching from: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('Empty response body');
          return null;
        }

        final Map<String, dynamic> data = json.decode(response.body);
        print('Parsed data: $data');

        if (data.isEmpty) {
          print('No data received');
          return null;
        }

        return data;
      } else if (response.statusCode == 404) {
        print('Device not found or no data available');
        return null;
      } else {
        print('Failed to fetch telemetry: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchTelemetryAlternative() async {
    final url = Uri.parse('$baseUrl/api/v1/$deviceToken/telemetry?keys=gas');

    try {
      final response = await http.get(url);
      print('Alternative endpoint - Status: ${response.statusCode}');
      print('Alternative endpoint - Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Alternative method error: $e');
    }

    return null;
  }
}