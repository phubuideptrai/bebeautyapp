class BeautyUser {
  String displayName;
  String email;
  String userID;
  String avatarUri;

  BeautyUser(
      {required this.displayName,
        required this.email,
        required this.userID,
        required this.avatarUri});
  static BeautyUser copyFrom(BeautyUser user) {
    return BeautyUser(
      displayName: user.displayName,
      email: user.email,
      userID: user.userID,
      avatarUri: user.avatarUri,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['userID'] = this.userID;
    data['avatarUri'] = this.avatarUri;
    return data;
  }
}
