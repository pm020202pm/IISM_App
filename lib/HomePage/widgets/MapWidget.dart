import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils.dart';
import '../../widgets/widgets.dart';
class MapWidget extends StatelessWidget {
  const MapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
          child: customText("Campus Map", 28, FontWeight.w600, dark? Colors.grey.shade100:Colors.grey.shade900, 1),
        ),
        Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            // border: Border.all(color: Colors.black),

          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(26.5085011950421, 80.23300520800755), // Initial map center
                initialZoom: 14.8,
                minZoom: 14,
                maxZoom: 16.8,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: [
                    customMarker("Cricket Ground", const LatLng(26.509565227578577, 80.23389602086334)),
                    customMarker("Volleyball Court", const LatLng(26.508439967844815, 80.23187591524409)),
                    customMarker("Football Ground", const LatLng(26.506224127688213, 80.22945615864042)),
                    customMarker("Hockey Ground", const LatLng(26.506052791302025, 80.23025579226483)),
                    customMarker("Basketball Court", const LatLng(26.5085011950421, 80.23300520800755)),
                    customMarker("Health Center", const LatLng(26.505202229402357, 80.2338527308791)),
                    customMarker("Lawn Tennis Court", const LatLng(26.509668447573063, 80.23009338292336)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


}
void openGoogleMaps(double latitude, double longitude) async {
  final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl));
  } else {
    throw 'Could not open Google Maps';
  }
}

Marker customMarker(String label, LatLng point){
  return Marker(
    width: 100.0,
    height: 80.0,
    point: point, // Example location
    child: Column(
      // alignment: Alignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: InkWell(
              onTap: () => openGoogleMaps(point.latitude, point.longitude),
                child: Text(label, style: TextStyle(color: Colors.blue.shade600, fontSize: 9.0)))),
        const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 20.0,
        ),
      ],
    ),
  );
}
