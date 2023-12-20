class PolicyModel{
  String id;
  String policy;
  PolicyModel();

  PolicyModel.fromJson(Map<String, dynamic> jsonMap){
    try{
      id=jsonMap['id'];
      policy=jsonMap['policy'];
    }
    catch(e){
      jsonMap['policy']='';
    }
  }

}