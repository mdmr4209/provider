import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../routes/app_router.dart';
import '../../../coach/profile/views/coach_profile_view.dart';
import '../../circle/views/user_profile_view.dart';
import '../controllers/inbox_controller.dart';
import '../models/inbox_model.dart';
import 'call_view.dart';

class ChatController extends ChangeNotifier {
  final InboxController inboxController;
  final String chatId;
  final String name;
  final String avatar;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  ChatController({
    required this.inboxController,
    required this.chatId,
    required this.name,
    required this.avatar,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await inboxController.fetchChatMessages(chatId);
      scrollToBottom();
    });
  }

  List<ChatMessageModel> get messages => inboxController.messages;

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    inboxController.sendMessage(text, chatId);
    messageController.clear();
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class ChatView extends StatelessWidget {
  final String name;
  final String avatar;
  final bool isCoach;

  const ChatView({
    super.key,
    required this.name,
    required this.avatar,
    this.isCoach = false,
  });

  // Upgrade Plan Popup
  void _showUpgradePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(204),
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.popupBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(color: AppColors.primaryColor.withAlpha(102), width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Text(
                  "Upgrade Your Plan",
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Add your payment details to call and connect with your coach",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  onPress: () async {
                    Navigator.pop(context);
                    context.push(AppRoutes.subscriptionPlan);
                  },
                  title: "Upgrade Now",
                  linearGradient: true,
                  height: 48,
                  radius: 8,
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.iconColor.withAlpha(102), width: 1.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Later",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // We Apologize Popup
  void _showUnavailablePopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(204),
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.popupBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: BorderSide(color: AppColors.primaryColor.withAlpha(102), width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Icon(Icons.person_outline, size: 50.r, color: AppColors.iconColor),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.cancel, size: 20.r, color: AppColors.iconColor),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 4.h,
                        width: 45.w,
                        color: AppColors.iconColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "We Apologize",
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '"Coach X is unavailable right now. Would you like to?"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 28.h),
                CustomButton(
                  onPress: () async {
                    Navigator.pop(context);
                    _navigateToCallScreen(context);
                  },
                  title: "Call Back",
                  linearGradient: true,
                  height: 48,
                  radius: 8,
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.coaches);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.iconColor.withAlpha(102), width: 1.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Schedule a Session",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCallScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallView(
          name: name,
          avatar: avatar,
          rate: isCoach ? '2\$/Min' : 'Free',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inboxController = context.watch<InboxController>();
    final chatId = name == "Thomas stieve" ? "chat_002" : "chat_001";
    final userId = name == "Miles Esther" ? "u1" : (name == "Thomas stieve" ? "u2" : "u3");

    return ChangeNotifierProvider<ChatController>(
      create: (_) => ChatController(
        inboxController: inboxController,
        chatId: chatId,
        name: name,
        avatar: avatar,
      ),
      child: Consumer<ChatController>(
        builder: (context, chat, _) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF20341F),
              elevation: 0,
              titleSpacing: 0,
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: NetworkImage(avatar),
                    backgroundColor: Colors.white.withAlpha(26),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Online",
                          style: TextStyle(
                            color: Colors.white.withAlpha(153),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.videocam_outlined, color: Colors.white, size: 24.r),
                  onPressed: () {
                    if (isCoach) {
                      _showUpgradePopup(context);
                    } else {
                      _navigateToCallScreen(context);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call_outlined, color: Colors.white, size: 22.r),
                  onPressed: () {
                    if (isCoach) {
                      _showUnavailablePopup(context);
                    } else {
                      _navigateToCallScreen(context);
                    }
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white, size: 22.r),
                  color: AppColors.popupBackgroundColor,
                  shape: const TooltipShapeBorder(),
                  offset: Offset(0, 48.h),
                  onSelected: (value) {
                    if (value == 'profile') {
                      if (isCoach) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CoachProfileView()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserProfileView(
                              userId: userId,
                              userName: name,
                              userAvatar: avatar,
                            ),
                          ),
                        );
                      }
                    } else if (value == 'review') {
                      context.push(AppRoutes.review);
                    } else if (value == 'report') {
                      context.push(AppRoutes.reportToAdmin);
                    } else if (value == 'block') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$name blocked')),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem('profile', 'View Profile', Icons.visibility_outlined),
                    _buildPopupMenuItem('review', 'Give a review', Icons.star_border),
                    _buildPopupMenuItem('report', 'Report', Icons.insert_chart_outlined_outlined),
                    _buildPopupMenuItem('block', 'Block', Icons.block_outlined),
                  ],
                ),
                SizedBox(width: 8.w),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () => inboxController.fetchChatMessages(chatId, isRefresh: true),
                        color: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        strokeWidth: 0,
                        elevation: 0,
                        child: inboxController.isLoading && chat.messages.isEmpty
                            ? const _ChatShimmer()
                            : ListView.builder(
                                controller: chat.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                itemCount: chat.messages.length,
                                itemBuilder: (context, index) {
                                  final message = chat.messages[index];
                                  final isMe = message.isMe;
                                  final showAvatar = !isMe && (index == chat.messages.length - 1 || chat.messages[index + 1].isMe == true || chat.messages[index + 1].sender != name);
                                  final bool showDivider = index == 0 || chat.messages[index - 1].time != message.time;

                                  return Column(
                                    children: [
                                      if (showDivider) ...[
                                        SizedBox(height: 16.h),
                                        Row(
                                          children: [
                                            Expanded(child: Divider(color: Colors.white.withAlpha(26), thickness: 1)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                              child: Text(
                                                message.time,
                                                style: TextStyle(
                                                  color: Colors.white.withAlpha(102),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Divider(color: Colors.white.withAlpha(26), thickness: 1)),
                                          ],
                                        ),
                                        SizedBox(height: 16.h),
                                      ],
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        child: Row(
                                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            if (!isMe) ...[
                                              if (showAvatar)
                                                CircleAvatar(
                                                  radius: 15.r,
                                                  backgroundImage: NetworkImage(message.avatar.isNotEmpty ? message.avatar : avatar),
                                                  backgroundColor: Colors.white.withAlpha(26),
                                                )
                                              else
                                                SizedBox(width: 30.r),
                                              SizedBox(width: 8.w),
                                            ],
                                            Flexible(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                                                decoration: BoxDecoration(
                                                  color: isMe 
                                                      ? const Color(0xFF1E331A)
                                                      : Colors.white.withAlpha(26),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(16.r),
                                                    topRight: Radius.circular(16.r),
                                                    bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                                                    bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  message.text,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.5.sp,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (isMe) SizedBox(width: 30.w),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      if (inboxController.isRefreshing)
                        Positioned(
                          top: 16.h,
                          left: 0,
                          right: 0,
                          child: const Center(child: CustomLoader(size: 150)),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(13),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: Colors.white.withAlpha(26)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextField(
                            controller: chat.messageController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: AppColors.secondaryColorLight,
                            decoration: InputDecoration(
                              hintText: "Type here",
                              hintStyle: TextStyle(
                                color: Colors.white.withAlpha(102),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                            ),
                            onSubmitted: (_) => chat.sendMessage(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: chat.sendMessage,
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: const Color(0xFF1E331A),
                          child: SvgPicture.asset(
                            AppAssets.send,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 18.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String text, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withAlpha(153), size: 20.r),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowOffset;
  final double radius;

  const TooltipShapeBorder({
    this.arrowWidth = 12.0,
    this.arrowHeight = 8.0,
    this.arrowOffset = 14.0,
    this.radius = 8.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(top: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
      rect.topLeft + Offset(0, arrowHeight),
      rect.bottomRight,
    );
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    
    final double x = rect.right - arrowOffset - arrowWidth;
    path.moveTo(x, rect.top);
    path.lineTo(x + arrowWidth / 2, rect.top - arrowHeight);
    path.lineTo(x + arrowWidth, rect.top);
    path.close();
    
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class _ChatShimmer extends StatelessWidget {
  const _ChatShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        final isMe = index % 2 == 0;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                ShimmerLoader(width: 30.r, height: 30.r, borderRadius: 15.r),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: ShimmerLoader(
                  width: (100 + (index * 25) % 150).w,
                  height: 40.h,
                  borderRadius: 16.r,
                ),
              ),
              if (isMe) SizedBox(width: 30.w),
            ],
          ),
        );
      },
    );
  }
}
