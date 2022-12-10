import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/proveedor.dart';
import 'package:proyecto/models/usuario.dart';

class ProveedoresAPI {
  final String urlBase = "http://192.168.126.206:5000";

  //CRUD APIS
  Future<List<Proveedor>> getList() async {
    var url = Uri.parse('$urlBase/api/Proveedores/Consultar');

    List<Proveedor> proveedores = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      for (var element in jsonData) {
        proveedores.add(Proveedor(
            element["idProveedor"],
            element["strNombre"],
            element["strDireccion"],
            element["intCodigoPostal"],
            element["strCiudad"],
            element["strRFC"],
            element["strTelefono"],
            element["intEstatus"]));
      }
      return proveedores;
    } else {
      return [];
    }
  }

  Future<String> agregar(Proveedor e) async {
    try {
      String strNombre = e.strNombre;
      String strDireccion = e.strDireccion;
      int intCodigoPostal = e.intCodigoPostal;
      String strCiudad = e.strCiudad;
      String strRFC = e.strRFC;
      String strTelefono = e.strTelefono;

      var url = Uri.parse(
          '$urlBase/api/Proveedores/Agregar?pstrNombre=$strNombre&pstrDireccion=$strDireccion&pintCodigoPostal=$intCodigoPostal&pstrCiudad=$strCiudad&pstrRFC=$strRFC&pstrTelefono=$strTelefono');
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

  Future<String> editar(Proveedor e) async {
    try {
      int idProveedor = e.idProveedor;
      String strNombre = e.strNombre;
      String strDireccion = e.strDireccion;
      int intCodigoPostal = e.intCodigoPostal;
      String strCiudad = e.strCiudad;
      String strRFC = e.strRFC;
      String strTelefono = e.strTelefono;

      var url = Uri.parse(
          '$urlBase/api/Proveedores/Modificar?pintIdProveedor=$idProveedor&pstrNombre=$strNombre&pstrDireccion=$strDireccion&pintCodigoPostal=$intCodigoPostal&pstrCiudad=$strCiudad&pstrRFC=$strRFC&pstrTelefono=$strTelefono');

      final response = await http.patch(url);
      print(response.statusCode);
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

  Future<String> eliminar(int pintIdProveedor) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Proveedores/Eliminar/?pintIdProveedor=$pintIdProveedor');

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

  Future<String> activar(int pintIdProveedor) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Proveedores/Activar?pintIdProveedor=$pintIdProveedor&aux=1');
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

  Future<List<Proveedor>> buscar(String pstrCadena) async {
    var url =
        Uri.parse('$urlBase/api/Proveedores/Buscar/?pstrCadena=$pstrCadena');

    List<Proveedor> proveedores = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var element in jsonData) {
        proveedores.add(Proveedor(
            element["idProveedor"],
            element["strNombre"],
            element["strDireccion"],
            element["intCodigoPostal"],
            element["strCiudad"],
            element["strRFC"],
            element["strTeléfono"],
            element["intEstatus"]));
      }
      return proveedores;
    } else {
      return [];
    }
  }
}
