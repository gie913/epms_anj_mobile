import 'package:epms/database/service/database_m_block.dart';
import 'package:epms/database/service/database_m_tph.dart';
import 'package:epms/database/service/database_m_vra.dart';
import 'package:epms/database/service/database_mc_oph.dart';
import 'package:epms/database/service/database_mc_spb.dart';
import 'package:epms/database/service/database_oph.dart';
import 'package:epms/database/service/database_spb.dart';
import 'package:epms/model/m_block_schema.dart';
import 'package:epms/model/m_c_oph_card_schema.dart';
import 'package:epms/model/m_c_spb_card_schema.dart';
import 'package:epms/model/m_customer_code_schema.dart';
import 'package:epms/model/m_division_schema.dart';
import 'package:epms/model/m_employee_schema.dart';
import 'package:epms/model/m_tph_schema.dart';
import 'package:epms/model/m_vendor_schema.dart';
import 'package:epms/model/m_vras_schema.dart';
import 'package:epms/model/oph.dart';
import 'package:epms/model/spb.dart';
import 'package:flutter/cupertino.dart';

class ValidationService {
  static bool checkIsNull(TextEditingController textEditingController) {
    if (textEditingController.text.isNotEmpty) return true;
    return false;
  }

  static bool checkEmployee(MEmployeeSchema? mEmployeeSchema) {
    if (mEmployeeSchema != null) return true;
    return false;
  }

  static Future<MBlockSchema?> checkBlockSchema(
      String blockCode, String estateCode) async {
    MBlockSchema? mBlockSchema = await DatabaseMBlockSchema()
        .selectMBlockSchemaByID(blockCode, estateCode);
    return mBlockSchema;
  }

  static Future<MTPHSchema?> checkMTPHSchema(String tphCode, String estateCode, String blokCode) async {
    MTPHSchema? mtphSchema =
        await DatabaseMTPHSchema().selectMTPHSchemaByID(tphCode, estateCode, blokCode);
    return mtphSchema;
  }

  static Future<MCOPHCardSchema?> checkMCOPHCardSchema(String ophCardID) async {
    MCOPHCardSchema? mcophCardSchema =
        await DatabaseMCOPHSchema().selectMCOPHSchemaByID(ophCardID);
    return mcophCardSchema;
  }

  static Future<MCSPBCardSchema?> checkMCSPBCardSchema(String spbCardID) async {
    MCSPBCardSchema? mcspbCardSchema =
        await DatabaseMCSPBCardSchema().selectMCSPBCardSchema(spbCardID);
    return mcspbCardSchema;
  }

  static bool checkGrading(String totalJanjang, String brondolan) {
    if (totalJanjang == "0" || brondolan == "0") return true;
    return false;
  }

  static bool checkCustomerSchema(MCustomerCodeSchema? mCustomerCodeSchema) {
    if (mCustomerCodeSchema != null) return true;
    return false;
  }

  static bool checkDivision(MDivisionSchema? mDivisionSchema) {
    if (mDivisionSchema != null) return true;
    return false;
  }

  static bool checkVendor(MVendorSchema? mVendorSchema) {
    if (mVendorSchema != null) return true;
    return false;
  }

  static Future<OPH?> checkOPHExist(String ophID) async {
    OPH? oph = await DatabaseOPH().selectOPHByID(ophID);
    return oph;
  }

  static Future<SPB?> checkSPBExist(String spbID) async {
    SPB? spb = await DatabaseSPB().selectSPBByID(spbID);
    return spb;
  }

  static Future<MVRASchema?> checkMVRA(String number) async {
    MVRASchema? mvraSchema =
        await DatabaseMVRASchema().selectMVRASchemaByNumber(number);
    return mvraSchema;
  }
}
