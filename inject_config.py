import os

core_dir = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\core'
config_file = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scripts\config.dart'

out_code = '  final corePath = Directory(\'${libPath.path}/core\');\n'

for root, _, files in os.walk(core_dir):
    for f in files:
        if f.endswith('.dart'):
            path = os.path.join(root, f)
            rel_path = os.path.relpath(path, core_dir).replace('\\', '/')
            with open(path, 'r', encoding='utf-8') as file:
                content = file.read()
            
            content = content.replace('\"\"\"', "'''")
            
            out_code += f"""
  File('${{corePath.path}}/{rel_path}')
    ..createSync(recursive: true)
    ..writeAsStringSync(r\"\"\"{content}\"\"\");
"""

clean_config_path = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\test_config_project\scripts\config.dart'
if os.path.exists(clean_config_path):
    with open(clean_config_path, 'r', encoding='utf-8') as f:
        clean_content = f.read()

# ADD MATERIAL.DART IMPORTS TO TEMPLATES
clean_content = clean_content.replace(
    "import 'package:go_router/go_router.dart';", 
    "import 'package:flutter/material.dart';\nimport 'package:go_router/go_router.dart';"
)

clean_content = clean_content.replace(
    "import 'package:flutter_screenutil/flutter_screenutil.dart';", 
    "import 'package:flutter/material.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';"
)


start_marker = 'print("📂 Creating core directories...");'
end_marker = 'print("🛣️ Creating app_router.dart...");'

before = clean_content.split(start_marker)[0]
after = clean_content.split(end_marker)[1]

pubspec_logic = """
  print("📦 Updating pubspec.yaml with dependencies...");
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    List<String> lines = pubspecFile.readAsLinesSync();
    
    // Helper to add dependency
    void addDep(String name, String version, bool isDev) {
      String target = isDev ? 'dev_dependencies:' : 'dependencies:';
      int idx = lines.indexWhere((line) => line.trim() == target);
      if (idx != -1) {
        if (!lines.any((line) => line.trim().startsWith(name + ':'))) {
          lines.insert(idx + 1, '  $name: $version');
        }
      }
    }

    // Core UI/State
    addDep('provider', '^6.1.1', false);
    addDep('go_router', '^13.2.0', false);
    addDep('flutter_screenutil', '^5.9.0', false);
    addDep('flutter_svg', '^2.0.10', false);
    addDep('cupertino_icons', '^1.0.6', false);
    addDep('pin_code_fields', '^8.0.1', false);
    
    // Networking
    addDep('dio', '^5.4.0', false);
    addDep('http', '^1.2.0', false);
    addDep('http_parser', '^4.0.2', false);
    
    // Storage / Cache / Pickers
    addDep('flutter_secure_storage', '^9.0.0', false);
    addDep('shared_preferences', '^2.2.2', false);
    addDep('file_picker', '^6.1.1', false);
    addDep('image_picker', '^1.0.7', false);
    addDep('cached_network_image', '^3.3.1', false);
    
    // Utils
    addDep('intl', '^0.19.0', false);
    addDep('permission_handler', '^11.3.0', false);
    
    // Firebase / Auth
    addDep('firebase_core', '^4.0.0', false);
    addDep('firebase_auth', '6.0.1', false);
    addDep('google_sign_in', '^6.2.1', false);
    addDep('flutter_facebook_auth', '^7.1.2', false);

    // Dev Dependencies
    addDep('flutter_native_splash', '^2.4.0', true);
    addDep('rename', '^3.0.2', true);

    pubspecFile.writeAsStringSync(lines.join('\\n'));
    print("✅ pubspec.yaml updated! Please remember to run: flutter pub get");
  }
"""

before = before.replace('print("📦 Please remember to run: flutter pub add provider go_router flutter_screenutil");', pubspec_logic)

new_content = before + start_marker + '\n' + out_code + '\n  ' + end_marker + after

with open(config_file, 'w', encoding='utf-8') as f:
    f.write(new_content)
print("Success!")
