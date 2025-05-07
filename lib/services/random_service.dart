import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class RandomService extends ChangeNotifier {
  
  int generateRandomInteger() {
    final random = Random();
    return random.nextInt(100);
  }

  double generateRandomDouble() {
    final random = Random();
    return random.nextDouble() * 100;
  }

  Future<String> generateRandomString() {
    int randomInteger = generateRandomInteger();

    final uri = Uri.parse('https://randommer.io/api/Text/LoremIpsum?loremType=normal&type=words&number=$randomInteger');

    return http.get(
      uri, 
      headers: {
        'X-Api-Key': '30d85a02efaa4c229783d4fc490b0838'
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