class FoodModel {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;

  const FoodModel({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nombre,
      'price': precio,
      'image': imagen,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: (map['id'] as num).toInt(),
      nombre: (map['name'] ?? '') as String,
      precio: (map['price'] as num).toDouble(),
      imagen: (map['image'] ?? '') as String,
    );
  }
}
