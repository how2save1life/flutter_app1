class MedicineListModel {
  // String code;
  // String message;
  List<MedicineModel> data;

  MedicineListModel(this.data);

  MedicineListModel.fromJson(List<dynamic> json){
    if (json.length!=0){
      data=List<MedicineModel>();
      json.forEach((v){
        data.add(MedicineModel.fromJson(v));
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

class MedicineModel {
  String medicineId;
  String medicineName;
  String medicineName1;
  String medicineName2;
  String medicinePic;
  String medicineSound;

  MedicineModel(this.medicineId, this.medicineName, this.medicineName1,
      this.medicineName2, this.medicinePic, this.medicineSound);

  MedicineModel.fromJson(Map<String, dynamic> json){
    medicineId = json['medicineId'];
    medicineName = json['medicineName'];
    medicineName1 = json['medicineName1'];
    medicineName2 = json['medicineName2'];
    medicinePic = json['medicinePic'];
    medicineSound = json['medicineSound'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['medicineId']=this.medicineId;
    data['medicineName']=this.medicineName;
    data['medicineName1']=this.medicineName1;
    data['medicineName2']=this.medicineName2;
    data['medicinePic']=this.medicinePic;
    data['medicineSound']=this.medicineSound;

    return data;
  }
}