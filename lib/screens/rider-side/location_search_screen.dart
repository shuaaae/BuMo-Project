import 'package:angkas_clone_app/models/autocomplete_prediction.dart';
import 'package:angkas_clone_app/providers/booking_provider.dart';
import 'package:angkas_clone_app/providers/focused_field_notifier.dart';
import 'package:angkas_clone_app/providers/place_predictions_provider.dart';
import 'package:angkas_clone_app/utils/functions/place_auto_complete.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/location-search-widgets/choose_from_map_button.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/location-search-widgets/my_current_location_option.dart';
import 'package:angkas_clone_app/utils/widgets/rider-side-widgets/place_predictions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placePredictionsProvider = StateNotifierProvider<PlacePredictionsNotifier,
    List<AutocompletePrediction>>((ref) {
  return PlacePredictionsNotifier([]);
});

final focusedFieldProvider =
    StateNotifierProvider<FocusedFieldNotifier, bool>((ref) {
  return FocusedFieldNotifier();
});

class LocationSearchScreen extends ConsumerWidget {
  final List<AutocompletePrediction> placePredictions = [];
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  LocationSearchScreen({super.key});

  void searchPlace(String query, bool isPickup, WidgetRef ref) {
    placeAutocomplete(query, isPickup, (predictions) {
      ref
          .read(placePredictionsProvider.notifier)
          .updatePredictions(predictions);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);
    // pickupController.text = bookingState?.pickupLocation?.name ?? '';
    // destinationController.text = bookingState?.destinationLocation?.name ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: pickupController,
                    onChanged: (value) {
                      searchPlace(value, true, ref);
                    },
                    onTap: () {
                      ref
                          .read(focusedFieldProvider.notifier)
                          .updateFocusedField(true);
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Pick up from?",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          // ignore: deprecated_member_use
                          color: Colors.white,
                          "assets/icons/location_pin.svg",
                          height: 19,
                          width: 19,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  indent: 55,
                  endIndent: 55,
                  height: 1,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (value) {
                      searchPlace(value, false, ref);
                    },
                    onTap: () {
                      ref
                          .read(focusedFieldProvider.notifier)
                          .updateFocusedField(false);
                    },
                    controller: destinationController,
                    textInputAction: TextInputAction.search,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Drop off to?",
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.red,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          const MyCurrentLocationOption(),
          PlacePredictionsList(
            pickupController: pickupController,
            destinationController: destinationController,
          )
        ],
      ),
      floatingActionButton: const ChooseFromMapButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
