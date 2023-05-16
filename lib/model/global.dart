import 'm_activity_schema.dart';
import 'm_attendance_schema.dart';
import 'm_block_schema.dart';
import 'm_c_oph_card_schema.dart';
import 'm_c_spb_card_schema.dart';
import 'm_config_schema.dart';
import 'm_cost_control_schema.dart';
import 'm_customer_code_schema.dart';
import 'm_destination_schema.dart';
import 'm_division_schema.dart';
import 'm_employee_schema.dart';
import 'm_estate_schema.dart';
import 'm_material_schema.dart';
import 'm_tph_schema.dart';
import 'm_vendor_schema.dart';
import 'm_vras_schema.dart';
import 'role_schema.dart';
import 't_attendance_schema.dart';
import 't_user_assignment_schema.dart';

class Global {
  List<MEstateSchema>? mEstateSchema;
  List<MDivisionSchema>? mDivisionSchema;
  List<MBlockSchema>? mBlockSchema;
  List<MTPHSchema>? mTPHSchema;
  List<MEmployeeSchema>? mEmployeeSchema;
  List<MVendorSchema>? mVendorSchema;
  List<MCustomerCodeSchema>? mCustomerCodeSchema;
  List<TUserAssignmentSchema>? tUserAssignmentSchema;
  List<MActivitySchema>? mActivitySchema;
  List<MCostControlSchema>? mCostControlSchema;
  List<MMaterialSchema>? mMaterialSchema;
  List<MCOPHCardSchema>? mCOPHCardSchema;
  List<MCSPBCardSchema>? mCSPBCardSchema;
  List<MDestinationSchema>? mDestinationSchema;
  List<MVRASchema>? mVRASchema;
  List<MConfigSchema>? mConfigSchema;
  List<RolesSchema>? rolesSchema;
  List<MAttendanceSchema>? mAttendanceSchema;
  List<TAttendanceSchema>? tAttendanceSchema;

  Global(
      {this.mEstateSchema,
      this.mDivisionSchema,
      this.mBlockSchema,
      this.mTPHSchema,
      this.mEmployeeSchema,
      this.mVendorSchema,
      this.mCustomerCodeSchema,
      this.tUserAssignmentSchema,
      this.mActivitySchema,
      this.mCostControlSchema,
      this.mMaterialSchema,
      this.mCOPHCardSchema,
      this.mCSPBCardSchema,
      this.mDestinationSchema,
      this.mVRASchema,
      this.mConfigSchema,
      this.rolesSchema,
      this.mAttendanceSchema,
      this.tAttendanceSchema});

  Global.fromJson(Map<String, dynamic> json) {
    if (json['M_Estate_Schema'] != null) {
      mEstateSchema = <MEstateSchema>[];
      json['M_Estate_Schema'].forEach((v) {
        mEstateSchema!.add(new MEstateSchema.fromJson(v));
      });
    }
    if (json['M_Division_Schema'] != null) {
      mDivisionSchema = <MDivisionSchema>[];
      json['M_Division_Schema'].forEach((v) {
        mDivisionSchema!.add(new MDivisionSchema.fromJson(v));
      });
    }
    if (json['M_Block_Schema'] != null) {
      mBlockSchema = <MBlockSchema>[];
      json['M_Block_Schema'].forEach((v) {
        mBlockSchema!.add(new MBlockSchema.fromJson(v));
      });
    }
    if (json['M_TPH_Schema'] != null) {
      mTPHSchema = <MTPHSchema>[];
      json['M_TPH_Schema'].forEach((v) {
        mTPHSchema!.add(new MTPHSchema.fromJson(v));
      });
    }
    if (json['M_Employee_Schema'] != null) {
      mEmployeeSchema = <MEmployeeSchema>[];
      json['M_Employee_Schema'].forEach((v) {
        mEmployeeSchema!.add(new MEmployeeSchema.fromJson(v));
      });
    }
    if (json['M_Vendor_Schema'] != null) {
      mVendorSchema = <MVendorSchema>[];
      json['M_Vendor_Schema'].forEach((v) {
        mVendorSchema!.add(new MVendorSchema.fromJson(v));
      });
    }
    if (json['M_Customer_Code_Schema'] != null) {
      mCustomerCodeSchema = <MCustomerCodeSchema>[];
      json['M_Customer_Code_Schema'].forEach((v) {
        mCustomerCodeSchema!.add(new MCustomerCodeSchema.fromJson(v));
      });
    }
    if (json['T_User_Assignment_Schema'] != null) {
      tUserAssignmentSchema = <TUserAssignmentSchema>[];
      json['T_User_Assignment_Schema'].forEach((v) {
        tUserAssignmentSchema!.add(new TUserAssignmentSchema.fromJson(v));
      });
    }
    if (json['M_Activity_Schema'] != null) {
      mActivitySchema = <MActivitySchema>[];
      json['M_Activity_Schema'].forEach((v) {
        mActivitySchema!.add(new MActivitySchema.fromJson(v));
      });
    }
    if (json['M_Cost_Control_Schema'] != null) {
      mCostControlSchema = <MCostControlSchema>[];
      json['M_Cost_Control_Schema'].forEach((v) {
        mCostControlSchema!.add(new MCostControlSchema.fromJson(v));
      });
    }
    if (json['M_Material_Schema'] != null) {
      mMaterialSchema = <MMaterialSchema>[];
      json['M_Material_Schema'].forEach((v) {
        mMaterialSchema!.add(new MMaterialSchema.fromJson(v));
      });
    }
    if (json['MC_OPH_Card_Schema'] != null) {
      mCOPHCardSchema = <MCOPHCardSchema>[];
      json['MC_OPH_Card_Schema'].forEach((v) {
        mCOPHCardSchema!.add(new MCOPHCardSchema.fromJson(v));
      });
    }
    if (json['MC_SPB_Card_Schema'] != null) {
      mCSPBCardSchema = <MCSPBCardSchema>[];
      json['MC_SPB_Card_Schema'].forEach((v) {
        mCSPBCardSchema!.add(new MCSPBCardSchema.fromJson(v));
      });
    }
    if (json['M_Destination_Schema'] != null) {
      mDestinationSchema = <MDestinationSchema>[];
      json['M_Destination_Schema'].forEach((v) {
        mDestinationSchema!.add(new MDestinationSchema.fromJson(v));
      });
    }
    if (json['M_VRA_Schema'] != null) {
      mVRASchema = <MVRASchema>[];
      json['M_VRA_Schema'].forEach((v) {
        mVRASchema!.add(new MVRASchema.fromJson(v));
      });
    }
    if (json['M_Config_Schema'] != null) {
      mConfigSchema = <MConfigSchema>[];
      json['M_Config_Schema'].forEach((v) {
        mConfigSchema!.add(new MConfigSchema.fromJson(v));
      });
    }
    if (json['Roles_Schema'] != null) {
      rolesSchema = <RolesSchema>[];
      json['Roles_Schema'].forEach((v) {
        rolesSchema!.add(new RolesSchema.fromJson(v));
      });
    }
    if (json['M_Attendance_Schema'] != null) {
      mAttendanceSchema = <MAttendanceSchema>[];
      json['M_Attendance_Schema'].forEach((v) {
        mAttendanceSchema!.add(new MAttendanceSchema.fromJson(v));
      });
    }
    if (json['T_Attendance_Schema'] != null) {
      tAttendanceSchema = <TAttendanceSchema>[];
      json['T_Attendance_Schema'].forEach((v) {
        tAttendanceSchema!.add(new TAttendanceSchema.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mEstateSchema != null) {
      data['M_Estate_Schema'] =
          this.mEstateSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mDivisionSchema != null) {
      data['M_Division_Schema'] =
          this.mDivisionSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mBlockSchema != null) {
      data['M_Block_Schema'] =
          this.mBlockSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mTPHSchema != null) {
      data['M_TPH_Schema'] = this.mTPHSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mEmployeeSchema != null) {
      data['M_Employee_Schema'] =
          this.mEmployeeSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mVendorSchema != null) {
      data['M_Vendor_Schema'] =
          this.mVendorSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mCustomerCodeSchema != null) {
      data['M_Customer_Code_Schema'] =
          this.mCustomerCodeSchema!.map((v) => v.toJson()).toList();
    }
    if (this.tUserAssignmentSchema != null) {
      data['T_User_Assignment_Schema'] =
          this.tUserAssignmentSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mActivitySchema != null) {
      data['M_Activity_Schema'] =
          this.mActivitySchema!.map((v) => v.toJson()).toList();
    }
    if (this.mCostControlSchema != null) {
      data['M_Cost_Control_Schema'] =
          this.mCostControlSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mMaterialSchema != null) {
      data['M_Material_Schema'] =
          this.mMaterialSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mCOPHCardSchema != null) {
      data['MC_OPH_Card_Schema'] =
          this.mCOPHCardSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mCSPBCardSchema != null) {
      data['MC_SPB_Card_Schema'] =
          this.mCSPBCardSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mDestinationSchema != null) {
      data['M_Destination_Schema'] =
          this.mDestinationSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mVRASchema != null) {
      data['M_VRA_Schema'] = this.mVRASchema!.map((v) => v.toJson()).toList();
    }
    if (this.mConfigSchema != null) {
      data['M_Config_Schema'] =
          this.mConfigSchema!.map((v) => v.toJson()).toList();
    }
    if (this.rolesSchema != null) {
      data['Roles_Schema'] = this.rolesSchema!.map((v) => v.toJson()).toList();
    }
    if (this.mAttendanceSchema != null) {
      data['M_Attendance_Schema'] =
          this.mAttendanceSchema!.map((v) => v.toJson()).toList();
    }
    if (this.tAttendanceSchema != null) {
      data['T_Attendance_Schema'] =
          this.tAttendanceSchema!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
