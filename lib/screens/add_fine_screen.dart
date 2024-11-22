import 'package:flutter/material.dart';

import '../models/fine.dart';

class AddFine extends StatefulWidget {
  const AddFine({super.key});

  @override
  _AddFineState createState() => _AddFineState();
}

class _AddFineState extends State<AddFine> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _speedController = TextEditingController();
  final _limitController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  bool _isEmailSent = false;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final fine = FineModel(
        plate: _plateController.text,
        city: _cityController.text,
        state: _stateController.text,
        speed: double.tryParse(_speedController.text) ?? 0.0,
        limit: double.tryParse(_limitController.text) ?? 0.0,
        lat: double.tryParse(_latController.text) ?? 0.0,
        lng: double.tryParse(_lngController.text) ?? 0.0,
        isEmailSent: _isEmailSent,
        creationDate: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Multa registrada: ${fine.plate}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6b4b3f),
        title: const Text(
          'Registrar Multa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_plateController, 'Placa', TextInputType.text),
                _buildTextField(_cityController, 'Ciudad', TextInputType.text),
                _buildTextField(_stateController, 'Estado', TextInputType.text),
                _buildTextField(
                  _speedController,
                  'Velocidad',
                  TextInputType.number,
                  isNumeric: true,
                ),
                _buildTextField(
                  _limitController,
                  'Límite de Velocidad',
                  TextInputType.number,
                  isNumeric: true,
                ),
                _buildTextField(
                  _latController,
                  'Latitud',
                  TextInputType.numberWithOptions(decimal: true),
                  isNumeric: true,
                ),
                _buildTextField(
                  _lngController,
                  'Longitud',
                  TextInputType.numberWithOptions(decimal: true),
                  isNumeric: true,
                ),
                Row(
                  children: [
                    const Text('¿Enviar correo?'),
                    Checkbox(
                      value: _isEmailSent,
                      onChanged: (bool? value) {
                        setState(() {
                          _isEmailSent = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff6b4b3f),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Registrar Multa',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xff6b4b3f)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xff6b4b3f), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xff6b4b3f), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: isNumeric
            ? TextInputType.numberWithOptions(decimal: true)
            : keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa $label';
          }
          return null;
        },
      ),
    );
  }
}
