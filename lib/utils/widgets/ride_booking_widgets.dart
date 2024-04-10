import 'package:angkas_clone_app/utils/constants/box_shadow.dart';
import 'package:flutter/material.dart';

class RideBookingWidgets extends StatelessWidget {
  const RideBookingWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [kBoxShadow]),
                  child: Center(
                      child: Text(
                    'REMINDERS',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w400),
                  )),
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 40,
                    width: 40,
                    decoration: (BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [kBoxShadow])),
                    child: Center(
                      child: Icon(
                        Icons.location_searching_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 140,
            width: 375,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [kBoxShadow]),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            weight: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Current Location",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.2,
                        indent: 34,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            weight: 10,
                            color: Color.fromRGBO(251, 112, 62, 1),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Drop off to?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_atm,
                          color: Theme.of(context).primaryColor,
                        ),
                        const Text("Cash"),
                        const SizedBox(
                          width: 10,
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                        ),
                        const Icon(
                          Icons.local_activity,
                          color: Colors.grey,
                        ),
                        const Text("Promo"),
                        const VerticalDivider(
                          color: Colors.grey,
                        ),
                        Icon(Icons.text_snippet_outlined,
                            color: Theme.of(context).primaryColor),
                        const Text("Notes to Biker")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                boxShadow: [kBoxShadow]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImageIcon(
                            const AssetImage(
                              'assets/icons/helmet.png',
                            ),
                            size: 25,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Passenger',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "PHP 0.00",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).primaryColor),
                  child: Center(
                    child: Text(
                      "Book",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
