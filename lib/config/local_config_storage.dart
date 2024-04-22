import 'dart:convert';
import 'dart:io';

import 'utils.dart';

class LocalConfigStorage {
  static LocalConfigStorage? instance;

  late String _dataFilePath;

  // final Map<String, dynamic> _dataMap = {};

  late String _defaultsFilePath;

  // final Map<String, dynamic> _defaultsDataMap = {};

  static LocalConfigStorage getInstance() {
    instance ??= LocalConfigStorage();
    return instance!;
  }

  void init(String dataFile, Map<String, dynamic> data) {
    _dataFilePath = dataFile;
    _defaultsFilePath = getDefaultsFilePath(dataFile);
    if (!existsDataFile() || !existsDefaultsFile()) {
      // _defaultsDataMap.clear();
      // _defaultsDataMap.addAll(data);
      // _dataMap.clear();
      // _dataMap.addAll(data);
      _persistData(data);
      _persistDefaults(data);
    } else {
      throw Exception("Unable to find file $_dataFilePath or $_defaultsFilePath");
      // _dataMap.clear();
      // _dataMap.addAll(_dataFromFile());
      //
      // _defaultsDataMap.clear();
      // _defaultsDataMap.addAll(_defaultsFromFile());
    }
  }

  bool existsDataFile() => existsFile(_dataFilePath);

  bool existsDefaultsFile() => existsFile(_defaultsFilePath);

  String getDefaultsFilePath(filePath) => filePath + ".defaults";

  void resetDefaultConfig() {
    _deleteDataFile();
    // _dataMap.clear();
    // _dataMap.addAll(_defaultsDataMap);
    _persistData(_defaultsFromFile());
  }

  void _deleteDataFile() => existsFile(_dataFilePath) ? File(_dataFilePath).deleteSync() : {};

  Map<String, dynamic> _dataFromFile() {
    if (existsFile(_dataFilePath) && fileContent(_dataFilePath).isNotEmpty) {
      var content = fileContent(_dataFilePath);
      return jsonDecode(content) as Map<String, dynamic>;
    } else {
      throw Exception("Config file not found: $_dataFilePath");
    }
  }

  Map<String, dynamic> _defaultsFromFile() {
    if (existsFile(_defaultsFilePath) && fileContent(_defaultsFilePath).isNotEmpty) {
      var content = fileContent(_defaultsFilePath);
      return jsonDecode(content) as Map<String, dynamic>;
    } else {
      throw Exception("Config file not found: $_defaultsFilePath");
    }
  }

  bool _existsInDataFile(String key) {
    Map<String, dynamic> map = _dataFromFile();
    return map.isNotEmpty && map.containsKey(key);
  }

  bool _existsIn(Map<String, dynamic> data, String key) => data.entries.where((e) => e.key == key).isNotEmpty;

  dynamic _get(String key) {
    var dataMap = _dataFromFile();
    if (_existsIn(dataMap, key)) {
      return dataMap.entries.firstWhere((e) => e.key == key).value;
    } else {
      throw Exception("No value found for $key");
    }
  }

  void set(String key, dynamic value) {
    Map<String, dynamic> map = _dataFromFile();
    if (_existsInDataFile(key)) {
      map.update(key, (v) => value);
    } else {
      map[key] = value;
    }

    _saveDataValues(map);
  }

  void _saveDataValues(Map<String, dynamic> data) {
    saveContent(_dataFilePath, jsonEncode(data));
  }

  void _persistData(Map<String, dynamic> data) {
    saveContent(_dataFilePath, jsonEncode(data.map((key, value) => MapEntry(key, value))));
  }

  void _persistDefaults(Map<String, dynamic> data) {
    saveContent(_defaultsFilePath, jsonEncode(data.map((key, value) => MapEntry(key, value))));
  }

  bool getBool(String key) => _get(key);

  String getString(String key) => _get(key);

  int getInt(String key) => _get(key);
}
