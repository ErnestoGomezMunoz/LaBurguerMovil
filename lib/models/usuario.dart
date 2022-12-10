class Usuario {
  late int intUsuarioId;
  late int intRolId;
  late String strNombre;
  late String strApellidoPaterno;
  late String strApellidoMaterno;
  late String strTelefono;
  late String strEmail;
  late String strPassword;
  late int estatus;

  Usuario(
      this.intUsuarioId,
      this.intRolId,
      this.strNombre,
      this.strApellidoPaterno,
      this.strApellidoMaterno,
      this.strTelefono,
      this.strEmail,
      this.strPassword,
      this.estatus);
}
