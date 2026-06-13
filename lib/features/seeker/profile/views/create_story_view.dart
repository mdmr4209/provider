import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class StoryCreatorController extends ChangeNotifier {
  File? pickedImage;
  String text = "Double tap to edit text";
  double textX = 50.0;
  double textY = 250.0;
  Color textColor = Colors.white;
  double fontSize = 24.0;

  // Background transformation state
  double imageScale = 1.0;
  double imageRotation = 0.0;
  double imageX = 0.0;
  double imageY = 0.0;

  double _baseImageScale = 1.0;
  double _baseImageRotation = 0.0;

  // Text transformation state
  double textScale = 1.0;
  double textRotation = 0.0;

  double _baseTextScale = 1.0;
  double _baseTextRotation = 0.0;

  // Canvas background customization
  Color canvasColor = const Color(0xFF1B2B1B);
  final List<Color> canvasColors = [
    const Color(0xFF1B2B1B), // Default dark green
    const Color(0xFF2E1B1B), // Dark red
    const Color(0xFF1B222B), // Dark blue
    const Color(0xFF2B291B), // Dark gold/yellow
    const Color(0xFF2B1B2A), // Dark purple
    Colors.black,
    const Color(0xFF112E11), // Forest green
    const Color(0xFF152A38), // Dark slate
  ];

  final picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage = File(image.path);
        // Reset image transform on new pick
        imageScale = 1.0;
        imageRotation = 0.0;
        imageX = 0.0;
        imageY = 0.0;
        notifyListeners();
      }
    } catch (e) {
      // Permission denied or operation cancelled
    }
  }

  void updateText(String newText) {
    text = newText;
    notifyListeners();
  }

  bool isTextActive = true;

  void toggleTextActive(bool active) {
    isTextActive = active;
    notifyListeners();
  }

  void onScaleStart(ScaleStartDetails details) {
    if (isTextActive) {
      _baseTextScale = textScale;
      _baseTextRotation = textRotation;
    } else {
      _baseImageScale = imageScale;
      _baseImageRotation = imageRotation;
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details, double maxW, double maxH) {
    if (isTextActive) {
      textScale = (_baseTextScale * details.scale).clamp(0.5, 4.0);
      textRotation = _baseTextRotation + details.rotation;
      textX = (textX + details.focalPointDelta.dx).clamp(-150.w, maxW);
      textY = (textY + details.focalPointDelta.dy).clamp(-150.h, maxH);
    } else {
      imageScale = (_baseImageScale * details.scale).clamp(0.5, 4.0);
      imageRotation = _baseImageRotation + details.rotation;
      imageX += details.focalPointDelta.dx;
      imageY += details.focalPointDelta.dy;
    }
    notifyListeners();
  }

  void resetTransforms() {
    imageScale = 1.0;
    imageRotation = 0.0;
    imageX = 0.0;
    imageY = 0.0;
    textScale = 1.0;
    textRotation = 0.0;
    textX = 50.0;
    textY = 250.0;
    notifyListeners();
  }

  void updateColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  void updateCanvasColor(Color color) {
    canvasColor = color;
    notifyListeners();
  }

  void updateFontSize(double size) {
    fontSize = size.clamp(14.0, 48.0);
    notifyListeners();
  }

  void showTextInputDialog(BuildContext context) {
    final textController = TextEditingController(text: text);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF20341F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Story Text",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type something...",
                    hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: TextStyle(color: Colors.white.withAlpha(128))),
                    ),
                    SizedBox(width: 12.w),
                    CustomButton(
                      onPress: () async {
                        updateText(textController.text.isNotEmpty ? textController.text : "Your Story");
                        Navigator.pop(context);
                      },
                      title: "Add",
                      width: 80,
                      height: 36,
                      linearGradient: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SpectrumColorPicker extends StatelessWidget {
  final Function(Color) onColorSelected;
  final Color selectedColor;

  const SpectrumColorPicker({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
    ];

    return GestureDetector(
      onTapDown: (details) => _selectColor(details.localPosition.dx, context),
      onHorizontalDragUpdate: (details) => _selectColor(details.localPosition.dx, context),
      child: Container(
        height: 16.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: LinearGradient(colors: colors),
          border: Border.all(color: Colors.white.withAlpha(51), width: 1),
        ),
      ),
    );
  }

  void _selectColor(double dx, BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final double width = box.size.width;
    final double percent = (dx / width).clamp(0.0, 1.0);

    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.red,
    ];

    final double scaledPercent = percent * (colors.length - 1);
    final int index = scaledPercent.floor();
    final double remainder = scaledPercent - index;

    Color color;
    if (index >= colors.length - 1) {
      color = colors.last;
    } else {
      color = Color.lerp(colors[index], colors[index + 1], remainder) ?? colors[index];
    }
    onColorSelected(color);
  }
}

class CreateStoryView extends StatelessWidget {
  const CreateStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryCreatorController>(
      create: (_) => StoryCreatorController(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B2B1B),
        body: SafeArea(
          child: Consumer<StoryCreatorController>(
            builder: (context, controller, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final maxH = constraints.maxHeight;

                  return GestureDetector(
                    onTap: () => controller.toggleTextActive(false),
                    onScaleStart: (details) => controller.onScaleStart(details),
                    onScaleUpdate: (details) => controller.onScaleUpdate(details, maxW, maxH),
                    child: Stack(
                      children: [
                        // ── Draggable/Scaleable/Rotatable Background Canvas ────────────
                        Positioned.fill(
                          child: ClipRect(
                            child: Transform.translate(
                              offset: Offset(controller.imageX, controller.imageY),
                              child: Transform.rotate(
                                angle: controller.imageRotation,
                                child: Transform.scale(
                                  scale: controller.imageScale,
                                  alignment: Alignment.center,
                                  child: controller.pickedImage != null
                                      ? Image.file(
                                          controller.pickedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [controller.canvasColor, controller.canvasColor.withAlpha(150)],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ── Draggable/Scaleable/Rotatable Text Overlay ─────────────────
                        Positioned(
                          left: controller.textX,
                          top: controller.textY,
                          child: GestureDetector(
                            onTap: () => controller.toggleTextActive(true),
                            onDoubleTap: () => controller.showTextInputDialog(context),
                            child: Transform.translate(
                              offset: Offset(0, 0), // Text doesn't use translate since it's wrapped in Positioned
                              child: Transform.rotate(
                                angle: controller.textRotation,
                                child: Transform.scale(
                                  scale: controller.textScale,
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(102),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: controller.isTextActive 
                                          ? Border.all(color: AppColors.secondaryColorLight, width: 2.r)
                                          : null,
                                    ),
                                    child: Text(
                                      controller.text,
                                      style: TextStyle(
                                        color: controller.textColor,
                                        fontSize: controller.fontSize.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // ── Header / Close Button ───────────────────────────────────────
                      Positioned(
                        top: 20.h,
                        left: 20.w,
                        right: 20.w,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mike Tyson",
                                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Create Story",
                                  style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      // ── Floating Sidebar Controls ───────────────────────────────────
                      Positioned(
                        right: 20.w,
                        top: 100.h,
                        child: Column(
                          children: [
                            _buildSidebarButton(
                              icon: Icons.text_fields,
                              label: "Text",
                              onTap: () => controller.showTextInputDialog(context),
                            ),
                            SizedBox(height: 16.h),
                            _buildSidebarButton(
                              icon: Icons.photo_library_outlined,
                              label: "Upload",
                              onTap: controller.pickImage,
                            ),
                            SizedBox(height: 16.h),
                            _buildSidebarButton(
                              icon: Icons.refresh,
                              label: "Reset",
                              onTap: controller.resetTransforms,
                            ),
                          ],
                        ),
                      ),

                      // ── Bottom Customization and Share Panel ─────────────────────────
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withAlpha(229)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text Size Adjustment
                              Row(
                                children: [
                                  Icon(Icons.format_size, color: Colors.white70, size: 20.r),
                                  Expanded(
                                    child: Slider(
                                      value: controller.fontSize,
                                      min: 14.0,
                                      max: 48.0,
                                      activeColor: AppColors.secondaryColorLight,
                                      inactiveColor: Colors.white24,
                                      onChanged: (val) => controller.updateFontSize(val),
                                    ),
                                  ),
                                  Text(
                                    "${controller.fontSize.round()}px",
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),

                              // Text Color Picker Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Text Color Palette", style: TextStyle(color: Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                                  Container(
                                    width: 14.r,
                                    height: 14.r,
                                    decoration: BoxDecoration(color: controller.textColor, shape: BoxShape.circle),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [Colors.white, Colors.black, Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.purple, Colors.pink]
                                      .map((c) => GestureDetector(
                                            onTap: () => controller.updateColor(c),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 8.w),
                                              width: 24.r,
                                              height: 24.r,
                                              decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white38)),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SpectrumColorPicker(
                                selectedColor: controller.textColor,
                                onColorSelected: (color) => controller.updateColor(color),
                              ),

                              if (controller.pickedImage == null) ...[
                                SizedBox(height: 16.h),
                                // Canvas Background Color Picker Header
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Background Color Palette", style: TextStyle(color: Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                                    Container(
                                      width: 14.r,
                                      height: 14.r,
                                      decoration: BoxDecoration(color: controller.canvasColor, shape: BoxShape.circle),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: controller.canvasColors
                                        .map((c) => GestureDetector(
                                              onTap: () => controller.updateCanvasColor(c),
                                              child: Container(
                                                margin: EdgeInsets.only(right: 8.w),
                                                width: 24.r,
                                                height: 24.r,
                                                decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white38)),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                SpectrumColorPicker(
                                  selectedColor: controller.canvasColor,
                                  onColorSelected: (color) => controller.updateCanvasColor(color),
                                ),
                              ],
                              SizedBox(height: 20.h),

                              // Share Button
                              CustomButton(
                                onPress: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Story shared successfully!")),
                                  );
                                  Navigator.pop(context);
                                },
                                title: "Share to Story",
                                linearGradient: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(51)),
            ),
            child: Icon(icon, color: Colors.white, size: 22.r),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
