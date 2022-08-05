import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePic extends StatelessWidget {
  ProfilePic({
    // required Key key,
    required this.image,
  });


  final String image;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [

          CircleAvatar(
        child: CachedNetworkImage(
        imageUrl:"https://test.laspa.lg.gov.ng/LaspaApp/ProfilePicture/"+image,
          placeholder: (context, url) =>  CircularProgressIndicator(),
          errorWidget: (context, url, error) =>  Icon(Icons.error),
        ),
      ),



          // Positioned(
          //   right: -16,
          //   bottom: 0,
          //   child: SizedBox(
          //     height: 46,
          //     width: 46,
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(50),
          //         side: const BorderSide(color: Colors.white),
          //       ),
          //       color: const Color(0xFFF5F6F9),
          //       onPressed: () {},
          //       child: SvgPicture.asset("assets/Camera Icon.svg"),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
