import 'dart:developer';

import 'package:epms/base/ui/style.dart';
import 'package:epms/common_manager/location_service.dart';
// import 'package:epms/model/marker_detail_model.dart';
import 'package:epms/model/marker_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class InspectionLocationView extends StatefulWidget {
  const InspectionLocationView({
    super.key,
    this.longitude = 0,
    this.latitude = 0,
    this.company = '',
  });

  final double longitude;
  final double latitude;
  final String company;

  @override
  State<InspectionLocationView> createState() => _InspectionLocationViewState();
}

class _InspectionLocationViewState extends State<InspectionLocationView> {
  MapShapeSource? _shapeSource;
  List<MarkerModel> _data = [];

  // List<MarkerDetailModel> _dataDetail = [];
  MapZoomPanBehavior? _zoomPanBehavior;

  double longitude = 0;
  double latitude = 0;

  List<MapLatLng> polyline = [];
  List<List<MapLatLng>> polylines = [];

  @override
  void initState() {
    getLocation();

    // _zoomPanBehavior = MapZoomPanBehavior(
    //   focalLatLng: MapLatLng(
    //     widget.latitude,
    //     widget.longitude,
    //   ),
    //   zoomLevel: 5,
    // );

    // _dataDetail = [
    //   MarkerDetailModel(
    //     latLng: MapLatLng(widget.latitude, widget.longitude),
    //     place: 'None',
    //   ),
    // ];

    // _data = [
    //   MarkerModel('None', widget.latitude, widget.longitude),
    // ];

    // _shapeSource = MapShapeSource.asset(
    //   'assets/indonesia.json',
    //   shapeDataField: 'state',
    //   dataCount: _data.length,
    //   primaryValueMapper: (index) {
    //     return _data[index].country;
    //   },
    // );

    // polyline = <MapLatLng>[
    //   MapLatLng(widget.latitude, widget.longitude),
    //   MapLatLng(latitude, longitude),
    // ];
    // polylines = <List<MapLatLng>>[polyline];

    super.initState();
  }

  Future<void> getLocation() async {
    var position = await LocationService.getGPSLocation();
    if (position != null) {
      longitude = position.longitude;
      latitude = position.latitude;
    }
    log('cek my location : longitude = $longitude, latitude = $latitude');
    setState(() {});

    _zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: MapLatLng(
        widget.latitude,
        widget.longitude,
      ),
      zoomLevel: 5,
      enableDoubleTapZooming: true,
    );

    // _dataDetail = [
    //   MarkerDetailModel(
    //     latLng: MapLatLng(widget.latitude, widget.longitude),
    //     place: 'Inspection Location',
    //   ),
    //   MarkerDetailModel(
    //     latLng: MapLatLng(latitude, longitude),
    //     place: 'My Location',
    //   ),
    // ];

    _data = [
      MarkerModel('Inspection Location', widget.latitude, widget.longitude),
      MarkerModel('My Location', latitude, longitude),
    ];

    _shapeSource = MapShapeSource.asset(
      'assets/smm.json',
      shapeDataField: 'name',
      dataCount: _data.length,
      primaryValueMapper: (index) {
        return _data[index].country;
      },
    );

    polyline = <MapLatLng>[
      MapLatLng(widget.latitude, widget.longitude),
      MapLatLng(latitude, longitude),
    ];
    polylines = <List<MapLatLng>>[polyline];
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inspection Location'),
        ),
        body: _shapeSource != null
            ? SfMaps(
                layers: [
                  MapShapeLayer(
                    source: _shapeSource!,
                    zoomPanBehavior: _zoomPanBehavior,
                    initialMarkersCount: _data.length,
                    markerBuilder: (context, index) {
                      return MapMarker(
                        latitude: _data[index].latitude,
                        longitude: _data[index].longitude,
                        child: Icon(
                          Icons.location_on,
                          color: _data[index].country == 'My Location'
                              ? Colors.green
                              : Colors.red,
                        ),
                      );
                    },
                    sublayers: [
                      MapPolylineLayer(
                        polylines: List<MapPolyline>.generate(
                          polylines.length,
                          (int index) {
                            return MapPolyline(
                              points: polylines[index],
                              color: Colors.blue,
                              strokeCap: StrokeCap.round,
                              width: 2,
                            );
                          },
                        ).toSet(),
                      ),
                    ],
                  ),
                  // MapTileLayer(
                  //   urlTemplate:
                  //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  //   zoomPanBehavior: _zoomPanBehavior,
                  //   initialMarkersCount: _dataDetail.length,
                  //   markerBuilder: (context, index) {
                  //     return MapMarker(
                  //       latitude: _dataDetail[index].latLng.latitude,
                  //       longitude: _dataDetail[index].latLng.longitude,
                  //       child: Icon(
                  //         Icons.location_on,
                  //         color: _dataDetail[index].place == 'My Location'
                  //             ? Colors.green
                  //             : Colors.red,
                  //       ),
                  //     );
                  //   },
                  //   sublayers: [
                  //     MapPolylineLayer(
                  //       polylines: List<MapPolyline>.generate(
                  //         polylines.length,
                  //         (int index) {
                  //           return MapPolyline(
                  //             points: polylines[index],
                  //             color: Colors.blue,
                  //             strokeCap: StrokeCap.round,
                  //             width: 2,
                  //           );
                  //         },
                  //       ).toSet(),
                  //     ),
                  //   ],
                  // ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
