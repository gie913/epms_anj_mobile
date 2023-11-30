import 'package:epms/base/ui/palette.dart';
import 'package:flutter/material.dart';

final List<String> harvesterMenuEntries = <String>[
  'ABSENSI',
  'BUAT FORM OPH',
  'RIWAYAT OPH',
  'BACA KARTU OPH',
  'RENCANA PANEN HARI INI',
  'LAPORAN PANEN HARIAN',
  'LAPORAN RESTAN HARI INI',
  'ADMINISTRASI OPH',
  'UPLOAD DATA',
  'KELUAR'
];

final List<String> administrationOPHMenuEntries = <String>[
  'UBAH DATA OPH',
  'GANTI OPH HILANG',
  'BAGI OPH',
  'KEMBALI'
];

final List<Color> colorCodesAdministrationOPH = <Color>[
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.redColorLight
];

final List<String> administrationSPBMenuEntries = <String>[
  'UBAH DATA SPB',
  'GANTI SPB HILANG',
  'GANTI OPH HILANG',
  'KEMBALI'
];

final List<Color> colorCodesAdministrationSPB = <Color>[
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.redColorLight
];

final List<String> deliveryMenuEntries = <String>[
  'BACA KARTU OPH',
  'BUAT FORM SPB',
  'RIWAYAT SPB',
  'BACA KARTU SPB',
  'LAPORAN SPB KEMARIN',
  'LAPORAN RESTAN HARI INI',
  'ADMINISTRASI SPB',
  'UPLOAD DATA',
  'KELUAR'
];

final List<String> supervisorMenuEntries = <String>[
  'SUPERVISI PANEN',
  'SUPERVISI ANCAK PANEN',
  'BACA KARTU OPH',
  'BACA KARTU SPB',
  'LAPORAN SUPERVISI PANEN',
  'LAPORAN SUPERVISI ANCAK PANEN',
  'LAPORAN RESTAN HARI INI',
  'LAPORAN PANEN HARIAN',
  'RENCANA PANEN HARI INI',
  'LIHAT WORKPLAN',
  'UPLOAD DATA',
  'KELUAR'
];

final List<String> supervisorSPBMenuEntries = <String>[
  'SUPERVISI SPB',
  // 'SUPERVISI TBS LUAR',
  'HISTORY GRADING TBS LUAR',
  'HISTORY SUPERVISI SPB',
  'BACA KARTU SPB',
  'BACA KARTU TBS LUAR',
  // 'INSPECTION',
  'UPLOAD DATA',
  'KELUAR'
];

final List<Color> colorCodesDelivery = <Color>[
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.yellowColorDark,
  Colors.green,
  Palette.redColorLight
];

final List<Color> colorCodesHarvester = <Color>[
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.yellowColorDark,
  Colors.green,
  Palette.redColorLight
];

final List<Color> colorCodesSupervisor = <Color>[
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Colors.green,
  Palette.redColorLight
];

final List<Color> colorCodesSupervisorSPB = <Color>[
  Palette.primaryColorProd,
  // Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Palette.primaryColorProd,
  Colors.green,
  Palette.redColorLight
];
