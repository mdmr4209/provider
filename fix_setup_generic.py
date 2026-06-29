import os
import re

config_file = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scripts\config.dart'

with open(config_file, 'r', encoding='utf-8') as f:
    content = f.read()

# We need to replace the big block of setup generation that was injected before.
# Let's find the start of the `if (wantSetup) {` block inside the injected auth flow logic.

start_marker = '  if (wantSetup) {'
end_marker = '  print("✅ Boilerplate initialized successfully!");'

# The structure is:
# if (wantSetup) {
#   print("📂 Creating setup... (Before Auth: $setupBeforeAuth)");
#   final setupDir = Directory('$featuresBase/auth/views/setup');
#   setupDir.createSync(recursive: true);
#   String content_coach_setup_views = ...
#   ...
# }
# print("✅ Boilerplate initialized successfully!");

if start_marker in content and end_marker in content:
    parts = content.split(start_marker, 1)
    before_setup = parts[0]
    
    # We find the end of the wantSetup block, which is just before the end_marker
    parts_end = parts[1].split(end_marker, 1)
    
    # The new setup logic
    new_setup_logic = """  if (wantSetup) {
    print("📂 Creating generic setup view... (Before Auth: $setupBeforeAuth)");
    final setupDir = Directory('$featuresBase/auth/views/setup');
    setupDir.createSync(recursive: true);

    String genericSetupContent = r'''import 'package:flutter/material.dart';

class SetupView extends StatelessWidget {
  const SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Your Generic Setup is Ready!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen based on setupBeforeAuth logic
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
''';

    File('${setupDir.path}/setup_view.dart')
      ..createSync(recursive: true)
      ..writeAsStringSync(genericSetupContent);
  }

"""
    
    new_content = before_setup + new_setup_logic + "  " + end_marker + parts_end[1]
    
    with open(config_file, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print("Replaced setup logic successfully!")
else:
    print("Markers not found in config.dart")
