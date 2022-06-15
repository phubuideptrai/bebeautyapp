import 'package:bebeautyapp/model/MStructure.dart';

class StructureServices {

  List<MStructure> getStructures() {
    List<MStructure> structures = [
      MStructure(id: 0, name: "Dạng kem"),
      MStructure(id: 1, name: "Dạng lỏng"),
      MStructure(id: 2, name: "Dạng gel"),
      MStructure(id: 3, name: "Dạng sữa"),
      MStructure(id: 4, name: "Dạng nước"),
      MStructure(id: 5, name: "Dạng giấy"),
      MStructure(id: 6, name: "Dạng serum"),
      MStructure(id: 7, name: "Dạng rắn dẻo"),
      MStructure(id: 8, name: "Dạng tạo bọt sẵn"),
      MStructure(id: 9, name: "Dạng hạt"),
      MStructure(id: 10, name: "Dạng dầu"),
      MStructure(id: 11, name: "Dạng rắn")
    ];
    return structures;
  }

  String getStructureName(int structureID) {
    switch (structureID) {
      case 1:
        return "Dạng kem";
      case 2:
        return "Dạng lỏng";
      case 3:
        return "Dạng gel";
      case 4:
        return "Dạng sữa";
      case 5:
        return "Dạng nước";
      case 6:
        return "Dạng giấy";
      case 7:
        return "Dạng serum";
      case 8:
        return "Dạng rắn dẻo";
      case 9:
        return "Dạng tạo bọt sẵn";
      case 10:
        return "Dạng hạt";
      case 11:
        return "Dạng dầu";
      default:
        return "Da rắn";
    }
  }
}