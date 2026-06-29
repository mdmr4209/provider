import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/inbox_model.dart';
import '../models/booking_model.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

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
      final String jsonString = await rootBundle.loadString(
        'assets/json/inbox.json',
      );
      final Map<String, dynamic> rawInbox = jsonDecode(jsonString);

      _stories = (rawInbox['stories'] as List)
          .map((x) => StoryModel.fromJson(x))
          .toList();
      _chats = (rawInbox['chats'] as List)
          .map((x) => ChatSummaryModel.fromJson(x))
          .toList();
    } catch (e) {
      showErrorSnackBar(message: "Failed to load chats: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> fetchChatMessages(
    String chatId, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
      _messages = [];
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final String messagesJsonString = await rootBundle.loadString(
        'assets/json/chat_messages.json',
      );
      final Map<String, dynamic> rawMessages = jsonDecode(messagesJsonString);

      _messages = (rawMessages['messages'] as List).map((x) {
        // We override the sender/avatar dynamically based on chatId like the mock did
        // In a real app, this comes from the backend per chat.
        var msg = ChatMessageModel.fromJson(x);
        if (!msg.isMe) {
          return msg.copyWith(
            sender: chatId == "chat_002" ? "Thomas stieve" : "Miles Esther",
            avatar: chatId == "chat_002"
                ? "https://i.pravatar.cc/150?u=thomas"
                : "https://i.pravatar.cc/150?u=miles",
          );
        }
        return msg;
      }).toList();
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

      final String bookingsJsonString = await rootBundle.loadString(
        'assets/json/bookings.json',
      );
      final Map<String, dynamic> rawBookings = jsonDecode(bookingsJsonString);

      _currentBookings = (rawBookings['current'] as List)
          .map((x) => BookingModel.fromJson(x))
          .toList();
      _historyBookings = (rawBookings['history'] as List)
          .map((x) => BookingModel.fromJson(x))
          .toList();
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

  Future<bool> rescheduleBooking(String bookingId, String newDate, String newTime) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final index = _currentBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final booking = _currentBookings[index];
        _currentBookings[index] = BookingModel(
          id: booking.id,
          sessionName: booking.sessionName,
          coachName: booking.coachName,
          date: newDate,
          time: newTime,
          amount: booking.amount,
          originalDate: booking.originalDate ?? booking.date,
          originalTime: booking.originalTime ?? booking.time,
        );
      }
      showSuccessSnackBar(message: "Booking rescheduled successfully.");
      return true;
    } catch (e) {
      showErrorSnackBar(message: "Failed to reschedule booking: $e");
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
        time: "Today",
      ),
    );
    notifyListeners();
  }
}
