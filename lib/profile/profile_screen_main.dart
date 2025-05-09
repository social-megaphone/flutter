import 'package:flutter/material.dart';

class ProfileScreenMain extends StatefulWidget {
  const ProfileScreenMain({super.key});

  @override
  State<ProfileScreenMain> createState() => _ProfileScreenMainState();
}

class _ProfileScreenMainState extends State<ProfileScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      
    );
  }
}
