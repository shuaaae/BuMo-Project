import 'package:angkas_clone_app/screens/registration/number_verification_screen.dart';
import 'package:angkas_clone_app/utils/widgets/navigation_drawer.dart';
import 'package:angkas_clone_app/utils/widgets/ride_booking_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PassengerMapScreen extends ConsumerWidget {
  const PassengerMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountNotifier = ref.watch(accountProvider.notifier);

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                    weight: 50,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
          ),
        ),
        drawer: const CustomNavigationDrawer(),
        body: Stack(children: [
          const RideBookingWidgets(),
        ]));
  }
}
