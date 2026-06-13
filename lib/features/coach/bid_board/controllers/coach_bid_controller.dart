import 'package:flutter/material.dart';
import '../../../../core/utils/helpers/snack_bar_helper.dart';

class CoachBidController extends ChangeNotifier {
  String? _selectedSlot;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController ticketQuantityController = TextEditingController();

  int _myTickets = 5;
  final int _totalCoaches = 128;
  bool _hasWon = false;

  String? get selectedSlot => _selectedSlot;
  int get myTickets => _myTickets;
  int get totalCoaches => _totalCoaches;
  bool get hasWon => _hasWon;

  void setSlot(String? value) {
    _selectedSlot = value;
    notifyListeners();
  }

  void confirmBid(BuildContext context) {
    if (_selectedSlot == null || amountController.text.isEmpty) {
      showErrorSnackBar(message: "Please select a slot and enter an amount.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2B1B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              'Are you sure about Bidding amount?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will be charged, if you win the Slot',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5D4A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showSuccessSnackBar(message: "Bid placed successfully!");
                      _selectedSlot = null;
                      amountController.clear();
                      notifyListeners();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC19E5F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void buyTickets(BuildContext context) {
    if (ticketQuantityController.text.isEmpty) {
      showErrorSnackBar(message: "Please enter ticket quantity.");
      return;
    }
    
    // Mock purchase
    final int qty = int.tryParse(ticketQuantityController.text) ?? 0;
    _myTickets += qty;
    ticketQuantityController.clear();
    notifyListeners();
    // Navigate to success
  }

  void simulateWin() {
    _hasWon = true;
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    ticketQuantityController.dispose();
    super.dispose();
  }
}
