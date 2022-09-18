class PartyReq {
  String partyId;
  String memberId;
  DateTime createdDate;
  int status;

  PartyReq({this.partyId, this.memberId, this.createdDate, this.status});
  factory PartyReq.jsonFrom(Map<String, dynamic> json) {
    return PartyReq(
      partyId: json["partyId"],
      memberId: json["memberId"],
      createdDate: DateTime.tryParse(json["createdDate"]),
      status: json["status"],
    );
  }
}
