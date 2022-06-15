import 'package:bebeautyapp/model/MGender.dart';

class GenderServices {

  List<MGender> getGenders() {
    List<MGender> genders = [
      MGender(id: 0, name: "Dành cho mọi giới tính"),
      MGender(id: 1, name: "Dành cho nữ giới"),
      MGender(id: 2, name: "Dành cho nam tính"),
    ];
    return genders;
  }

  String getGender(int genderID) {
    switch (genderID) {
      case 1:
        return "Dành cho mọi giới tính";
      case 2:
        return "Dành cho nữ giới";
      default:
        return "Dành cho nam giới";
    }
  }
}