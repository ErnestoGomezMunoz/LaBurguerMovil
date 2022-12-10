import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/models/usuario.dart';

class UsuariosAPI {
  final String urlBase = "http://192.168.126.206:5000";

  //CRUD APIS
  Future<List<Usuario>> getList() async {
    var url = Uri.parse('$urlBase/api/Usuarios/Consultar');

    List<Usuario> usuarios = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      //print(jsonData);
      for (var element in jsonData) {
        usuarios.add(Usuario(
            element["intUsuarioId"],
            element["intRolId"],
            element["strNombre"],
            element["strApellidoPaterno"],
            element["strApellidoMaterno"],
            element["strTeléfono"],
            element["strEmail"],
            element["strPassword"],
            element["intEstatus"]));
      }
      return usuarios;
    } else {
      return [];
    }
  }

  Future<String> agregar(Usuario e) async {
    try {
      int intRolId = e.intRolId;
      String strNombre = e.strNombre;
      String strApellidoPaterno = e.strApellidoPaterno;
      String strApellidoMaterno = e.strApellidoMaterno;
      String strTelefono = e.strTelefono;
      String strEmail = e.strEmail;
      String strPassword = e.strPassword;

      var url = Uri.parse(
          '$urlBase/api/Usuarios/Agregar?pintRolId=$intRolId&pstrNombre=$strNombre&pstrApellidoPaterno=$strApellidoPaterno&pstrApellidoMaterno=$strApellidoMaterno&pstrTeléfono=$strTelefono&pstrEmail=$strEmail&pstrPassword=$strPassword');
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

  Future<String> editar(Usuario e) async {
    try {
      int intUsuarioId = e.intUsuarioId;
      int intRolId = e.intRolId;
      String strNombre = e.strNombre;
      String strApellidoPaterno = e.strApellidoPaterno;
      String strApellidoMaterno = e.strApellidoMaterno;
      String strTelefono = e.strTelefono;
      String strEmail = e.strEmail;
      String strPassword = e.strPassword;

      var url = Uri.parse(
          '$urlBase/api/Usuarios/Modificar?pintUsuarioId=$intUsuarioId&pintRolId=$intRolId&pstrNombre=$strNombre&pstrApellidoPaterno=$strApellidoPaterno&pstrApellidoMaterno=$strApellidoMaterno&pstrTeléfono=$strTelefono&pstrEmail=$strEmail&pstrPassword=$strPassword');

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

  Future<String> eliminar(int pintUsuarioId) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Usuarios/Eliminar/?pintUsuarioId=$pintUsuarioId');

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

  Future<String> activar(int pintUsuarioId) async {
    try {
      var url = Uri.parse(
          '$urlBase/api/Usuarios/Activar?pintUsuarioId=$pintUsuarioId&aux=1');
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

  Future<List<Usuario>> buscar(String pstrCadena) async {
    var url = Uri.parse('$urlBase/api/Usuarios/Buscar/?pstrCadena=$pstrCadena');

    List<Usuario> usuarios = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData);
      for (var element in jsonData) {
        usuarios.add(Usuario(
            element["intUsuarioId"],
            element["intRolId"],
            element["strNombre"],
            element["strApellidoPaterno"],
            element["strApellidoMaterno"],
            element["strTeléfono"],
            element["strEmail"],
            element["strPassword"],
            element["intEstatus"]));
      }
      return usuarios;
    } else {
      return [];
    }
  }
}
