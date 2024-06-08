// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reauth/bloc/cubit/profile_cubit.dart';
import 'package:reauth/bloc/states/profile_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/custom_textfield.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String profileImage = '';

  CustomSnackbar customSnackbar = CustomSnackbar('');

  Future<void> pickImage(BuildContext context) async {
    try {
      final storageStatus = await Permission.storage.request();

      if (!storageStatus.isGranted) {
        log("hellfdjfddf");
        throw Exception('Storage permission is required to upload the image.');
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        File imageFile = File(result.files.single.path!);
        BlocProvider.of<ProfileCubit>(context).uploadImageToFirebase(imageFile);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileCubit = BlocProvider.of<ProfileCubit>(context);
      profileCubit.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 45, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 45, 58),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 25,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (usernameController.text.isEmpty) {
              usernameController.text = state.profile.fullname;
            }
            if (emailController.text.isEmpty) {
              emailController.text = state.profile.email;
            }
            if (profileImage.isEmpty &&
                state.profile.profileImage.toString().isNotEmpty) {
              profileImage = state.profile.profileImage.toString();
            }
          } else if (state is ProfileUpdated) {
            customSnackbar = CustomSnackbar("Update Success");
            customSnackbar.showCustomSnackbar(context);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
          }
          if (state is ProfileUpdateError) {
            customSnackbar = CustomSnackbar(state.error.toString());
            customSnackbar.showCustomSnackbar(context);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 106, 172, 191),
                ),
              );
            } else if (state is ProfileLoaded) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: const Color.fromARGB(255, 40, 50, 65),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    profileImage != ''
                                        ? Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        profileImage),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                'assets/defaultAvatar.png'),
                                          ),
                                    Positioned(
                                      left: 60,
                                      bottom: 0,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color.fromARGB(
                                                  255, 106, 172, 191),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 106, 172, 191),
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
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              onPressed: () {
                                                pickImage(context);
                                              },
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
                                  hintText: 'Enter your full name',
                                  labelText: 'Full Name',
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child:
                                      BlocBuilder<ProfileCubit, ProfileState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          final profileCubit =
                                              BlocProvider.of<ProfileCubit>(
                                                  context);
                                          FocusScope.of(context)
                                              .unfocus(); // Hide keyboard
                                          profileCubit.editProfile(
                                              usernameController.text,
                                              emailController.text,
                                              profileImage);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 111, 163, 219),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          textStyle: GoogleFonts.karla(
                                            fontSize: 16,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        child: const Text('Save'),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "Failed to load profile data",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
