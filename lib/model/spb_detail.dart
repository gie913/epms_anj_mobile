import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class SPBDetail extends Equatable {
  String? spbId;
  String? ophId;
  int? ophBunchesDelivered;
  int? ophLooseFruitDelivered;
  String? ophEstateCode;
  String? ophDivisionCode;
  String? ophBlockCode;
  String? ophTphCode;
  String? ophCardId;

  SPBDetail(
      {this.spbId,
      this.ophId,
      this.ophBunchesDelivered,
      this.ophLooseFruitDelivered,
      this.ophEstateCode,
      this.ophDivisionCode,
      this.ophBlockCode,
      this.ophTphCode,
      this.ophCardId});

  SPBDetail.fromJson(Map<String, dynamic> json) {
    spbId = json['spb_id'];
    ophId = json['oph_id'];
    ophBunchesDelivered = json['oph_bunches_delivered'];
    ophLooseFruitDelivered = json['oph_loose_fruit_delivered'];
    ophEstateCode = json['oph_estate_code'];
    ophDivisionCode = json['oph_division_code'];
    ophBlockCode = json['oph_block_code'];
    ophTphCode = json['oph_tph_code'];
    ophCardId = json['oph_card_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_id'] = this.spbId;
    data['oph_id'] = this.ophId;
    data['oph_bunches_delivered'] = this.ophBunchesDelivered;
    data['oph_loose_fruit_delivered'] = this.ophLooseFruitDelivered;
    data['oph_block_code'] = this.ophBlockCode;
    data['oph_tph_code'] = this.ophTphCode;
    data['oph_card_id'] = this.ophCardId;
    return data;
  }

  Map<String, dynamic> toDatabase() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spb_id'] = this.spbId;
    data['oph_id'] = this.ophId;
    data['oph_bunches_delivered'] = this.ophBunchesDelivered;
    data['oph_loose_fruit_delivered'] = this.ophLooseFruitDelivered;
    data['oph_estate_code'] = this.ophEstateCode;
    data['oph_division_code'] = this.ophDivisionCode;
    data['oph_block_code'] = this.ophBlockCode;
    data['oph_tph_code'] = this.ophTphCode;
    data['oph_card_id'] = this.ophCardId;
    return data;
  }

  @override
  String toString() {
    return 'SPBDetail(spb_id: $spbId, oph_id: $ophId, oph_bunches_delivered: $ophBunchesDelivered, oph_loose_fruit_delivered: $ophLooseFruitDelivered, oph_estate_code: $ophEstateCode, oph_division_code: $ophDivisionCode, oph_block_code: $ophBlockCode, oph_tph_code: $ophTphCode, oph_card_id: $ophCardId)';
  }

  @override
  List<Object> get props => [spbId!, ophId!];

  @override
  bool get stringify => false;
}

//add ari
class SPBDetCombine {
  int? tbsType;
  String? ophEstateCode;
  String? ophBlockCode;
  int? ophBunchesDelivered;
  int? ophLooseFruitDelivered;
}
//add ari