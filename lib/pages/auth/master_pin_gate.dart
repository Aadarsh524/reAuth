import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/services/encryption_service.dart';

class MasterPinGate extends StatefulWidget {
  const MasterPinGate({Key? key}) : super(key: key);

  @override
  State<MasterPinGate> createState() => _MasterPinGateState();
}

class _MasterPinGateState extends State<MasterPinGate> {
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _verifyPin() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Await the fetchProfile() so that the cubit loads the profile from Firestore.
    await context.read<ProfileCubit>().fetchProfile();
    // After fetching, get the current state.
    final profileState = context.read<ProfileCubit>().state;

    if (profileState is ProfileLoaded) {
      if (profileState.profile.isMasterPinSet == true) {
        // Retrieve the stored (encrypted/hashed) PIN from the profile.
        final storedEncryptedPin = profileState.profile.masterPin;

        final decryptedMasterPin =
            await EncryptionService.decryptData(storedEncryptedPin);

        // Encrypt/hash the entered PIN (using your EncryptionService).
        final enteredPin = pinController.text.trim();

        if (enteredPin == decryptedMasterPin) {
          // PIN verified successfully; navigate to Dashboard.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        } else {
          setState(() {
            errorMessage = 'Incorrect PIN. Please try again.';
          });
        }
      }
      if (profileState.profile.isMasterPinSet == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
        // The profile is loaded but no master PIN is set.
        // showGeneralDialog(
        //   context: context,
        //   barrierDismissible: true,
        //   barrierLabel:
        //       MaterialLocalizations.of(context).modalBarrierDismissLabel,
        //   barrierColor: Colors.black54,
        //   transitionDuration: const Duration(milliseconds: 300),
        //   pageBuilder: (context, animation, secondaryAnimation) {
        //     return Center(
        //       child: AlertDialog(
        //         backgroundColor: const Color.fromARGB(255, 72, 80, 93),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         title: Text(
        //           "Set Master PIN",
        //           style: GoogleFonts.karla(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         content: Text(
        //           "You haven't set a master PIN yet. Would you like to set one now for faster and secure access?",
        //           style: GoogleFonts.karla(
        //             color: Colors.white,
        //             fontSize: 14,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //         actions: [
        //           TextButton(
        //             onPressed: () => Navigator.pop(context),
        //             style: TextButton.styleFrom(
        //               backgroundColor: Colors.red,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(8),
        //                 side: const BorderSide(color: Colors.red),
        //               ),
        //             ),
        //             child: Text(
        //               "Skip",
        //               style: GoogleFonts.karla(
        //                 color: Colors.white,
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               Navigator.pop(context); // Close the dialog
        //               Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => const AddPinPage(),
        //                 ),
        //               );
        //             },
        //             style: TextButton.styleFrom(
        //               backgroundColor: Colors.redAccent,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: Text(
        //               "Set PIN",
        //               style: GoogleFonts.karla(
        //                 color: Colors.white,
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        //   transitionBuilder: (context, animation, secondaryAnimation, child) {
        //     if (animation.status == AnimationStatus.reverse) {
        //       return child;
        //     }
        //     return ScaleTransition(
        //       scale: CurvedAnimation(
        //         parent: animation,
        //         curve: Curves.easeOutBack,
        //       ),
        //       child: child,
        //     );
        //   },
        // );
      }
    } else {
      setState(() {
        errorMessage = 'Profile not loaded. Please try again later.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Master PIN"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Please enter your master PIN to access your Dashboard",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Master PIN",
                border: OutlineInputBorder(),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyPin,
                    child: const Text("Unlock"),
                  ),
          ],
        ),
      ),
    );
  }
}
