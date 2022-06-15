import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class MHistory {
  late int id;
  late int frequency;

  MHistory(
      {required this.id,
        required this.frequency});

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  int getFrequency() {return this.frequency;}
  void setFrequency(int Frequency) {this.frequency = Frequency;}

}