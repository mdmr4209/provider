import os

core_dir = r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\lib\core'
out_code = ''

for root, _, files in os.walk(core_dir):
    for f in files:
        if f.endswith('.dart'):
            path = os.path.join(root, f)
            rel_path = os.path.relpath(path, core_dir).replace('\\', '/')
            with open(path, 'r', encoding='utf-8') as file:
                content = file.read()
                
            content = content.replace('$', '\\$').replace("'''", "\\'\\'\\'")
            
            out_code += f"""
  File('\\${{corePath.path}}/{rel_path}')
    ..createSync(recursive: true)
    ..writeAsStringSync('''
{content}
''');
"""

with open(r'c:\Users\mahbu\OneDrive\Desktop\Codes\project\provider\scratch_core_gen.txt', 'w', encoding='utf-8') as file:
    file.write(out_code)
