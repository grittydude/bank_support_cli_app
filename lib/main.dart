import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  final env = DotEnv()..load();

  final apiKey = env['OPENROUTER_API_KEY'];
  final model = env['MODEL_NAME'];

  if (apiKey == null || model == null) {
    print('Missing .env values');
    exit(1);
  }

  if (args.isEmpty) {
    print('Run with a customer query');
    print('Example: dart run lib/main.dart "My card was charged twice"');
    exit(1);
  }

  final query = args.join(' ');

  // customers intent
  final intentPrompt = readPrompt(
    'lib/prompts/customers_intent.txt',
  ).replaceAll('{query}', query);

  final intent = await askAI(intentPrompt, apiKey, model);

  print('\n--- Intent ---');
  print(intent);

  // possible categories
  final categoriesPrompt = readPrompt(
    'lib/prompts/possible_categories.txt',
  ).replaceAll('{intent}', intent);

  final categories = await askAI(categoriesPrompt, apiKey, model);

  print('\n--- Possible Categories ---');
  print(categories);

  // appropraite category
  final categoryPrompt = readPrompt(
    'lib/prompts/appropraite_category.txt',
  ).replaceAll('{categories}', categories);

  final selectedCategory = await askAI(
    categoryPrompt,
    apiKey,
    model,
  );

  print('\n--- Selected Category ---');
  print(selectedCategory);

  // additional details
  final detailsPrompt = readPrompt(
    'lib/prompts/additional_details.txt',
  )
      .replaceAll('{query}', query)
      .replaceAll('{category}', selectedCategory);

  final details = await askAI(
    detailsPrompt,
    apiKey,
    model,
  );

  print('\n--- Extra Details Needed ---');
  print(details);

  // final response
  final responsePrompt = readPrompt(
    'lib/prompts/generate_short_response.txt',
  )
      .replaceAll('{query}', query)
      .replaceAll('{category}', selectedCategory)
      .replaceAll('{details}', details);

  final finalResponse = await askAI(
    responsePrompt,
    apiKey,
    model,
  );

  print('\n--- Final Response ---');
  print(finalResponse);
}

String readPrompt(String path) {
  return File(path).readAsStringSync();
}

Future<String> askAI(
  String prompt,
  String apiKey,
  String model,
) async {
  final url = Uri.parse(
    'https://openrouter.ai/api/v1/chat/completions',
  );

  final res = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'model': model,
      'max_tokens': 300,
      'temperature': 0.2,
      'messages': [
        {
          'role': 'user',
          'content': prompt,
        }
      ]
    }),
  );

  if (res.statusCode != 200) {
    print('\nRequest failed');
    print(res.body);
    exit(1);
  }

  final data = jsonDecode(res.body);

  return data['choices'][0]['message']['content'];
}
