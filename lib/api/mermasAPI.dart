import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/merma.dart';

class MermasAPI {
  final String urlBase = "http://192.168.126.206:5000";

  //CRUD APIS
  Future<List<Merma>> getList() async {
    var url = Uri.parse('$urlBase/api/Mermas/Consultar');

    List<Merma> mermas = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      for (var element in jsonData) {
        mermas.add(Merma(element["idMerma"], element["intIdMateriaPrima"],
            element["strNombre"], element["intCantidad"], element["strFecha"]));
      }
      return mermas;
    } else {
      return [];
    }
  }

  Future<String> agregar(Merma e) async {
    try {
      int intIdMateriaPrima = e.intIdMateriaPrima;
      int intCantidad = e.intCantidad;

      var url = Uri.parse(
          '$urlBase/api/Mermas/Agregar?pintIdMateriaPrima=$intIdMateriaPrima&pintCantidad=$intCantidad');
      final response = await http.post(url);

      if (response.statusCode == 404) {
        return "OK";
      } else {
        return "ERROR";
      }
    } catch (ex) {
      return "ERROR";
    }
  }

  Future<String> eliminar(int pintMateriasPrimasId) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Mermas/Eliminar?pintIdMerma=$pintMateriasPrimasId');

      final response = await http.patch(url);
      if (response.statusCode == 404) {
        return "OK";
      } else {
        return "ERROR";
      }
    } catch (ex) {
      return "ERROR";
    }
  }

  Future<List<Merma>> buscar(String pstrCadena) async {
    var url = Uri.parse('$urlBase/api/Mermas/Buscar/?pstrCadena=$pstrCadena');

    List<Merma> mermas = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var element in jsonData) {
        mermas.add(Merma(element["idMerma"], element["intIdMateriaPrima"],
            element["strNombre"], element["intCantidad"], element["strFecha"]));
      }
      return mermas;
    } else {
      return [];
    }
  }
}
