class ApplicationModel {
  String? moneyReq;
  String? userName;
  String? srName;
  String? country;
  String? securityNumber;
  String? dateOfBirth;
  String? date;
  String? telephoneNumber;
  ApplicationModel(
      {
        this.userName,
      this.country,
      this.date,
      this.dateOfBirth,
      this.moneyReq,
      this.securityNumber,
      this.srName,
      this.telephoneNumber});




  Map<String, dynamic> toJson() {
    return {
      "moneyReq": this.moneyReq,
      "userName": this.userName,
      "srName": this.srName,
      "securityNumber": this.securityNumber,
      "dateOfBirth": this.dateOfBirth,
      "date": this.date,
      "country": this.country,
      "telephoneNumber": this.telephoneNumber,
    };
  }

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      moneyReq: json["moneyReq"] ?? "",
      userName: json["userName"] ?? "",
      srName: json["srName"] ?? "",
      securityNumber: json["securityNumber"] ?? "",
      dateOfBirth: json["dateOfBirth"]??"",
      date: json["date"] ??"",
      country: json["country"] ??"",
      telephoneNumber: json["telephoneNumber"] ?? "",
    );
  }



  }

