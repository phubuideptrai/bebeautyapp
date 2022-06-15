import 'package:bebeautyapp/model/MSession.dart';

class SessionServices {

  List<MSession> getSessions() {
    List<MSession> sessions = [
      MSession(id: 0, name: "Ngày và đêm"),
      MSession(id: 1, name: "Ban ngày"),
      MSession(id: 2, name: "Ban đêm"),
    ];
    return sessions;
  }

  String getSession(int sessionID) {
    switch (sessionID) {
      case 1:
        return "Ngày và đêm";
      case 2:
        return "Ban ngày";
      default:
        return "Ban đêm";
    }
  }
}