
class Address {
  String? name,
      line1,
      city,
      state,
      zipCode;

  Address({this.name, this.line1, this.city, this.state, this.zipCode});

  Address.fromJson(Map<String, dynamic> json):
        line1 = json['line1'],
        name = json['name'],
        city = json['city'],
        state = json['state'],
        zipCode = json['zipcode'];

  Map<String, dynamic>  toJson() => {
      'name' : name,
      'line1': line1,
      'city': city,
      'state': state,
      'zipcode': zipCode
  };

}