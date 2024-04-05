import 'package:angkas_clone_app/widgets/location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({Key? key}) : super(key: key);

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: SvgPicture.asset(
              "assets/icons/location.svg",
              height: 16,
              width: 16,
            ),
          ),
        ),
        title: const Text(
          "Set Delivery Location",
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.black,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {},
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search your location",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset(
                      "assets/icons/location_pin.svg",
                      height: 19,
                      width: 19,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/location.svg",
                height: 16,
              ),
              label: const Text("Use my Current Location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.grey,
                elevation: 0,
                fixedSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Colors.grey,
          ),
          LocationListTile(
            press: () {},
            location: "Banasree, Dhaka, Bangladesh",
          ),
        ],
      ),
    );
  }
}
