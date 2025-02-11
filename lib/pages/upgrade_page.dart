import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({Key? key}) : super(key: key);

  void _payWithKhalti(BuildContext context) {
    // KhaltiScope.of(context).pay(
    //   config: PaymentConfig(
    //     amount: 1000 * 100, // Convert to paisa (e.g., Rs. 1000 = 100000 paisa)
    //     productIdentity: 'premium_upgrade',
    //     productName: 'Password Manager Premium',
    //   ),
    //   preferences: [
    //     PaymentPreference.khalti,
    //   ],
    //   onSuccess: (success) {
    //     // BlocProvider.of<AuthenticationCubit>(context).upgradeAccount();
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //           content: Text('Payment Successful! Account Upgraded.')),
    //     );
    //   },
    //   onFailure: (failure) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Payment Failed. Try Again.')),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 51, 63),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 53, 64, 79),
        title: Text('Upgrade to Premium',
            style: GoogleFonts.karla(color: Colors.white, fontSize: 20)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upgrade Features:',
                style: GoogleFonts.karla(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...[
              'Unlimited Password Storage',
              'Cloud Backup & Sync',
              'Biometric Authentication',
              'Secure Password Sharing',
              'Breach Monitoring & Alerts'
            ].map((feature) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(feature, style: GoogleFonts.karla(fontSize: 16)),
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _payWithKhalti(context),
                child: Text('Upgrade Now - Rs. 499',
                    style:
                        GoogleFonts.karla(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
