import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;
  MapPage({super.key, required this.latitude, required this.longitude, required this.title});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _googleMapController;
  late Marker _origin;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng pos = LatLng(widget.latitude, widget.longitude);
    final CameraPosition initialCameraPosition = CameraPosition(target: pos);
    final Marker marker = Marker(
      position: pos,
      markerId: MarkerId(widget.title),
      infoWindow: InfoWindow(title: widget.title)
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Location on Map')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {marker},
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(initialCameraPosition)
              ),
              icon: const Icon(Icons.center_focus_strong, color: Colors.white),
              label: const Text('Recenter', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      )
    );
  }
}
