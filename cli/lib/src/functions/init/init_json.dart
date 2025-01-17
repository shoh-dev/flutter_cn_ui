import 'dart:convert';
import 'dart:io';
import 'package:fcnui/src/functions/functions.dart';

class InitJson {
  final String path;

  InitJson({required this.path});

  late final InitJsonMd initJsonMd;

  bool get isInitialized {
    return initJsonMd.registry.componentsFolder != null;
  }

  File? getJsonFile() {
    final file = File(path);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  InitJsonMd getCnUiJson() {
    try {
      final file = File(path);
      return InitJsonMd.fromJson(jsonDecode(file.readAsStringSync()));
    } catch (e) {
      logger('Error reading fcnui.json file: $e');
      close();
      rethrow;
    }
  }

  void initJsonFile() {
    //Create a new Json file
    try {
      //1. check if file exists
      //1.1 if not, create file
      final file = getJsonFile();
      if (file == null) {
        final defaultJson = InitJsonMd();
        File(path).writeAsStringSync(jsonEncode(defaultJson.toJson()));
        logger('fcnui.json file created');
      } else {
        logger('fcnui.json file exists');
      }
      initJsonMd = getCnUiJson();
    } catch (e) {
      logger('Error fcnui.json file initFlutterCnJson: $e');
      close();
    }
  }

  void updateJson(InitJsonMd newJsonData) {
    if (getJsonFile() == null) {
      logger('Error: fcnui.json file not found');
      close();
    }
    final file = getJsonFile()!;
    file.writeAsStringSync(jsonEncode(newJsonData.toJson()));
  }

  bool isComponentRegistered(RegistryComponentData component) {
    final json = getCnUiJson();
    return json.registry.components
        .any((element) => element.name == component.name);
  }

  void registerComponent(RegistryComponentData component) {
    if (getJsonFile() == null) {
      logger('Error: fcnui.json file not found');
      close();
    }
    final json = getCnUiJson();
    //if exists replace
    final index = json.registry.components
        .indexWhere((element) => element.name == component.name);
    if (index != -1) {
      json.registry.components[index] = component;
      getJsonFile()!.writeAsStringSync(jsonEncode(json.toJson()));
      logger("Updated ${component.name} in fcnui.json");
      return;
    }
    //if not exists add
    json.registry.components.add(component);
    logger("Registered ${component.name} in fcnui.json");
    getJsonFile()!.writeAsStringSync(jsonEncode(json.toJson()));
  }

  void unregisterComponent(String componentName) {
    if (getJsonFile() == null) {
      logger('Error: fcnui.json file not found');
      close();
    }
    final json = getCnUiJson();
    final index = json.registry.components
        .indexWhere((element) => element.name == componentName);
    if (index != -1) {
      json.registry.components.removeAt(index);
      logger("Unregistered $componentName in fcnui.json");
      getJsonFile()!.writeAsStringSync(jsonEncode(json.toJson()));
      return;
    }
    logger("$componentName not found in fcnui.json");
  }

  String getComponentVersion(String componentName) {
    final json = getCnUiJson();
    final component = json.registry.components
        .firstWhere((element) => element.name == componentName);
    return component.version;
  }
}
