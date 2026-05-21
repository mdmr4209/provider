import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../localization/localization_extension.dart';

import '../controllers/home_controller.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  // ── Filter States ──────────────────────────────────────────────────────
  late String _selectedSort;
  late Set<String> _selectedColors;
  late RangeValues _priceRange;
  late Set<String> _selectedConditions;
  late Set<String> _selectedGenders;
  late Set<String> _selectedTags;

  // ── Sort Options ───────────────────────────────────────────────────────
  List<String> sortOptions(BuildContext context) => [
    context.watchTr(
      'luxury_fashion',
    ), // Replace with actual sort keys if available
    'From expensive to cheap',
    'From cheap to expensive',
    'Newest',
    'Most Popular',
  ];

  // ── Color Options ──────────────────────────────────────────────────────
  final List<String> colorOptions = [
    '#F5E6E1',
    '#E8D4CC',
    '#D4A5A0', // Selected in design
    '#D9A89F',
    '#E59E8F',
    '#E08A7C',
  ];

  // ── Condition Options ──────────────────────────────────────────────────
  final List<Map<String, dynamic>> conditions = [
    {'label': 'SALE', 'color': Color(0xFFA3D2A2), 'key': 'sale'},
    {'label': 'NEW', 'color': Color(0xFFE8B4D6), 'key': 'new'},
  ];

  // ── Gender Options ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> genders = [
    {'label': 'MAN', 'color': Color(0xFFA3D2A2), 'key': 'man'},
    {'label': 'WOMAN', 'color': Color(0xFFE8B4D6), 'key': 'woman'},
  ];

  // ── Tag Options ────────────────────────────────────────────────────────
  final List<String> tags = [
    'Nails',
    'Face',
    'Hair',
    'Make up',
    'Eye-brows',
    'Skin',
    'Lips',
    'Lashes',
    'Body',
    'Mask',
    'Oil',
    'Scrab',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with default values
    _selectedSort = 'Newest';
    _selectedColors = {'#D4A5A0'};
    _priceRange = const RangeValues(30, 130);
    _selectedConditions = {'sale'};
    _selectedGenders = {};
    _selectedTags = {'skin'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Main Content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Sort Dropdown ─────────────────────────────────
                    _buildSortDropdown(),
                    SizedBox(height: 32.h),

                    // ── Color Section ─────────────────────────────────
                    _buildColorSection(),
                    SizedBox(height: 32.h),

                    // ── Price Range Section ───────────────────────────
                    _buildPriceSection(),
                    SizedBox(height: 32.h),

                    // ── Conditions Section ────────────────────────────
                    _buildConditionsSection(),
                    SizedBox(height: 32.h),

                    // ── Gender Section ────────────────────────────────
                    _buildGenderSection(),
                    SizedBox(height: 32.h),

                    // ── Tags Section ──────────────────────────────────
                    _buildTagsSection(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),

          // ── Apply Filters Button ───────────────────────────────────
          Padding(padding: EdgeInsets.all(16.w), child: _buildApplyButton()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        context.watchTr('filter'),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8.r),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: DropdownButton<String>(
          value: _selectedSort,
          isExpanded: true,
          underline: const SizedBox(),
          icon: Icon(Icons.expand_more, size: 24.sp),
          items: sortOptions(context).map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedSort = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watchTr('color'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: colorOptions.map((color) {
            final isSelected = _selectedColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColors.clear();
                  _selectedColors.add(color);
                });
              },
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                  borderRadius: BorderRadius.circular(4.r),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.5.w,
                        )
                      : Border.all(color: Colors.transparent, width: 2.5.w),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watchTr('price'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 20.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 200,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).disabledColor.withAlpha(50),
          onChanged: (RangeValues values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.toInt()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${_priceRange.end.toInt()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConditionsSection() {
    return Row(
      children: conditions.map((condition) {
        final isSelected = _selectedConditions.contains(condition['key']);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedConditions.remove(condition['key']);
                  } else {
                    _selectedConditions.add(condition['key']);
                  }
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedConditions.add(condition['key']);
                          } else {
                            _selectedConditions.remove(condition['key']);
                          }
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: condition['color'],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      condition['label'],
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderSection() {
    return Row(
      children: genders.map((gender) {
        final isSelected = _selectedGenders.contains(gender['key']);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedGenders.remove(gender['key']);
                  } else {
                    _selectedGenders.add(gender['key']);
                  }
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedGenders.add(gender['key']);
                          } else {
                            _selectedGenders.remove(gender['key']);
                          }
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: gender['color'],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      gender['label'],
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watchTr('tags'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: tags.map((tag) {
            final isSelected = _selectedTags.contains(tag.toLowerCase());
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag.toLowerCase());
                  } else {
                    _selectedTags.add(tag.toLowerCase());
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.w,
                        )
                      : Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1.w,
                        ),
                  borderRadius: BorderRadius.circular(8.r),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withAlpha(20)
                      : Theme.of(context).colorScheme.surface,
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return GestureDetector(
      onTap: () {
        // ✅ Apply filters and update provider
        debugPrint('=== FILTERS APPLIED ===');
        debugPrint('Sort: $_selectedSort');
        debugPrint('Colors: $_selectedColors');
        debugPrint(
          'Price: \$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
        );
        debugPrint('Conditions: $_selectedConditions');
        debugPrint('Genders: $_selectedGenders');
        debugPrint('Tags: $_selectedTags');

        // Update controller
        final homeController = context.read<HomeController>();
        homeController.setSortOption(_selectedSort);
        homeController.setColors(_selectedColors);
        homeController.setPriceRange(_priceRange);
        homeController.setConditions(_selectedConditions);
        homeController.setGenders(_selectedGenders);
        homeController.setTags(_selectedTags);

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withAlpha(200),
            ],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            context.watchTr('apply_filters'),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
