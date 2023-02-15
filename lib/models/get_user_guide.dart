class GetUserGuideModel {
  GetUserGuideModel({
    required this.success,
    required this.data,
    required this.msg,
  });
  late final int success;
  late final List<Data> data;
  late final String msg;

  GetUserGuideModel.fromJson(Map<String, dynamic> json){
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
    required this.image,
    required this.sortOrder,
  });
  late final int id;
  late final String image;
  late final int sortOrder;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['image'] = image;
    _data['sort_order'] = sortOrder;
    return _data;
  }
}