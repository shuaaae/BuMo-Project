import 'package:flutter/material.dart';

class CustomSelectionDialog extends StatelessWidget {
  final Function(String) onSelection;
  const CustomSelectionDialog({super.key, required this.onSelection});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi! Anong Trip Natin?",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontSize: 24),
            ),
            Text(
              "Select a user Type",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        contentPadding: const EdgeInsets.all(0),
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.white,
        content: Container(
          height: 200,
          width: 350,
          margin: const EdgeInsets.only(top: 15),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(224, 245, 253, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  onSelection("passenger");
                },
                borderRadius: BorderRadius.circular(25),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/icons/icons8-passenger-96.png',
                      width: 100,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Passenger",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 18),
                        ),
                        Text(
                          "Safely Ride a motorcycle Taxi",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onSelection("driver");
                },
                borderRadius: BorderRadius.circular(25),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/icons/icons8-driver-96.png',
                      width: 100,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Driver",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontSize: 18),
                        ),
                        Text(
                          "Driver Passengers \nto their Destination",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
