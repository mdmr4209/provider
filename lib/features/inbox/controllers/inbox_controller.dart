import 'package:flutter/material.dart';
import '../models/inbox_model.dart';
import '../models/booking_model.dart';
import '../../../core/utils/helpers/snack_bar_helper.dart';

class InboxController extends ChangeNotifier {
  List<StoryModel> _stories = [];
  List<ChatSummaryModel> _chats = [];
  List<ChatMessageModel> _messages = [];
  List<BookingModel> _currentBookings = [];
  List<BookingModel> _historyBookings = [];

  bool _isLoading = false;
  bool _isRefreshing = false;

  List<StoryModel> get stories => _stories;
  List<ChatSummaryModel> get chats => _chats;
  List<ChatMessageModel> get messages => _messages;
  List<BookingModel> get currentBookings => _currentBookings;
  List<BookingModel> get historyBookings => _historyBookings;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  Future<void> fetchInboxData({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      // Mock dynamic JSON responses from 14.1 Get Inbox Chats
      final Map<String, dynamic> rawInbox = {
        "stories": [
          { "name": "Your Story", "avatar": "https://i.pravatar.cc/150?u=me", "isMine": true },
          { "name": "Mike", "avatar": "https://i.pravatar.cc/150?u=mike1" },
          { "name": "Sarah", "avatar": "https://i.pravatar.cc/150?u=sarah" },
          { "name": "Mike", "avatar": "https://i.pravatar.cc/150?u=mike2" },
          { "name": "Paul", "avatar": "https://i.pravatar.cc/150?u=paul" }
        ],
        "chats": [
          {
            "id": "chat_001",
            "name": "Miles Esther",
            "avatar": "https://i.pravatar.cc/150?u=miles",
            "lastMessage": "How are you doing today?",
            "time": "09:30 PM",
            "unreadCount": 2,
            "isOnline": true,
            "isCoach": true
          },
          {
            "id": "chat_002",
            "name": "Thomas stieve",
            "avatar": "https://i.pravatar.cc/150?u=thomas",
            "lastMessage": "Let's catch up later.",
            "time": "08:15 PM",
            "unreadCount": 0,
            "isOnline": false,
            "isCoach": false
          }
        ]
      };

      _stories = (rawInbox['stories'] as List).map((x) => StoryModel.fromJson(x)).toList();
      _chats = (rawInbox['chats'] as List).map((x) => ChatSummaryModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load chats: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchChatMessages(String chatId, {bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
      _messages = [];
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock response based on 14.2
      final Map<String, dynamic> rawMessages = {
        "messages": [
          {
            "sender": chatId == "chat_002" ? "Thomas stieve" : "Miles Esther",
            "avatar": chatId == "chat_002" ? "https://i.pravatar.cc/150?u=thomas" : "https://i.pravatar.cc/150?u=miles",
            "text": "ype and scrambled it to  scrsgfd",
            "isMe": false,
            "time": "Wednesday"
          },
          {
            "sender": chatId == "chat_002" ? "Thomas stieve" : "Miles Esther",
            "avatar": chatId == "chat_002" ? "https://i.pravatar.cc/150?u=thomas" : "https://i.pravatar.cc/150?u=miles",
            "text": "ype and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
            "isMe": false,
            "time": "Wednesday"
          },
          {
            "sender": "Me",
            "avatar": "",
            "text": "ype and scrambled it to",
            "isMe": true,
            "time": "Wednesday"
          },
          {
            "sender": "Me",
            "avatar": "",
            "text": "ype and scrambled it to make a type specimen book. It has survived not only five centuries.",
            "isMe": true,
            "time": "Wednesday"
          }
        ]
      };

      _messages = (rawMessages['messages'] as List).map((x) => ChatMessageModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load messages: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookings({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock dynamic JSON based on 15.1
      final Map<String, dynamic> rawBookings = {
        "current": [
          {
            "id": "b_1",
            "sessionName": "Session 1",
            "coachName": "Coach Pearl",
            "date": "Mon, Mar 27",
            "time": "01:00 PM- 01:03PM (30Min)",
            "amount": "20\$"
          },
          {
            "id": "b_3",
            "sessionName": "Session 3",
            "coachName": "Coach Emma",
            "date": "Wed, Mar 29",
            "time": "09:00 AM- 09:30AM (30Min)",
            "amount": "20\$"
          }
        ],
        "history": [
          {
            "id": "b_2",
            "sessionName": "Session 2",
            "coachName": "Miles Esther",
            "date": "Completed",
            "time": "12 April, 1:30AM",
            "amount": "20\$"
          },
          {
            "id": "b_4",
            "sessionName": "Session 4",
            "coachName": "Thomas stieve",
            "date": "Completed",
            "time": "10 April, 3:00PM",
            "amount": "20\$"
          }
        ]
      };

      _currentBookings = (rawBookings['current'] as List).map((x) => BookingModel.fromJson(x)).toList();
      _historyBookings = (rawBookings['history'] as List).map((x) => BookingModel.fromJson(x)).toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load bookings: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _currentBookings.removeWhere((b) => b.id == bookingId);
      showSuccessSnackBar(message: "Booking cancelled successfully.");
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to cancel booking: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String text, String chatId) {
    if (text.trim().isEmpty) return;

    _messages.add(
      ChatMessageModel(
        sender: "Me",
        avatar: "",
        text: text.trim(),
        isMe: true,
        time: "Today"
      )
    );
    notifyListeners();
  }
}
