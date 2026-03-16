import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../providers/home_provider.dart';

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
  final List<String> sortOptions = [
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
    _selectedSort = 'From expensive to cheap';
    _selectedColors = {'#D4A5A0'};
    _priceRange = const RangeValues(30, 130);
    _selectedConditions = {'sale'};
    _selectedGenders = {};
    _selectedTags = {'skin'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
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
      backgroundColor: AppColor.whiteColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Filter',
        style: GoogleFonts.tenorSans(
          color: AppColor.textColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8.r),
        color: const Color(0xFFFAFAFA),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: DropdownButton<String>(
          value: _selectedSort,
          isExpanded: true,
          underline: const SizedBox(),
          icon: Icon(Icons.expand_more, size: 24.sp),
          items: sortOptions.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: GoogleFonts.tenorSans(
                  fontSize: 14.sp,
                  color:AppColor.textColor2,
                  fontWeight: FontWeight.w400,
                ),
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
          'Color',
          style: GoogleFonts.tenorSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.textColor,
          ),
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
                      ? Border.all(color: AppColor.primaryColor, width: 2.5.w)
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
          'Price',
          style: GoogleFonts.tenorSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: 20.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 200,
          activeColor: AppColor.primaryColor,
          inactiveColor: const Color(0xFFE8E8E8),
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
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textColor,
              ),
            ),
            Text(
              '\$${_priceRange.end.toInt()}',
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textColor,
              ),
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
                      activeColor: AppColor.primaryColor,
                      side: BorderSide(
                        color: isSelected
                            ? AppColor.primaryColor
                            : const Color(0xFFDDDDDD),
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
                      style: GoogleFonts.lato(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
                      activeColor: AppColor.primaryColor,
                      side: BorderSide(
                        color: isSelected
                            ? AppColor.primaryColor
                            : const Color(0xFFDDDDDD),
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
                      style: GoogleFonts.lato(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
          'Tags',
          style: GoogleFonts.tenorSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.textColor,
          ),
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
                      ? Border.all(color: AppColor.primaryColor, width: 2.w)
                      : Border.all(color: AppColor.lightGrey, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                  color: isSelected
                      ? const Color(0xFFFFF5F3)
                      : const Color(0xFFFAFAFA),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isSelected
                        ? AppColor.primaryColor
                        : AppColor.textColor2,
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

        // Update provider
        final homeProvider = context.read<HomeProvider>();
        homeProvider.setSortOption(_selectedSort);
        homeProvider.setColors(_selectedColors);
        homeProvider.setPriceRange(_priceRange);
        homeProvider.setConditions(_selectedConditions);
        homeProvider.setGenders(_selectedGenders);
        homeProvider.setTags(_selectedTags);

        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFAD4DB7), Color(0xFF8B39B8)],
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            'APPLY FILTERS',
            style: GoogleFonts.lato(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
