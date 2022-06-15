
class MFactor {
  late int id;
  late int frequency;

  MFactor(
      {required this.id,
        required this.frequency});

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  int getFrequency() {return this.frequency;}
  void setFrequency(int Frequency) {this.frequency = Frequency;}

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['frequency'] = this.frequency;
    return data;
  }
}