import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  var currentLocation = "".obs;
  var pincodeData = "".obs;
  var isAddressSelected = false.obs;
  var pincodeIsMatched = false.obs;
  Position? position;

  // var pincodeList = <Data>[].obs;
  RxBool isLoading = false.obs;
  var getAddress = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permission denied forever');
        }
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) {
          position = _position;
          update();
          print("Positon Gotted=====>${position}");
        }).catchError((e) {
          debugPrint(e);
        });
        print(
            'Location permission granted: ${position!.latitude} : ${position!.longitude}');
        await fetchLocationData(position!);
      } else {
        throw Exception('Location permission not granted');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  Future<void> fetchLocationData(Position position) async {
    try {
      String apiKey = 'ff9630d3e6664aad943a4c80ddc48cfe';
      String url =
          'https://api.opencagedata.com/geocode/v1/json?q=${position.latitude},${position.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentLocation.value = data['results'][0]['formatted'];
        pincodeData.value =
            await getAddressPincode(position.latitude, position.longitude);
        // pincodeData.value = '890230';
        print("fetched pincoded Value========>${pincodeData.value}");
      } else {
        print(
            'Failed to get location details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location data: $e');
    }
  }

  Future<String> getAddressPincode(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      getAddress.value =
          "${place.street},${place.locality},${place.country},${place.postalCode}";
      update();
      return place.postalCode ?? "";
    } catch (e) {
      print('Error fetching address: $e');
      return "";
    }
  }
}
