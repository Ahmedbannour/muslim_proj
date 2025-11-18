import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Constants.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;

  static const LatLng _initialPosition = LatLng(35.777, 10.826); // Monastir 🇹🇳

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KPrimaryColor,
        bottomOpacity: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: SvgPicture.asset(
                "assets/icons/angle-left (1).svg",
                color: Colors.white,
                width: 15,
                height: 15,
                excludeFromSemantics: true,
                allowDrawingOutsideViewBox: true,
                matchTextDirection: true,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // change your color here
        ),
        title: Text(
          "Localisation",
          style: TextStyle(
              fontFamily: 'OpenSansBold',
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.logout_outlined,
              ),
              onPressed: () {

              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: (LatLng position) async{
                setState(() {
                  _selectedPosition = position;
                });



                if (position != null && position is LatLng) {
                  // 🔍 Convertir les coordonnées en adresse
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    position.latitude,
                    position.longitude,
                  );

                  print("location : ${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}");
                }
              },
              markers: _selectedPosition == null ? {} : {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedPosition!,
                ),
              },
            ),
            if (_selectedPosition != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Confirmer cette localisation",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, _selectedPosition);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
