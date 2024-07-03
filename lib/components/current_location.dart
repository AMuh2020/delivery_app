import 'package:delivery_app/main.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  
  // address
  String? _address;

  final addressInstance = AddressModel.instance;

  TextEditingController _addressController = TextEditingController();

  // get the current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled. Don't continue
      // accessing the position and inform the user.
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 
    // set _address to loading
    setState(() {
      _address = "Loading...";
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    prefs.setStringList('lat_long', [position.latitude.toString(), position.longitude.toString()]);
    // use geocoder to get the address
    final placemarks = await getPlacemark(position.latitude, position.longitude);
    print(placemarks);

    setState(() {
      _address = placemarks[0].street.toString();
      _addressController.text = _address!;
      addressInstance.setAddress(_address!);
    });
  }
  Future<List<Placemark>> getPlacemark(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks;
  }
  Future<void> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> latLong;
    try {
      latLong = prefs.getStringList('lat_long')!;
    } catch (e) {
      // Handle the exception, e.g., log the error or set a default value
      print('Error fetching lat_long: $e');
      return;
    }
    
    double lat = double.parse(latLong[0]);
    double long = double.parse(latLong[1]);
    final placemarks = await getPlacemark(lat, long);
    setState(() {
      _address = placemarks[0].street.toString();
      _addressController.text = _address!;
      addressInstance.setAddress(_address!);
    });
  }

  @override
  void initState() {
    super.initState();
    print("init state");
    print("Address: ${addressInstance.address}");
    // check if address from the singleton is not null
    if (addressInstance.address != null) {
      print("Address is not null");
      _address = addressInstance.address;
      _addressController.text = _address!;
      print(_address);
    } else {
      getAddress();
    }
  }

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Your location"),
        content: TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: "Enter your location",
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              _getCurrentLocation();
              Navigator.pop(context);
            },
            child: Text("Get current location"),
          ),
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          // save button
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _address = _addressController.text;
                addressInstance.setAddress(_address!);
              });
            },
            child: Text("Save"),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver now",
            style: TextStyle(
              // color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                // address
                Text(
                  "${_address ?? 'Click here to input address'}",
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
                //drop down menu
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  // color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}