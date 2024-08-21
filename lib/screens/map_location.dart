///
/// AVANCED EXAMPLE:
/// Screen with map and search box on top. When the user selects a place through autocompletion,
/// the screen is moved to the selected location, a path that demonstrates the route is created, and a "start route"
/// box slides in to the screen.
///

import 'dart:async';

import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class MapLocation extends StatefulWidget {
  MapLocation({Key? key, this.address}) : super(key: key);
  var address;

  @override
  State<MapLocation> createState() => MapLocationState();
}

class MapLocationState extends State<MapLocation>
    with SingleTickerProviderStateMixin {
  PickResult? selectedPlace;
  static LatLng kInitialPosition = LatLng(
      51.52034098371205, -0.12637399200000668); // Default fallback location

  GoogleMapController? _controller;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    setState(() {});
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    return status.isGranted;
  }

  Future<LatLng> _getCurrentLocation() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      return kInitialPosition; // Fallback to default position if permission is not granted
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();

    if (widget.address.location_available) {
      setInitialLocation();
    } else {
      setCurrentLocationAsInitial();
    }
  }

  void setInitialLocation() {
    kInitialPosition = LatLng(widget.address.lat, widget.address.lang);
    setState(() {});
  }

  void setCurrentLocationAsInitial() async {
    kInitialPosition = await _getCurrentLocation();
    if (mounted) setState(() {});
  }

  // onTapPickHere and other methods remain the same
  onTapPickHere(selectedPlace) async {
    var addressUpdateLocationResponse = await AddressRepository()
        .getAddressUpdateLocationResponse(
            widget.address.id,
            selectedPlace.geometry.location.lat,
            selectedPlace.geometry.location.lng);

    if (addressUpdateLocationResponse.result == false) {
      ToastComponent.showDialog(addressUpdateLocationResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressUpdateLocationResponse.message,
        gravity: Toast.center, duration: Toast.lengthLong);
  }

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      hintText: AppLocalizations.of(context)!.your_delivery_location,
      apiKey: OtherConfig.GOOGLE_MAP_API_KEY,
      initialPosition: kInitialPosition,
      useCurrentLocation: false,
      onPlacePicked: (result) {
        selectedPlace = result;
        setState(() {});
      },
      selectedPlaceWidgetBuilder:
          (_, selectedPlace, state, isSearchBarFocused) {
        return isSearchBarFocused
            ? Container()
            : FloatingCard(
                height: 50,
                bottomPosition: 120.0,
                leftPosition: 0.0,
                rightPosition: 0.0,
                width: 500,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: state == SearchingState.Searching
                    ? Center(
                        child: Text(
                        AppLocalizations.of(context)!.calculating,
                        style: TextStyle(color: MyTheme.font_grey),
                      ))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2.0, right: 2.0),
                                    child: Text(
                                      selectedPlace!.formattedAddress!,
                                      maxLines: 2,
                                      style:
                                          TextStyle(color: MyTheme.medium_grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Btn.basic(
                                color: MyTheme.accent_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  bottomLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0),
                                )),
                                child: Text(
                                  AppLocalizations.of(context)!.pick_here,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  onTapPickHere(selectedPlace);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              );
      },
      pinBuilder: (context, state) {
        return Image.asset(
          'assets/delivery_map_icon.png',
          height: state == PinState.Idle ? 60 : 80,
        );
      },
    );
  }
}
