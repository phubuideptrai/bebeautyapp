import 'package:bebeautyapp/model/MSkin.dart';

class SkinServices {

  List<MSkin> getSkins() {
    List<MSkin> skins = [
      MSkin(id: 0, name: "Mọi loại da"),
      MSkin(id: 1, name: "Da mụn"),
      MSkin(id: 2, name: "Da dầu"),
      MSkin(id: 3, name: "Da khô"),
      MSkin(id: 4, name: "Da hỗn hợp"),
      MSkin(id: 5, name: "Da nhạy cảm"),
      MSkin(id: 6, name: "Da vùng mắt"),
      MSkin(id: 7, name: "Da sẹo"),
      MSkin(id: 8, name: "Da vùng môi"),
    ];
    return skins;
  }

  String getSkinName(int skinID) {
    switch (skinID) {
      case 1:
        return "Mọi loại da";
      case 2:
        return "Da mụn";
      case 3:
        return "Da dầu";
      case 4:
        return "Da khô";
      case 5:
        return "Da hỗn hợp";
      case 6:
        return "Da nhạy cảm";
      case 7:
        return "Da vùng mắt";
      case 8:
        return "Da sẹo";
      default:
        return "Da vùng môi";
    }
  }
}