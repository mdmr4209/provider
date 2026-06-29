import os

config_file = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scripts\config.dart'

auth_dir = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\auth\views'
onboard_dir = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\onboarding\views'
setup_dir = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\features\shared\auth\views\setup'

auth_files = [
    'auth_view.dart', 'change_password_view.dart', 'forget_password_view.dart', 
    'otp_verify_view.dart', 'sign_up_view.dart', 'splash_screen.dart'
]

def read_and_escape(path):
    if not os.path.exists(path): return ""
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    return content.replace('\"\"\"', "'''")

dart_code = """
  print("Do have multiple role [1/2]?");
  print("1. Yes");
  print("2. No");
  stdout.write("Enter choice: ");
  final roleChoice = stdin.readLineSync();
  final isMultiRole = roleChoice == '1';
  final featuresBase = isMultiRole ? '${libPath.path}/features/shared' : '${libPath.path}/features';
  final corePrefix = isMultiRole ? '../../../../core/' : '../../../core/';
  final sharedPrefix = isMultiRole ? '../../' : '../';

  print("Do you want onboarding [1/2]?");
  print("1. Yes");
  print("2. No");
  stdout.write("Enter choice: ");
  final onbChoice = stdin.readLineSync();
  final wantOnboarding = onbChoice == '1';

  print("Do you want setup [1/2]?");
  print("1. Yes");
  print("2. No");
  stdout.write("Enter choice: ");
  final setupChoice = stdin.readLineSync();
  final wantSetup = setupChoice == '1';
  
  bool setupBeforeAuth = false;
  if (wantSetup) {
    print("Before authentication or after [1/2]?");
    print("1. Before");
    print("2. After");
    stdout.write("Enter choice: ");
    final setupPosChoice = stdin.readLineSync();
    setupBeforeAuth = setupPosChoice == '1';
  }
  
  // Create features folder
  Directory(featuresBase).createSync(recursive: true);
"""

# Auth folder
dart_code += "  final authPath = Directory('$featuresBase/auth/views');\n"
dart_code += "  authPath.createSync(recursive: true);\n"

for af in auth_files:
    content = read_and_escape(os.path.join(auth_dir, af))
    dart_code += f"""
  String content_{af.replace('.dart','')} = r\"\"\"{content}\"\"\";
  content_{af.replace('.dart','')} = content_{af.replace('.dart','')}.replaceAll('../../../../core/', corePrefix);
  content_{af.replace('.dart','')} = content_{af.replace('.dart','')}.replaceAll('../../localization/', '${{sharedPrefix}}localization/');
  
  File('${{authPath.path}}/{af}')
    ..createSync(recursive: true)
    ..writeAsStringSync(content_{af.replace('.dart','')});
"""

# Handle onboarding
dart_code += """
  if (wantOnboarding) {
    print("📂 Creating onboarding...");
    final onbPath = Directory('$featuresBase/onboarding/views');
    onbPath.createSync(recursive: true);
"""
if os.path.exists(onboard_dir):
    for of in os.listdir(onboard_dir):
        if of.endswith('.dart'):
            content = read_and_escape(os.path.join(onboard_dir, of))
            dart_code += f"""
    String content_{of.replace('.dart','')} = r\"\"\"{content}\"\"\";
    content_{of.replace('.dart','')} = content_{of.replace('.dart','')}.replaceAll('../../../../core/', corePrefix);
    content_{of.replace('.dart','')} = content_{of.replace('.dart','')}.replaceAll('../../localization/', '${{sharedPrefix}}localization/');
    File('${{onbPath.path}}/{of}').writeAsStringSync(content_{of.replace('.dart','')});
"""
dart_code += "  }\n"

# Handle setup
dart_code += """
  if (wantSetup) {
    print("📂 Creating setup... (Before Auth: $setupBeforeAuth)");
    final setupDir = Directory('$featuresBase/auth/views/setup');
    setupDir.createSync(recursive: true);
"""
if os.path.exists(setup_dir):
    for root, _, files in os.walk(setup_dir):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                rel_path = os.path.relpath(path, setup_dir).replace('\\', '/')
                content = read_and_escape(path)
                safe_name = f.replace('.dart', '').replace('-', '_')
                dart_code += f"""
    String content_{safe_name} = r\"\"\"{content}\"\"\";
    content_{safe_name} = content_{safe_name}.replaceAll('../../../../../core/', isMultiRole ? '../../../../../core/' : '../../../../core/');
    content_{safe_name} = content_{safe_name}.replaceAll('../../../../core/', corePrefix);
    content_{safe_name} = content_{safe_name}.replaceAll('../../../localization/', isMultiRole ? '../../../localization/' : '../../localization/');
    File('${{setupDir.path}}/{rel_path}')
      ..createSync(recursive: true)
      ..writeAsStringSync(content_{safe_name});
"""
dart_code += "  }\n"

with open(config_file, 'r', encoding='utf-8') as f:
    config_content = f.read()

target_marker = 'print("✅ Boilerplate initialized successfully!");'

if target_marker in config_content:
    parts = config_content.split(target_marker)
    new_content = parts[0] + dart_code + '  ' + target_marker + parts[1]
    
    with open(config_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Success!")
else:
    print("Marker not found!")
