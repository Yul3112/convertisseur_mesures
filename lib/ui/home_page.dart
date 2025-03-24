import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/converter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Converter _converter = Converter();
  double _inputValue = 0.0;
  bool _inputError = false;
  String _fromUnit = 'mètres';
  String _toUnit = 'kilomètres';
  String? _resultMessage;

  @override
  void initState() {
    super.initState();
    _fromUnit = _converter.units.first;
    _toUnit = _converter.units[1];
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[700],
    );

    final labelStyle = TextStyle(
      fontSize: 20,
      color: Colors.grey[700],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convertisseur de mesures'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Valeur à convertir',
              style: inputStyle,
            ),
            const Spacer(),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*$')),
              ],
              textAlign: TextAlign.center,
              style: inputStyle,
              decoration: InputDecoration(
                hintText: 'Saisissez la mesure à convertir',
                border: const OutlineInputBorder(),
                errorText: _inputError ? 'Veuillez entrer un nombre valide' : null,
              ),
              onChanged: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _inputValue = 0.0;
                    _inputError = false;
                  });
                } else {
                  final value = double.tryParse(text.replaceAll(',', '.'));
                  setState(() {
                    _inputError = value == null;
                    if (!_inputError) {
                      _inputValue = value!;
                    }
                  });
                }
              },
            ),
            const Spacer(),
            Text('Depuis', style: labelStyle),
            const SizedBox(height: 8),
            _buildUnitDropdown(_converter.units, _fromUnit, (newValue) {
              setState(() => _fromUnit = newValue!);
            }, inputStyle),
            const Spacer(),
            Text('Vers', style: labelStyle),
            const SizedBox(height: 8),
            _buildUnitDropdown(_converter.units, _toUnit, (newValue) {
              setState(() => _toUnit = newValue!);
            }, inputStyle),
            const Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                setState(() {
                  _resultMessage = _converter.convert(_inputValue, _fromUnit, _toUnit);
                });
              },
              child: Text(
                'Convertir',
                style: inputStyle.copyWith(color: Colors.white),
              ),
            ),
            const Spacer(flex: 2),
            _buildResultContainer(labelStyle),
            const Spacer(flex: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(
      List<String> items,
      String value,
      ValueChanged<String?> onChanged,
      TextStyle style,
      ) {
    return DropdownButton<String>(
      value: value,
      style: style,
      dropdownColor: Colors.blue[50],
      underline: Container(height: 2, color: Colors.blue),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: style),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildResultContainer(TextStyle labelStyle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: const BoxConstraints(minHeight: 100),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_resultMessage != null)
            Text(
              _resultMessage!,
              textAlign: TextAlign.center,
              style: labelStyle.copyWith(
                fontSize: 18,
                color: _resultMessage!.contains('impossible')
                    ? Colors.red
                    : Colors.grey[700],
              ),
            )
          else
            Text(
              'Entrez une valeur et cliquez sur "Convertir"',
              textAlign: TextAlign.center,
              style: labelStyle.copyWith(fontSize: 18),
            ),
        ],
      ),
    );
  }
}