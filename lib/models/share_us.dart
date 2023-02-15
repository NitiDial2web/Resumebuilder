class GetShareUsModel {
  GetShareUsModel({
    required this.success,
    required this.data,
    required this.msg,
  });
  late final int success;
  late final List<Data> data;
  late final String msg;

  GetShareUsModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    _data['msg'] = msg;
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.whatsApp,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.linkedIn,
    required this.pinterest,
  });
  late final int id;
  late final String whatsApp;
  late final String facebook;
  late final String instagram;
  late final String twitter;
  late final String linkedIn;
  late final String pinterest;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    whatsApp = json['whats_app'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    linkedIn = json['linked_in'];
    pinterest = json['pinterest'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['whats_app'] = whatsApp;
    _data['facebook'] = facebook;
    _data['instagram'] = instagram;
    _data['twitter'] = twitter;
    _data['linked_in'] = linkedIn;
    _data['pinterest'] = pinterest;
    return _data;
  }
}