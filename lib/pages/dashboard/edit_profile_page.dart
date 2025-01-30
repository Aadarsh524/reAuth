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
import 'package:reauth/models/profile_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileModel profileModel;
  const EditProfilePage({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  late String profileImage;

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.profileModel.fullName;
    profileImage = widget.profileModel.profileImage;
  }

  Future<void> _requestPermission() async {
    final status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Please enable photo access in app settings'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    if (!status.isGranted) {
      throw Exception('Photo library access is required to select images');
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      await _requestPermission();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      if (result != null && result.files.isNotEmpty) {
        File imageFile = File(result.files.single.path!);
        BlocProvider.of<ProfileCubit>(context).uploadImageToFirebase(imageFile);
      }
    } catch (e) {
      CustomSnackbar.show(context, message: e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = BlocProvider.of<ProfileCubit>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 36, 45, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 45, 58),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.karla(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: .75,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 40, 50, 65),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        profileImage.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    CachedNetworkImageProvider(profileImage),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/defaultAvatar.png'),
                              ),
                        Positioned(
                          left: 60,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor:
                                const Color.fromARGB(255, 106, 172, 191),
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white, size: 16),
                              onPressed: () => pickImage(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      isRequired: true,
                      keyboardType: TextInputType.text,
                      controller: fullNameController,
                      hintText: 'Enter your full name',
                      labelText: 'Full Name',
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileUpdated) {
                          CustomSnackbar.show(context,
                              message: "Update Success");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DashboardPage()),
                          );
                        } else if (state is ProfileUpdateError) {
                          CustomSnackbar.show(context,
                              message: state.error.toString(), isError: true);
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is ProfileLoading
                                ? null
                                : () {
                                    profileCubit.updateProfile(
                                      fullname: fullNameController.text,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 163, 219),
                              disabledBackgroundColor:
                                  const Color.fromARGB(255, 111, 163, 219),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: GoogleFonts.karla(
                                fontSize: 16,
                                letterSpacing: .5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: state is ProfileLoading
                                ? const SizedBox(
                                    height: 19,
                                    width: 19,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.transparent,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
