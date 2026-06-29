import os
import re

config_file = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scripts\config.dart'

with open(config_file, 'r', encoding='utf-8') as f:
    content = f.read()

if "import 'dart:convert';" not in content:
    content = "import 'dart:convert';\n" + content

# Replace main function
new_main = """
void main(List<String> args) async {
  if (args.isEmpty) {
    printUsage();
    exit(1);
  }

  final command = args[0];

  switch (command) {
    case 'init':
      await initProject();
      break;
    case 'r':
      if (args.length < 2) return _missingArgs('r <role>');
      createRole(args[1]);
      break;
    case 'p':
      if (args.length < 2) return _missingArgs('p <page>');
      createPage(args[1]);
      break;
    case 'c':
      if (args.length < 3) return _missingArgs('c <name> <folder>');
      createController(args[1], args[2]);
      break;
    case 'v':
      if (args.length < 3) return _missingArgs('v <name> <folder>');
      createView(args[1], args[2]);
      break;
    case 'pr':
      if (args.length < 3) return _missingArgs('pr <name> <folder>');
      createProvider(args[1], args[2]);
      break;
    case 'l':
      if (args.length < 2) return _missingArgs('l <assets/locales>');
      generateLocales(args[1]);
      break;
    case 'm':
      if (args.length < 3) return _missingArgs('m <folder> <jsonPath>');
      generateModel(args[1], args[2]);
      break;
    case 'generate':
    case 'g':
      if (args.length < 3) return _missingArgs('generate <role> <feature_name>');
      scaffoldFeature(args[1], args[2]);
      break;
    default:
      print("[ERROR] Unknown command: $command");
      printUsage();
      exit(1);
  }
}

void _missingArgs(String usage) {
  print("[ERROR] Missing arguments.");
  print("Usage: dart scripts/config.dart $usage");
  exit(1);
}

void printUsage() {
  print('''
🚀 Flutter Boilerplate CLI (config.dart)

Available Commands:
  init                           Initialize project
  r <role>                       Create role folder
  p <page>                       Create page (feature)
  c <name> <folder>              Create controller in a specific folder
  v <name> <folder>              Create view in a specific folder
  pr <name> <folder>             Create provider in a specific folder
  l <assets/locales>             Generate locales from JSON
  m <folder> <jsonPath>          Generate model from JSON

Examples:
  dart scripts/config.dart r coach
  dart scripts/config.dart p home
  dart scripts/config.dart c dialog home
  dart scripts/config.dart v dialog home
  dart scripts/config.dart pr user home
  dart scripts/config.dart l assets/locales/en.json
  dart scripts/config.dart m home assets/models/user.json
''');
}

"""

# Regex substitute main
content = re.sub(r'void main\(List<String> args\) async \{.*?// ==========================================', new_main + '// ==========================================', content, flags=re.DOTALL)

# Now we append the new logic functions at the end of the file.
new_functions = """
// ==========================================
// CLI COMMAND HANDLERS
// ==========================================

String? findFolder(String folderName) {
  final featuresDir = Directory('${Directory.current.path}/lib/features');
  if (!featuresDir.existsSync()) return null;

  String? foundPath;
  void search(Directory dir) {
    if (foundPath != null) return;
    for (var entity in dir.listSync(followLinks: false)) {
      if (entity is Directory) {
        if (entity.path.split(Platform.pathSeparator).last == folderName || 
            entity.path.split('/').last == folderName) {
          foundPath = entity.path;
          return;
        }
        search(entity);
      }
    }
  }
  
  search(featuresDir);
  return foundPath;
}

void createRole(String role) {
  final path = '${Directory.current.path}/lib/features/$role';
  Directory(path).createSync(recursive: true);
  print('✅ Created role folder at: lib/features/$role');
}

void createPage(String page) {
  final path = '${Directory.current.path}/lib/features/$page';
  Directory('$path/views').createSync(recursive: true);
  Directory('$path/controllers').createSync(recursive: true);
  Directory('$path/models').createSync(recursive: true);
  Directory('$path/widgets').createSync(recursive: true);
  
  createController(page, page, forcePath: '$path/controllers');
  createView(page, page, forcePath: '$path/views');
  
  print('✅ Created page structure at: lib/features/$page');
}

void createController(String name, String folder, {String? forcePath}) {
  final targetPath = forcePath ?? findFolder(folder);
  if (targetPath == null) {
    print('❌ Could not find folder "$folder" in lib/features/');
    return;
  }
  
  final controllersPath = forcePath != null ? forcePath : '$targetPath/controllers';
  Directory(controllersPath).createSync(recursive: true);
  
  final camelName = toCamelCase(name);
  final pascalName = toPascalCase(name);
  
  final file = File('$controllersPath/${name}_controller.dart');
  if (!file.existsSync()) {
    file.writeAsStringSync('''import 'package:flutter/material.dart';

class ${pascalName}Controller with ChangeNotifier {
  // Add state variables here
  
  void init() {
    // Initialization logic
  }
}
''');
    print('✅ Created ${name}_controller.dart in $controllersPath');
  } else {
    print('⚠️ Controller already exists at $controllersPath');
  }
}

void createView(String name, String folder, {String? forcePath}) {
  final targetPath = forcePath ?? findFolder(folder);
  if (targetPath == null) {
    print('❌ Could not find folder "$folder" in lib/features/');
    return;
  }
  
  final viewsPath = forcePath != null ? forcePath : '$targetPath/views';
  Directory(viewsPath).createSync(recursive: true);
  
  final pascalName = toPascalCase(name);
  
  final file = File('$viewsPath/${name}_view.dart');
  if (!file.existsSync()) {
    file.writeAsStringSync('''import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ${pascalName}View extends StatelessWidget {
  const ${pascalName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('${pascalName}View')),
      body: const Center(child: Text('${pascalName}View is working!')),
    );
  }
}
''');
    print('✅ Created ${name}_view.dart in $viewsPath');
  } else {
    print('⚠️ View already exists at $viewsPath');
  }
}

void createProvider(String name, String folder) {
  final targetPath = findFolder(folder);
  if (targetPath == null) {
    print('❌ Could not find folder "$folder" in lib/features/');
    return;
  }
  
  final providerPath = '$targetPath/providers';
  Directory(providerPath).createSync(recursive: true);
  
  final pascalName = toPascalCase(name);
  
  final file = File('$providerPath/${name}_provider.dart');
  if (!file.existsSync()) {
    file.writeAsStringSync('''import 'package:flutter/material.dart';

class ${pascalName}Provider with ChangeNotifier {
  // Add logic here
}
''');
    print('✅ Created ${name}_provider.dart in $providerPath');
  } else {
    print('⚠️ Provider already exists at $providerPath');
  }
}

void generateLocales(String jsonPath) {
  final file = File('${Directory.current.path}/$jsonPath');
  if (!file.existsSync()) {
    print('❌ Cannot find locale file at $jsonPath');
    return;
  }
  
  try {
    final content = file.readAsStringSync();
    final Map<String, dynamic> jsonMap = jsonDecode(content);
    
    final langDir = Directory('${Directory.current.path}/lib/core/languages');
    langDir.createSync(recursive: true);
    
    final dartFile = File('${langDir.path}/generated_locales.dart');
    
    StringBuffer keys = StringBuffer();
    jsonMap.forEach((key, value) {
       // Escape quotes in value
       final escapedValue = value.toString().replaceAll("'", "\\'");
       keys.writeln("      '$key': '$escapedValue',");
    });
    
    dartFile.writeAsStringSync('''class GeneratedLocales {
  static const Map<String, String> keys = {
${keys.toString()}  };
}
''');
    print('✅ Generated Locales from $jsonPath into lib/core/languages/generated_locales.dart');
  } catch (e) {
    print('❌ Error parsing JSON: $e');
  }
}

void generateModel(String folder, String jsonPath) {
  final targetPath = findFolder(folder);
  if (targetPath == null) {
    print('❌ Could not find folder "$folder" in lib/features/');
    return;
  }
  
  final jsonFile = File('${Directory.current.path}/$jsonPath');
  if (!jsonFile.existsSync()) {
    print('❌ Cannot find json file at $jsonPath');
    return;
  }
  
  final modelsPath = '$targetPath/models';
  Directory(modelsPath).createSync(recursive: true);
  
  // Example path: assets/models/user.json -> user
  final name = jsonPath.split('/').last.split('.').first;
  final pascalName = toPascalCase(name);
  
  try {
    final content = jsonFile.readAsStringSync();
    final Map<String, dynamic> jsonMap = jsonDecode(content);
    
    StringBuffer fields = StringBuffer();
    StringBuffer constructor = StringBuffer();
    StringBuffer fromJson = StringBuffer();
    StringBuffer toJson = StringBuffer();
    
    jsonMap.forEach((key, value) {
      String type = 'dynamic';
      if (value is String) type = 'String';
      else if (value is int) type = 'int';
      else if (value is double) type = 'double';
      else if (value is bool) type = 'bool';
      else if (value is List) type = 'List<dynamic>';
      else if (value is Map) type = 'Map<String, dynamic>';
      
      fields.writeln('  final $type? $key;');
      constructor.writeln('    this.$key,');
      
      if (type == 'double' && value is int) {
         fromJson.writeln("      $key: (json['$key'] as num?)?.toDouble(),");
      } else {
         fromJson.writeln("      $key: json['$key'] as $type?,");
      }
      toJson.writeln("      '$key': this.$key,");
    });
    
    final file = File('$modelsPath/${name}_model.dart');
    file.writeAsStringSync('''class ${pascalName}Model {
${fields.toString()}

  ${pascalName}Model({
${constructor.toString()}  });

  factory ${pascalName}Model.fromJson(Map<String, dynamic> json) {
    return ${pascalName}Model(
${fromJson.toString()}    );
  }

  Map<String, dynamic> toJson() {
    return {
${toJson.toString()}    };
  }
}
''');
    print('✅ Created ${name}_model.dart in $modelsPath');
  } catch (e) {
    print('❌ Error generating model: $e');
  }
}
"""

with open(config_file, 'w', encoding='utf-8') as f:
    f.write(content + '\n' + new_functions)

print("Success!")
