import 'package:dio/dio.dart';

bool containsMarkdownCharacters(String input) {
  // List of common Markdown characters
  final markdownCharacters = RegExp(r'[\*\_\#\>\[\]\!\-\+\`\~\>\=\|]');

  // Return true if any of these characters are found in the string
  return markdownCharacters.hasMatch(input);
}

dynamic processObject(Map<String, dynamic> json,
    {List? keys, bool isFormData = false}) {
  Map<String, dynamic> result = {};
  for (var entry in json.entries) {
    var k = entry.key;
    var v = entry.value;
    if (keys == null) {
      if (v != null) result[k] = v;
    } else if (keys.contains(k) && v != null) {
      result[k] = v;
    }
  }
  return isFormData ? FormData.fromMap(result) : result;
}

String dioMediaType(String name) {
  if (name.endsWith('.jpg') || name.endsWith("jpeg")) {
    return 'image/jpeg';
  } else if (name.endsWith('.png')) {
    return 'image/png';
  } else if (name.endsWith('.gif')) {
    return 'image/gif';
  } else if (name.endsWith('.bmp')) {
    return 'image/bmp';
  } else if (name.endsWith('.webp')) {
    return 'image/webp';
  } else {
  return '';}
}
