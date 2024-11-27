import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

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
  final _emailController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final fineData = {
        "plate": _plateController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "speed": double.tryParse(_speedController.text) ?? 0.0,
        "limit": double.tryParse(_limitController.text) ?? 0.0,
        "lat": double.tryParse(_latController.text) ?? 0.0,
        "lng": double.tryParse(_lngController.text) ?? 0.0,
        "email": _emailController.text.toLowerCase(),
      };

      var url = Uri.parse("$api/api/fines");
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(fineData),
        );

        // Verificamos el código de estado HTTP
        if (response.statusCode == 200) {
          // Multa registrada exitosamente
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "¡Multa Registrada Exitosamente!\nCódigo de estado: 201",
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Si el código de estado no es 200, manejamos el error
          String errorMessage = 'Error desconocido';
          try {
            var responseData = jsonDecode(response.body);
            errorMessage =
                responseData['message'] ?? 'Error al registrar la multa';
          } catch (e) {
            // Si no se puede parsear el JSON, mostramos el código de estado
            errorMessage =
                'Error al registrar la multa: ${response.statusCode}';
            print("Error al parsear respuesta del servidor: $e");
          }

          // Mostrar el error con código de estado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                '$errorMessage\nCódigo de estado: ${response.statusCode}',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // En caso de error de conexión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Error de conexión\nDetalles: $e',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        print('Error al enviar los datos: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6b4b3f),
        title: const Text(
          'Registrar Multa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                _buildTextField(
                  _emailController,
                  'Correo Electrónico',
                  TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff6b4b3f),
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
            borderSide: const BorderSide(color: Color(0xff6b4b3f), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xff6b4b3f), width: 2),
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
