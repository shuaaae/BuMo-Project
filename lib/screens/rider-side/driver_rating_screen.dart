import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/screens/rider-side/rider_maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverRatingScreen extends ConsumerWidget {
  const DriverRatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            bookingState.updateBooking(
              pickupLocation: null,
              destinationLocation: null,
              pricing: null,
            );

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => RiderMapsScreen()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How was your biker?",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      AssetImage('assets/images/angkas_d2_zoom.png'),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Divider(
              indent: 5,
              endIndent: 5,
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Yay! Let your biker know what you liked.",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Share your compliments (Optional)",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            SizedBox(
              height: 15,
            ),
            const Divider(
              indent: 5,
              endIndent: 5,
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Final Fare",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "P56.00",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            const Divider(
              indent: 5,
              endIndent: 5,
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Method",
                    style: Theme.of(context).textTheme.bodyLarge),
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.money,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        "Cash",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
