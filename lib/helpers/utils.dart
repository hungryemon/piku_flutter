bool containsMarkdownCharacters(String input) {
  // List of common Markdown characters
  final markdownCharacters = RegExp(r'[\*\_\#\>\[\]\!\-\+\`\~\>\=\|]');
  
  // Return true if any of these characters are found in the string
  return markdownCharacters.hasMatch(input);
}