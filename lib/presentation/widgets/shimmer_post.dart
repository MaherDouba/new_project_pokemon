import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 231, 215, 245),
        highlightColor: Color.fromARGB(255, 145, 214, 231),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: MediaQuery.of(context).size.width * 0.5,  
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
           
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                 width: MediaQuery.of(context).size.width * 0.5,  
                 height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
