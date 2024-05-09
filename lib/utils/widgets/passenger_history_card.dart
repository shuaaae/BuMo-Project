import 'package:flutter/material.dart';

class PassengerHistoryCard extends StatelessWidget {
  const PassengerHistoryCard({
    super.key,
    required this.status,
    required this.destination,
    required this.price,
    required this.startTime,
  });

  final String destination;
  final double price;
  final String startTime;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.all(15),
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.white),
      child: (Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageIcon(
            const AssetImage(
              'assets/icons/helmet.png',
            ),
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Passenger",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    status
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Cancelled",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Completed",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To $destination",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Text(
                      '$price',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                Text(
                  startTime,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
