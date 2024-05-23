import 'package:angkas_clone_app/screens/rider-side/location_search_screen.dart';
import 'package:angkas_clone_app/utils/widgets/custom_selection_widget.dart';
import 'package:flutter/material.dart';

class BookingDetailsWidget extends StatelessWidget {
  const BookingDetailsWidget({
    super.key,
    required this.pickupController,
    required this.destinationController,
  });

  final TextEditingController pickupController;
  final TextEditingController destinationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationSearchScreen()));
            },
            child: Column(
              children: [
                AbsorbPointer(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.adjust,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                                width:
                                    8), // Add some space between icon and text field
                            Expanded(
                              child: TextFormField(
                                controller: pickupController,
                                style: const TextStyle(fontSize: 15),
                                readOnly: true,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Pick up from?',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color.fromARGB(255, 255, 102, 0),
                            ),
                            const SizedBox(
                                width:
                                    8), // Add some space between icon and text field
                            Expanded(
                              child: TextFormField(
                                controller: destinationController,
                                readOnly: true,
                                maxLines: null,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Drop off to?',
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 15),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomSelectionWidget(
                  image: 'assets/images/helmet.png',
                  text: ' Cash',
                ),
                Container(
                  height: 15.0,
                  width: 2.0,
                  color: const Color.fromARGB(77, 29, 28, 28),
                  padding: const EdgeInsets.only(right: 3.0),
                ),
                const CustomSelectionWidget(
                  image: 'assets/images/helmet.png',
                  text: ' Promo',
                ),
                Container(
                  height: 15.0,
                  width: 2.0,
                  color: const Color.fromARGB(77, 29, 28, 28),
                  padding: const EdgeInsets.only(right: 3.0),
                ),
                const CustomSelectionWidget(
                  image: 'assets/images/helmet.png',
                  text: ' Notes',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
