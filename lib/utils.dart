

class Utils {

  static generateKeybyArray(List<String>? array) {
    var ar = array!;
    List<dynamic> arrayFinal = [];
    for (var i = 0; i < ar.length; i++) {
        var subList = ar.sublist(i, ar.length);
        var generated = generateKeybyString(subList.join(" ").toString());
        arrayFinal.addAll(generated);
    }
    return arrayFinal;
  }

  static generateKeybyString(String name) {
    if (name.length > 1)
      return [ name,
        ...?generateKeybyString(name.substring(0, name.length - 1).toLowerCase())
      ];
  }

}