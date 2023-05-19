import 'package:epms/base/ui/style.dart';
import 'package:epms/model/laporan_spb_kemarin.dart';
import 'package:flutter/material.dart';

class DetailSPBKemarinScreen extends StatefulWidget {
  final LaporanSPBKemarin laporanSPBKemarin;

  const DetailSPBKemarinScreen({Key? key, required this.laporanSPBKemarin})
      : super(key: key);

  @override
  State<DetailSPBKemarinScreen> createState() => _DetailSPBKemarinScreenState();
}

class _DetailSPBKemarinScreenState extends State<DetailSPBKemarinScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: Style.mediaQueryText(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detail SPB Kemarin"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ID OPH:"),
                    Text(
                      "${widget.laporanSPBKemarin.spbId ?? ""}",
                      style: Style.textBold16,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tanggal:"),
                    Text(
                        "${widget.laporanSPBKemarin.createdDate} ${widget.laporanSPBKemarin.createdTime}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("GPS Geolocation:"),
                    Text(
                        "${widget.laporanSPBKemarin.spbLat}, ${widget.laporanSPBKemarin.spbLong}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jenis Pengangkutan:"),
                    Text("${widget.laporanSPBKemarin.spbType}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estate:"),
                    Text("${widget.laporanSPBKemarin.spbEstateCode}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tujuan:"),
                    Text(
                        "${widget.laporanSPBKemarin.spbDeliverToCode}, ${widget.laporanSPBKemarin.spbDeliverToName}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pekerja:"),
                    Text("${widget.laporanSPBKemarin.spbDriverEmployeeCode}"),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("No. Kendaraan"),
                      SizedBox(height: 20),
                      Text(
                        "${widget.laporanSPBKemarin.spbLicenseNumber}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text("Kartu SPB"),
                      SizedBox(height: 20),
                      Text("${widget.laporanSPBKemarin.spbCardId}",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total OPH:"),
                    Text("${widget.laporanSPBKemarin.spbTotalOph}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total janjang:"),
                    Text("${widget.laporanSPBKemarin.spbTotalBunches}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total brondolan (kg):"),
                    Text("${widget.laporanSPBKemarin.spbTotalLooseFruit}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Estimasi berat (kg):"),
                    Text("${widget.laporanSPBKemarin.spbEstimateTonnage}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sisa kapasitas truk (kg):"),
                    Text("${widget.laporanSPBKemarin.spbCapacityTonnage}")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Berat aktual (Kg):"),
                    Text("${widget.laporanSPBKemarin.spbActualTonnage}")
                  ],
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Text("Catatan (50)"),
                  Text("${widget.laporanSPBKemarin.spbDeliveryNote ?? ""}")
                ],
              ),
              SizedBox(height: 20),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Card(
              //       color: Palette.redColorDark,
              //       elevation: 2,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       child: Container(
              //         alignment: Alignment.center,
              //         padding: EdgeInsets.all(14),
              //         child: Text(
              //           "KEMBALI",
              //           style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.white),
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ]),
          ),
        ),
      ),
    );
  }
}
