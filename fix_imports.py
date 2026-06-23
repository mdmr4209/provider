import os

files_to_fix = {
    r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\core\widgets\full_screen_image_viewer.dart': "import '../constants/app_colors.dart';",
    r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\core\widgets\custom_input.dart': "import '../constants/app_colors.dart';",
    r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\core\theme\design_system.dart': "import '../constants/app_colors.dart';"
}

for path, replacement in files_to_fix.items():
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        content = content.replace("import 'package:newproject/core/constants/app_colors.dart';", replacement)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {path}")
    else:
        print(f"File not found: {path}")
