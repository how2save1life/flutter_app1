class PatientListModel {
  // String code;
  // String message;
  List<PatientModel> data=[];

  PatientListModel(this.data);

  PatientListModel.fromJson(List<dynamic> json){
    if (json.length!=0){
      data=List<PatientModel>();
      json.forEach((v){
        data.add(PatientModel.fromJson(v));
      });
    }
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    // data['code']=this.code;
    // data['message']=this.message;
    if (this.data!=null){
      data['data']=this.data.map((e) => e.toJson()).toList();
    }
    return data;
  }

}

class PatientModel {
  String patientId;
   String patientName;
   String patientHead;
   String patientSex;
   String patientPhone;
   String patientAddr;
   String patientBirthday;

  PatientModel(this.patientId, this.patientName, this.patientHead,
      this.patientSex, this.patientPhone, this.patientAddr,this.patientBirthday);

  PatientModel.fromJson(Map<String, dynamic> json){
    patientId = json['patientId'];
    patientName = json['patientName'];
    patientHead = json['patientHead'];
    patientSex = json['patientSex'];
    patientPhone = json['patientPhone'];
    patientAddr = json['patientAddr'];
    patientBirthday=json['patientBirthday'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['patientId']=this.patientId;
    data['patientName']=this.patientName;
    data['patientHead']=this.patientHead;
    data['patientSex']=this.patientSex;
    data['patientPhone']=this.patientPhone;
    data['patientAddr']=this.patientAddr;
    data['patientBirthday']=this.patientBirthday;

    return data;
  }
}