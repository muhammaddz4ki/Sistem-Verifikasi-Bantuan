// lib/screens/qr_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  // Flag to prevent multiple navigation actions after a scan is detected
  bool isScanCompleted = false;

  /// Closes the scanner screen. Ensures it only pops once.
  void closeScreen() {
    if (!isScanCompleted) {
      isScanCompleted = true; // Mark as completed to prevent re-entry
      Navigator.pop(context); // Pop the screen without returning any data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pindai QR Code'),
        // Set consistent background color for the AppBar
        backgroundColor: const Color(
          0xFF1976D2,
        ), // Primary blue from Login/Home Screens
        // Set consistent text style for the AppBar title
        titleTextStyle: const TextStyle(
          color: Colors.white, // White text for better contrast
          fontSize: 20,
          fontWeight: FontWeight.bold, // Bold text for prominence
        ),
        // Set consistent icon theme for AppBar icons (e.g., the close button)
        iconTheme: const IconThemeData(
          color: Colors.white, // White icon for better contrast
        ),
        // Custom leading icon button for closing the screen
        leading: IconButton(
          icon: const Icon(Icons.close), // Close icon
          onPressed: closeScreen, // Call the closeScreen method
          tooltip: 'Tutup Pemindai', // Tooltip for accessibility
        ),
      ),
      body: Container(
        // Apply the gradient background from the Home and History screens
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
            ], // Lighter blue gradient
          ),
        ),
        // Center the scanner view within the gradient container
        child: Center(
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width *
                0.8, // Make scanner view 80% of screen width
            height:
                MediaQuery.of(context).size.height *
                0.5, // Make scanner view 50% of screen height
            child: Stack(
              // Use a Stack to layer the scanner and the custom overlay
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Apply rounded corners to the scanner view
                  child: MobileScanner(
                    // Removed the incorrect 'overlay' parameter
                    onDetect: (capture) {
                      // Ensure scan is not already completed to prevent multiple pop events
                      if (!isScanCompleted) {
                        final List<Barcode> barcodes = capture.barcodes;
                        // Check if any barcode was detected and if its raw value is not null
                        if (barcodes.isNotEmpty &&
                            barcodes.first.rawValue != null) {
                          isScanCompleted =
                              true; // Set flag to true to prevent further detection
                          final String code =
                              barcodes.first.rawValue!; // Get the scanned code
                          // Pop the screen and pass the scanned code back to the previous screen
                          Navigator.pop(context, code);
                        }
                      }
                    },
                  ),
                ),
                // Custom overlay for the border, placed on top of the scanner
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 4,
                    ), // Add a visible border
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
