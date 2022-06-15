
import 'package:bebeautyapp/model/MFactor.dart';

class MCriteria {
  late MFactor factor1;
  late MFactor factor2;
  late MFactor factor3;
  late MFactor factor4;
  late MFactor factor5;

  MCriteria(
      {required this.factor1,
        required this.factor2,
        required this.factor3,
        required this.factor4,
        required this.factor5});

  MFactor getFactor(int no) {
    if (no == 1)
      return this.factor1;
    else if (no == 2)
      return this.factor2;
    else if (no == 3)
      return this.factor3;
    else if (no == 4)
      return this.factor4;
    else
      return this.factor5;
  }

  void setFactor(int no, MFactor factor) {
    if (no == 1)
      this.factor1 = factor;
    else if (no == 2)
      this.factor2 = factor;
    else if (no == 3)
      this.factor3 = factor;
    else if (no == 4)
      this.factor4 = factor;
    else
      this.factor5 = factor;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.factor1.toJson();
    data['skin'] = this.factor2.toJson();
    data['category'] = this.factor3.toJson();
    data['session'] = this.factor4.toJson();
    data['structure'] = this.factor5.toJson();

    return data;
  }
}