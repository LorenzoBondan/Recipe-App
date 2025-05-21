import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class RandomService extends ChangeNotifier {
  
  int generateRandomInteger({int max = 100}) {
    final random = Random();
    return random.nextInt(max);
  }

  double generateRandomDouble({int max = 100}) {
    final random = Random();
    return random.nextDouble() * max;
  }

  Future<String> generateRandomString({int maxLength = 25}) {
    int randomInteger = generateRandomInteger(max: maxLength);

    final uri = Uri.parse('https://randommer.io/api/Text/LoremIpsum?loremType=normal&type=words&number=$randomInteger');

    return http.get(
      uri, 
      headers: {
        'X-Api-Key': 'cc51f0942e9d4a9a9a711b4e2cfba472'
      }
    ).then((response) {
      if (response.statusCode == 200) {
        return response.body.toString();
      }
      else {
        throw Exception('Failed to generate string.');
      }
    });
  }
}