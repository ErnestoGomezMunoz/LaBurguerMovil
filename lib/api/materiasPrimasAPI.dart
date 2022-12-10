import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/materiaPrima.dart';
import 'package:proyecto/models/usuario.dart';

class MateriasPrimasAPI {
  final String urlBase = "http://192.168.126.206:5000";

  //CRUD APIS
  Future<List<MateriaPrima>> getList() async {
    var url = Uri.parse('$urlBase/api/MateriasPrimas/Consultar');

    List<MateriaPrima> materiasPrimas = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      for (var element in jsonData) {
        materiasPrimas.add(MateriaPrima(
            element["idMateriasPrimas"],
            element["strNombre"],
            element["intCantidad"],
            element["intCantidadXHamburguesa"],
            element["strUnidad"]));
      }
      return materiasPrimas;
    } else {
      return [];
    }
  }

  Future<String> agregar(MateriaPrima e) async {
    try {
      String strNombre = e.strNombre;
      int intCantidad = e.intCantidad;
      int intCantidadXHamburguesa = e.intCantidadXHamburguesa;
      String strUnidad = e.strUnidad;

      var url = Uri.parse(
          '$urlBase/api/MateriasPrimas/Agregar?pstrNombre=$strNombre&pintCantidad=$intCantidad&pintCantidadXHamburguesa=$intCantidadXHamburguesa&pstrUnidad=$strUnidad');
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

  Future<String> editar(MateriaPrima e) async {
    try {
      int idMateriasPrimas = e.idMateriasPrimas;
      String strNombre = e.strNombre;
      int intCantidad = e.intCantidad;
      int intCantidadXHamburguesa = e.intCantidadXHamburguesa;
      String strUnidad = e.strUnidad;

      var url = Uri.parse(
          '$urlBase/api/MateriasPrimas/Modificar?pintMateriasPrimasId=$idMateriasPrimas&pstrNombre=$strNombre&pintCantidad=$intCantidad&pintCantidadXHamburguesa=$intCantidadXHamburguesa&pstrUnidad=$strUnidad');

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

  Future<String> eliminar(int pintMateriasPrimasId) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/MateriasPrimas/Eliminar/?pintMateriasPrimasId=$pintMateriasPrimasId');

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

  Future<List<MateriaPrima>> buscar(String pstrCadena) async {
    var url =
        Uri.parse('$urlBase/api/MateriasPrimas/Buscar/?pstrCadena=$pstrCadena');

    List<MateriaPrima> materiasPrimas = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var element in jsonData) {
        materiasPrimas.add(MateriaPrima(
            element["idMateriasPrimas"],
            element["strNombre"],
            element["intCantidad"],
            element["intCantidadXHamburguesa"],
            element["strUnidad"]));
      }
      return materiasPrimas;
    } else {
      return [];
    }
  }
}
