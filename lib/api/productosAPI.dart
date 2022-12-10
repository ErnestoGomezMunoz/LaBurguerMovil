import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/productos.dart';

class ProductosAPI {
  final String urlBase = "http://192.168.126.206:5000";

  //CRUD APIS
  Future<List<Productos>> getList() async {
    var url = Uri.parse('$urlBase/api/Productos/Consultar');

    List<Productos> productos = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      for (var element in jsonData) {
        productos.add(Productos(element["idProducto"], element["strNombre"],
            element["fltPrecio"], element["strDescripcion"]));
      }
      return productos;
    } else {
      return [];
    }
  }

  Future<String> agregar(Productos e) async {
    try {
      String strNombre = e.strNombre;
      double fltPrecio = e.fltPrecio;
      String strDescripcion = e.strDescripcion;

      var url = Uri.parse(
          '$urlBase/api/Productos/Agregar?pstrNombre=$strNombre&pfltPrecio=$fltPrecio&pstrDescripcion=$strDescripcion');
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

  Future<String> editar(Productos e) async {
    try {
      int idProducto = e.idProducto;
      String strNombre = e.strNombre;
      double fltPrecio = e.fltPrecio;
      String strDescripcion = e.strDescripcion;

      var url = Uri.parse(
          '$urlBase/api/Productos/Modificar?pintProductoId=$idProducto&pstrNombre=$strNombre&pfltPrecio=$fltPrecio&pstrDescripcion=$strDescripcion');

      final response = await http.patch(url);
      print(response.body);
      if (response.statusCode == 404) {
        return "OK";
      } else {
        return "ERROR";
      }
    } catch (ex) {
      return "ERROR";
    }
  }

  Future<String> eliminar(int pintProductoId) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Productos/Eliminar?pintProductoId=$pintProductoId');

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

  Future<List<Productos>> buscar(String pstrCadena) async {
    var url = Uri.parse('$urlBase/api/Productos/Buscar?pstrCadena=$pstrCadena');

    List<Productos> productos = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var element in jsonData) {
        productos.add(Productos(element["idProducto"], element["strNombre"],
            element["fltPrecio"], element["strDescripcion"]));
      }
      return productos;
    } else {
      return [];
    }
  }
}
