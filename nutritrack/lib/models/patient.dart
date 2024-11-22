class Patient {
  final String name;
  final String id;
  final bool foodServed;
  final bool foodEaten;
  final int timeLeft;

  Patient({
    required this.name,
    required this.id,
    required this.foodServed,
    required this.foodEaten,
    required this.timeLeft,
  });

  factory Patient.fromFirestore(Map<String, dynamic> data) {
    return Patient(
      name: data['name'] ?? '',
      id: data['id'] ?? '',
      foodServed: data['foodServed'] ?? false,
      foodEaten: data['foodEaten'] ?? false,
      timeLeft: data['timeLeft'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id': id,
      'foodServed': foodServed,
      'foodEaten': foodEaten,
      'timeLeft': timeLeft,
    };
  }
}
