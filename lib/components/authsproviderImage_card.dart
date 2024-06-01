// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:reauth/models/userprovider_model.dart';
// import 'package:reauth/pages/providerdetail_page.dart';

// class AuthsProviderImageCard extends StatelessWidget {
//   final UserProviderModel providerModel;

//   const AuthsProviderImageCard({
//     Key? key,
//     required this.providerModel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Card(
//         elevation: 5,
//         margin: const EdgeInsets.all(5),
//         color: const Color.fromARGB(255, 43, 51, 63),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => ProviderDetailPage(
//                   providerModel: providerModel,
//                 ),
//               ),
//             );
//           },
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: providerModel.faviconUrl,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     color: Colors.grey[300],
//                     child: const Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => const Icon(Icons.error),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                     color: Colors.black.withOpacity(0.6),
//                     child: Text(
//                       providerModel.authName,
//                       style: GoogleFonts.karla(
//                         color: Colors.white,
//                         fontSize: 16,
//                         letterSpacing: 0.5,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
