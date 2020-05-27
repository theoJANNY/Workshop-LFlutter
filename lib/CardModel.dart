class User{

  String createdAt;
  String telephone;
  String first_name;
  String last_name;
  String id;
  int sexe;

  User(
      this.createdAt,
      this.telephone,
      this.first_name,
      this.last_name,
      {this.id}
      );

  static User fromJson(responseJson){
    bool value;
    if(responseJson['status'] == 1)
      value = false;
    else
      value = true;
    return User(
      DateTime.now().toString(),
      responseJson['telephone'],
      responseJson['first_name'],
      responseJson['last_name'],
      id: responseJson['id'],
    );
  }

  String toString(){
    return "User - First Name: ${this.first_name}, Last Name: ${this.last_name}";
  }
}