import 'package:flutter/material.dart';

class MyCurrentLocationOption extends StatelessWidget {
  const MyCurrentLocationOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Row(
            children: [
              Icon(
                Icons.my_location,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Use My Current Location",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold))
            ],
          ),
        ));
  }
}
