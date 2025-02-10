import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/states/user_auth_state.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/constants/auth_category.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/dashboard/dashboard_page.dart';
import 'package:reauth/pages/dashboard/edit_auth_page.dart';

class AuthDetailPage extends StatefulWidget {
  final UserAuthModel authModel;

  const AuthDetailPage({Key? key, required this.authModel}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthDetailPageState createState() => _AuthDetailPageState();
}

class _AuthDetailPageState extends State<AuthDetailPage> {
  late UserAuthModel authModel;

  @override
  void initState() {
    super.initState();
    authModel = widget.authModel; // Initialize the mutable authModel
  }

  void copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value)).then((_) {
      DateTime now = DateTime.now();

      // Update the local authModel and trigger a rebuild
      setState(() {
        authModel = authModel.copyWith(lastAccessed: now);
      });

      // Update Firestore using the Cubit
      BlocProvider.of<UserAuthCubit>(context).updateAuthLastAccessed(authModel);

      // Show a snackbar after copying
      CustomSnackbar.show(
        context,
        message: "Copied",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProviderCubit = BlocProvider.of<UserAuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 64, 79),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                userProviderCubit.deleteProvider(authModel.authName);
              },
              icon: const Icon(
                Icons.delete,
                size: 28,
                color: Color.fromRGBO(111, 163, 219, 1),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<UserAuthCubit, UserAuthState>(
        listener: (context, state) {
          if (state is UserAuthDeletedFailure) {
            CustomSnackbar.show(context, message: state.error, isError: true);
          }
          if (state is UserAuthDeletedSuccess) {
            CustomSnackbar.show(
              context,
              message: "Delete Success",
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          }
        },
        builder: (context, state) {
          if (state is UserAuthLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6AACBF),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Primary Details",
                        style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final updatedModel = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditAuthPage(userAuthModel: authModel),
                            ),
                          );

                          // Check if an updated model was returned
                          if (updatedModel != null &&
                              updatedModel is UserAuthModel) {
                            // Update the state with the new model
                            authModel =
                                updatedModel; // If immutable, clone the object instead.
                            (context as Element)
                                .markNeedsBuild(); // Rebuild the widget tree
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 24,
                          color: Color(0xFF6FA3DB),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white),
                  _buildDetailsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: authModel.userAuthFavicon!,
            height: 60,
            fit: BoxFit.contain,
            errorWidget: (context, url, error) => Image.asset(
              'assets/error.png',
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            authModel.authName.toUpperCase(),
            style: GoogleFonts.karla(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            authModel.authLink,
            style: GoogleFonts.karla(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final Map<String, dynamic> authDetails = {
      "Category": authCategoryStrings[authModel.authCategory],
      "Username": authModel.username,
      "Password": authModel.password,
      "Transaction Password": authModel.hasTransactionPassword
          ? authModel.transactionPassword
          : null,
      "Tags": authModel.tags,
      "Note": authModel.note,
    };

    final Map<String, DateTime?> dateDetails = {
      "Created At": authModel.createdAt,
      "Updated At": authModel.updatedAt,
      "Last Accessed": authModel.lastAccessed,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General Details
        ...authDetails.entries.map((entry) {
          if (entry.value == null || entry.value == '') {
            return const SizedBox(); // Skip null or empty values
          }

          if (entry.key == "Tags") {
            if (entry.value == null ||
                entry.value == '' ||
                (entry.value as List).isEmpty) {
              return const SizedBox(); // Return empty widget if Tags field is empty or null
            } else {
              return _buildTagsSection(entry.value
                  as List<String>); // Render tags if Tags field has values
            }
          }
          return _buildDetailRow(
            context,
            label: "${entry.key}:",
            value: entry.value.toString(),
            copyAction: entry.key == "Username" ||
                entry.key == "Password" ||
                entry.key == "Transaction Password",
          );
        }).toList(),

        const SizedBox(height: 10),
        const Divider(),
        ExpansionTile(
          title: Text(
            "Dates & Activity",
            style: GoogleFonts.karla(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          collapsedBackgroundColor: Colors.transparent,
          iconColor: Colors.white,
          tilePadding: EdgeInsets.zero, // Remove any padding from the title
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero), // No divider when expanded
          collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero), // No divider when collapsed
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Directly map the date details without extra padding or divider
            ...dateDetails.entries.map((entry) {
              // ignore: unrelated_type_equality_checks
              if (entry.value == null || entry.value == '') {
                return const SizedBox(); // Skip null values
              }
              return _buildDetailRow(
                context,
                label: "${entry.key}:",
                value: _formatDate(entry.value!),
              );
            }).toList(),
          ],
        )
      ],
    );
  }

  // Helper Method to Format Dates
  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy • hh:mm a');
    return formatter.format(dateTime);
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    bool copyAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ensures proper alignment
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.karla(
                color: Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Aligns text and icon together
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: GoogleFonts.karla(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                if (copyAction)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () => copyToClipboard(context, value),
                      borderRadius: BorderRadius.circular(6),
                      child: Tooltip(
                        message: "Copy to Clipboard",
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tags:",
            style: GoogleFonts.karla(
              color: Colors.grey[400],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getTagColor(tag),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.karla(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    final int hash = tag.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b).withOpacity(0.75);
  }
}
