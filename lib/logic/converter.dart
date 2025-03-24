class Converter {
  final Map<String, int> mesuresMap = {
    'mètres': 0,
    'kilomètres': 1,
    'grammes': 2,
    'kilogrammes': 3,
    'pieds': 4,
    'miles': 5,
    'livres': 6,
    'onces': 7,
  };

  final List<List<double>> formules = [
    // mètres, kilomètres, grammes, kilogrammes, pieds, miles, livres, onces
    [1, 0.001, 0, 0, 3.28084, 0.00062, 0, 0], // mètres
    [1000, 1, 0, 0, 3280.84, 0.62137, 0, 0], // kilomètres
    [0, 0, 1, 0.001, 0, 0, 0.0022, 0.03527], // grammes
    [0, 0, 1000, 1, 0, 0, 2.20462, 35.274], // kilogrammes
    [0.3048, 0.0003, 0, 0, 1, 0.00019, 0, 0], // pieds
    [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0], // miles
    [0, 0, 453.592, 0.45359, 0, 0, 1, 16], // livres
    [0, 0, 28.3495, 0.022835, 0, 0, 0.0625, 1], // onces
  ];

  List<String> get units => mesuresMap.keys.toList();

  String convert(double value, String fromUnit, String toUnit) {
    if (value == 0) return 'Veuillez entrer une valeur à convertir';

    final fromIndex = mesuresMap[fromUnit];
    final toIndex = mesuresMap[toUnit];

    if (fromIndex == null || toIndex == null) {
      return 'Sélection d\'unités invalide';
    }

    final factor = formules[fromIndex][toIndex];
    if (factor == 0) {
      return 'Conversion impossible entre $fromUnit et $toUnit';
    }

    final result = value * factor;
    return '${value.toStringAsFixed(2)} $fromUnit\n'
        '=\n'
        '${result.toStringAsFixed(2)} $toUnit';
  }
}