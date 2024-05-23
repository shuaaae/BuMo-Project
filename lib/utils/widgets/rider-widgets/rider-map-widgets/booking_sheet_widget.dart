import 'package:flutter/material.dart';

class BookingSheetWidget extends StatelessWidget {
  const BookingSheetWidget({
    super.key,
    required this.serviceType,
    required this.duration,
    required this.calculatedFare,
  });

  final String serviceType;
  final String duration;
  final double calculatedFare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 10,
          )
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/helmet.png',
                    height: 20,
                  ),
                  Text(
                    '  $serviceType  ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                ],
              ),
              Text(duration),
              Text(
                'P $calculatedFare',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Book'),
            ),
          ),
        ],
      ),
    );
  }
}
