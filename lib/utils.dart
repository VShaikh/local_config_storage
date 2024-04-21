import 'dart:io';

bool existsFile(filePath) {
  return File.fromUri(Uri.file(filePath)).existsSync();
}

String fileContent(String filePath) {
  if (existsFile(filePath)) {
    return File.fromUri(Uri.parse(filePath)).readAsStringSync();
  }
  return "";
}

void saveContent(String filePath, String contents) {
  File.fromUri(Uri.parse(filePath)).writeAsStringSync(contents, flush: true);
}
