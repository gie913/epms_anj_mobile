import 'package:syncfusion_flutter_maps/maps.dart';

class MarkerDetailModel {
  const MarkerDetailModel({
    this.latLng = const MapLatLng(0, 0),
    this.place = 'None',
  });

  final MapLatLng latLng;
  final String place;
}
