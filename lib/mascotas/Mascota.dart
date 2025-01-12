class Mascota {
  final String id;
  final String nombreMas;
  final String raza;
  final String sexo;
  final String fechaNac;
  final String colorPelaje;
  final String tipo;
  final String privacidad;
  final String descripcion;
  final String user;
  final String? imagen; // La imagen puede ser nula

  Mascota({
    required this.id,
    required this.nombreMas,
    required this.raza,
    required this.sexo,
    required this.fechaNac,
    required this.colorPelaje,
    required this.tipo,
    required this.privacidad,
    required this.descripcion,
    required this.user,
    this.imagen,
  });

  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      id: json['_id'],
      nombreMas: json['nombre_mas'],
      raza: json['raza'],
      sexo: json['sexo'],
      fechaNac: json['fecha_nac'],
      colorPelaje: json['color_pelaje'],
      tipo: json['tipo'],
      privacidad: json['privacidad'],
      descripcion: json['descripcion'],
      user: json['user'],
      imagen: json['imagen'],
    );
  }
}
