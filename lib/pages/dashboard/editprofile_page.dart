import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/custom_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 45, 58),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 45, 58),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.karla(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 25,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .90,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/defaultAvatar.png'),
                  ),
                  Positioned(
                    left: 60,
                    bottom: 0,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 106, 172, 191),
                            border: Border.all(
                              color: const Color.fromARGB(255, 106, 172, 191),
                              width: 1,
                            ),
                          ),
                          width: 30,
                          height: 30,
                        ),
                        Positioned.fill(
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                keyboardType: TextInputType.text,
                controller: usernameController,
                hintText: 'enter auth fullname',
                labelText: 'Full Name ',
              ),
              CustomTextField(
                keyboardType: TextInputType.visiblePassword,
                controller: emailController,
                hintText: 'enter auth email',
                labelText: 'Email',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: TextButton(
        onPressed: () async {},
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 111, 163, 219),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Adjust the radius here
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        ),
        child: Text(
          'Save',
          style: GoogleFonts.karla(
            color: Color.fromARGB(249, 255, 255, 255),
            fontSize: 16,
            letterSpacing: .5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
