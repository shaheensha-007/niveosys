import 'dart:io';

import 'package:company/display_iteams.dart';
import 'package:company/main.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}
File? _image;
String street = '';
final picker = ImagePicker();

class _CameraState extends State<Camera> {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission denied');
    }
    return await Geolocator.getCurrentPosition();
  }

  String locationMessage = '';
  Position? currentPosition;

  String long = '';
  String lat = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation().then((position) {
      setState(() {
        currentPosition = position;
        lat = currentPosition!.latitude.toString();
        long = currentPosition!.longitude.toString();
      });
    }).catchError((e) {
      print(e);
    });
  }
  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      setState(() {
        street = place.street.toString() + "," + place.locality.toString();
      });

      print(
          "${place.street}, ${place.locality}, ${place.country},${place
              .subThoroughfare}");
      return "${place.street}, ${place.locality}";
    } catch (e) {
      print(e);
      return "";
    }
  }

    @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
     body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Padding(
      padding:  EdgeInsets.only(left: mwidth*0.08,top: mheight*0.05),

      child: Container(
        height:mheight*0.40,
        width: mwidth*0.85,
        decoration: BoxDecoration(
            border: Border.all()
        ),
        child: _image != null
            ? Image.file(
          _image!.absolute,
          fit: BoxFit.cover,
        )
            :Image.asset("assets/Zxscm.jpg")
      ),
    ),
     SizedBox(
       height: mheight*0.02,
     ),
     Center(
       child: GestureDetector(onTap: (){
         getAddressFromLatLng(currentPosition!);
         getCameraImage();
       },
         child: Container(
           height: mheight*0.08,
           width: mwidth*0.50,
           decoration: BoxDecoration(
             border: Border.all(),
             borderRadius: BorderRadius.circular(5),
             color: Colors.red
           ),
           child: Center(child: Text("Uploaed Image",style: TextStyle(color: Colors.white),)),
         ),
       ),
     ),
      Center(
        child: GestureDetector(onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>Display(lat: lat, long: long)));
        },
          child: Container(
          height: mheight*0.08,
          width: mwidth*0.50,
          decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
          color: Colors.red
          ),
          child: Center(child: Text("Next",style: TextStyle(color: Colors.white),)),
        )),
      )]
     )

    );
  }
  Future<void> getCameraImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        images.add(_image);
      } else {
        print('no image found');
      }
    });
  }
  @override
  void dispose() {
    _image = null;
    currentPosition = null;
    super.dispose();
  }
}
