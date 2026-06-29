import os

config_file = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scripts\config.dart'

files_to_inject = [
    (r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\localization\controllers\localization_controller.dart', 'core/localization/controllers/localization_controller.dart'),
    (r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\localization\localization_extension.dart', 'core/localization/localization_extension.dart'),
    (r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\languages\languages.dart', 'core/languages/languages.dart')
]

out_code = "  print(\"Other's language support?\\n1. localization\\n2. not\");\n"
out_code += "  stdout.write(\"Enter choice (1/2): \");\n"
out_code += "  final langChoice = stdin.readLineSync();\n"
out_code += "  if (langChoice == '1') {\n"
out_code += "    print(\"📂 Creating localization directories...\");\n"

for src, target in files_to_inject:
    with open(src, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix import paths
    if 'localization_controller.dart' in target:
        content = content.replace("import '../../languages/languages.dart';", "import '../../languages/languages.dart';")
    if 'localization_extension.dart' in target:
        pass # The import 'controllers/localization_controller.dart'; is relative and still correct

    content = content.replace('\"\"\"', "'''")
    
    out_code += f"""
    File('${{libPath.path}}/{target}')
      ..createSync(recursive: true)
      ..writeAsStringSync(r\"\"\"{content}\"\"\");
"""

out_code += "    print(\"✅ Localization files created.\");\n  }\n"

with open(config_file, 'r', encoding='utf-8') as f:
    config_content = f.read()

# We need to inject this right before `print("🛣️ Creating app_router.dart...");`
target_marker = 'print("🛣️ Creating app_router.dart...");'

if target_marker in config_content:
    parts = config_content.split(target_marker)
    # We put out_code before the target marker
    new_content = parts[0] + out_code + '  ' + target_marker + parts[1]
    
    # Also we need to make sure dart:io is imported, it should be at the top.
    if 'import \'dart:io\';' not in new_content:
        new_content = "import 'dart:io';\n" + new_content
        
    with open(config_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Success!")
else:
    print("Marker not found!")
