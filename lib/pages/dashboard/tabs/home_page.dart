import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/popular_auth_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/profile_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/cubit/user_auth_cubit.dart';
import 'package:reauth/components/AuthCategory/bloc/states/popular_provider_state.dart';
import 'package:reauth/components/AuthCategory/bloc/states/profile_state.dart';
import 'package:reauth/components/AuthCategory/bloc/states/user_auth_state.dart';
import 'package:reauth/components/auths_card.dart';
import 'package:reauth/components/custom_snackbar.dart';
import 'package:reauth/components/popular_auth_card.dart';
import 'package:reauth/components/constants/auth_category.dart';
import 'package:reauth/models/user_auth_model.dart';
import 'package:reauth/pages/auth/addpin_page.dart';
import 'package:reauth/pages/dashboard/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    searchController.addListener(_handleSearchInput);
    _searchFocusNode.addListener(() {
      // When the search field loses focus and is empty, reset the search state.
      if (!_searchFocusNode.hasFocus && searchController.text.trim().isEmpty) {
        setState(() {
          isSearching = false;
        });
        _initializeData();
      }
    });
  }

  void _initializeData() {
    context.read<UserAuthCubit>().fetchUserAuths();
    context.read<ProfileCubit>().fetchProfile();
    context.read<PopularAuthCubit>().fetchPopularAuths();
  }

  /// Debounced search handling:
  /// - After 500ms delay, if the query is not empty, we trigger search.
  /// - The search is performed on UserAuthCubit if user auths exist,
  ///   otherwise on PopularAuthCubit.
  /// - If the query is empty, we revert to default data.
  void _handleSearchInput() {
    final query = searchController.text.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isSearching = query.isNotEmpty;
      });
      if (query.isNotEmpty) {
        // Determine where to search based on whether user auths exist.
        final userAuthState = context.read<UserAuthCubit>().state;
        if (userAuthState is UserAuthLoadSuccess &&
            userAuthState.auths.isNotEmpty) {
          context.read<UserAuthCubit>().searchUserAuth(query);
        } else {
          context.read<PopularAuthCubit>().searchPopularAuth(query);
        }
      } else {
        // When query is empty, load default data.
        _initializeData();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) => _handleProfileState(context, state),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildSearchBar(),
                const SizedBox(height: 12),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── HEADER & SEARCH BAR ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("ReAuth", style: _headerTextStyle()),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => _buildProfileAvatar(state),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      controller: searchController,
      focusNode: _searchFocusNode,
      hintText: "Search",
      backgroundColor: const WidgetStatePropertyAll(Color(0xFF2B333F)),
      trailing: [Icon(Icons.search, color: _searchIconColor)],
      hintStyle: WidgetStatePropertyAll(_hintTextStyle()),
      textStyle: WidgetStatePropertyAll(_searchTextStyle()),
    );
  }

  // ─── MAIN CONTENT ─────────────────────────────────────────────────────────
  Widget _buildMainContent() {
    return BlocConsumer<UserAuthCubit, UserAuthState>(
      listener: (context, state) => _handleUserAuthState(context, state),
      builder: (context, state) {
        if (state is UserAuthLoading) return _buildLoadingIndicator();

        // If there is a search query and results/error from user auth search.
        if (state is UserAuthSearchSuccess) {
          return _buildSearchResults(state);
        }
        if (state is UserAuthSearchFailure) {
          // Show error text in the search area.
          return _buildError(state.error);
        }

        if (state is UserAuthLoadSuccess) {
          // Show the user auth list if it exists; otherwise show popular auths.
          return _buildAuthSections(state);
        }
        return _buildLoadingIndicator();
      },
    );
  }

  /// If user auth list is not empty, show “Your Auths”.
  /// Otherwise, delegate to a widget that shows popular auths.
  Widget _buildAuthSections(UserAuthLoadSuccess state) {
    if (state.auths.isNotEmpty) {
      return SingleChildScrollView(
        child: _buildUserAuths(state.auths),
      );
    } else {
      return _buildPopularAuthContent();
    }
  }

  Widget _buildUserAuths(List<UserAuthModel> auths) {
    final categorizedAuths = _categorizeAuths(auths);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Your Auths", style: _sectionHeaderStyle()),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categorizedAuths.keys.length,
          itemBuilder: (context, index) => _buildAuthCategory(
            categorizedAuths.keys.elementAt(index),
            categorizedAuths.values.elementAt(index),
          ),
        ),
      ],
    );
  }

  /// When no user auths exist, we show the popular auths instead.
  /// This widget also listens for search events coming from PopularAuthCubit.
  Widget _buildPopularAuthContent() {
    return BlocConsumer<PopularAuthCubit, PopularAuthState>(
      listener: (context, state) {
        // Instead of showing errors via snackbar, errors are now displayed
        // as text via the builder.
      },
      builder: (context, state) {
        if (state is PopularAuthLoading) return _buildLoadingIndicator();

        if (isSearching) {
          if (state is PopularAuthSearchSuccess) {
            return _buildPopularAuthSearchResults(state);
          } else if (state is PopularAuthSearchFailure) {
            return _buildError(state.error);
          }
        }

        if (state is PopularAuthLoadSuccess) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Popular Auths", style: _sectionHeaderStyle()),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.auths.length,
                  itemBuilder: (context, i) =>
                      PopularAuthCard(authModel: state.auths[i]),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildPopularAuthSearchResults(PopularAuthSearchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Search Results", style: _sectionHeaderStyle()),
        PopularAuthCard(authModel: state.auth),
      ],
    );
  }

  /// Build search results for user auths.
  Widget _buildSearchResults(UserAuthSearchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Search Results", style: _sectionHeaderStyle()),
        AuthsCard(providerModel: state.auth),
      ],
    );
  }

  // ─── PROFILE STATE HANDLING ──────────────────────────────────────────────
  Future<void> _handleProfileState(
      BuildContext context, ProfileState state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool justLoggedIn = prefs.getBool('just_logged_in') ?? false;

    if (justLoggedIn) {
      if (state is ProfileLoaded && !state.profile.isMasterPinSet) {
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          _showSetPinDialog(context);
        }
      }
    }
  }

  void _handleUserAuthState(BuildContext context, UserAuthState state) {
    if (state is UserAuthLoadFailure) {
      // If there's a failure when loading user auths (outside of search),
      // you can continue using a snackbar if desired.
      CustomSnackbar.show(context,
          message: "Error: ${state.error}", isError: true);
    }
  }

  // ─── UI COMPONENTS ───────────────────────────────────────────────────────
  Widget _buildProfileAvatar(ProfileState state) {
    final imageUrl = state is ProfileLoaded ? state.profile.profileImage : '';
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfilePage())),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: imageUrl.isNotEmpty
            ? CachedNetworkImageProvider(imageUrl) as ImageProvider
            : const AssetImage('assets/defaultAvatar.png'),
      ),
    );
  }

  Widget _buildAuthCategory(AuthCategory category, List<UserAuthModel> auths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...auths.map((auth) => AuthsCard(providerModel: auth)).toList(),
        _buildCategoryDivider(category),
      ],
    );
  }

  Widget _buildCategoryDivider(AuthCategory category) {
    return Row(
      children: [
        Text(authCategoryStrings[category]!, style: _categoryTextStyle()),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: Colors.grey)),
      ],
    );
  }

  // ─── STYLE HELPERS ─────────────────────────────────────────────────────────
  TextStyle _headerTextStyle() {
    return GoogleFonts.karla(
      color: Colors.white,
      fontSize: 25,
      letterSpacing: 0.75,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _sectionHeaderStyle() {
    return GoogleFonts.karla(
      color: const Color(0xFF7D7D7D),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _categoryTextStyle() {
    return GoogleFonts.karla(
      color: const Color(0xFF7D7D7D),
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );
  }

  // ─── DIALOG ───────────────────────────────────────────────────────────────
  void _showSetPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF48505D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Set Master PIN", style: _dialogTitleStyle()),
        content: Text(
          "Set a master PIN for quick, secure access to your passwords.",
          style: _dialogContentStyle(),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool('just_logged_in', false);
              Navigator.pop(context);
            },
            style: _dialogButtonStyle(backgroundColor: Colors.red),
            child: Text("Cancel", style: _dialogButtonTextStyle()),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AddPinPage())),
            style: _dialogButtonStyle(backgroundColor: const Color(0xFF6FA3DB)),
            child: Text("Set PIN", style: _dialogButtonTextStyle()),
          ),
        ],
      ),
    );
  }

  TextStyle _dialogTitleStyle() {
    return GoogleFonts.karla(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle _dialogContentStyle() {
    return GoogleFonts.karla(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  ButtonStyle _dialogButtonStyle({required Color backgroundColor}) {
    return TextButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  TextStyle _dialogButtonTextStyle() {
    return GoogleFonts.karla(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  // ─── UTILITY METHODS ──────────────────────────────────────────────────────
  Map<AuthCategory, List<UserAuthModel>> _categorizeAuths(
      List<UserAuthModel> auths) {
    final Map<AuthCategory, List<UserAuthModel>> categories = {};
    for (final auth in auths) {
      categories.putIfAbsent(auth.authCategory, () => []).add(auth);
    }
    return categories;
  }

  Color get _searchIconColor =>
      isSearching ? Colors.white : const Color(0xFF7D7D7D);

  TextStyle _hintTextStyle() => GoogleFonts.karla(
        color: const Color(0xFF7D7D7D),
        fontSize: 16,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      );

  TextStyle _searchTextStyle() => GoogleFonts.karla(
        color: Colors.white,
        fontSize: 16,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      );

  Widget _buildLoadingIndicator() => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6AAABF)),
      );

  /// Returns an error widget showing the error text.
  Widget _buildError(String error) => Center(
        child: Text(error,
            style: const TextStyle(color: Colors.red, fontSize: 16)),
      );
}
