import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/fine.dart';

class AddFine extends StatefulWidget {
  final FineModel? existingFine;
  const AddFine({super.key, this.existingFine});

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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingFine != null) {
      _plateController.text = widget.existingFine!.plate;
      _cityController.text = widget.existingFine!.city;
      _stateController.text = widget.existingFine!.state;
      _speedController.text = widget.existingFine!.speed.toString();
      _limitController.text = widget.existingFine!.limit.toString();
      _latController.text = widget.existingFine!.lat.toString();
      _lngController.text = widget.existingFine!.lng.toString();
      _emailController.text = widget.existingFine!.email;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

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

      var url = widget.existingFine == null
          ? Uri.parse("$api/api/fines") // Crear nueva
          : Uri.parse("$api/api/fines/${widget.existingFine!.id}"); // Editar

      try {
        final response = await (widget.existingFine == null
            ? http.post(url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(fineData))
            : http.put(url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(fineData)));

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
                widget.existingFine == null
                    ? "¡Multa Registrada Éxitosamente!"
                    : "¡Multa Actualizada Éxitosamente!",
                style: TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ));
          Navigator.pop(context, true); // Retorna a la lista
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("Error: ${response.statusCode}",
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error de conexión: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6b4b3f),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.existingFine == null ? 'Registrar Multa' : 'Actualizar Multa',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                    _plateController, 'Placa', Icons.directions_car),
                _buildTextField(_cityController, 'Ciudad', Icons.location_city),
                _buildTextField(_stateController, 'Estado', Icons.map),
                _buildTextField(
                  _speedController,
                  'Velocidad',
                  Icons.speed,
                  isNumeric: true,
                ),
                _buildTextField(
                  _limitController,
                  'Límite de Velocidad',
                  Icons.warning,
                  isNumeric: true,
                ),
                _buildTextField(
                  _latController,
                  'Latitud',
                  Icons.location_on,
                  isNumeric: false,
                ),
                _buildTextField(
                  _lngController,
                  'Longitud',
                  Icons.location_searching,
                  isNumeric: false,
                ),
                _buildTextField(
                  _emailController,
                  'Correo Electrónico',
                  Icons.email,
                  isEmail: true,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            widget.existingFine == null
                                ? 'Registrar Multa'
                                : 'Actualizar Multa',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xff6b4b3f),
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
    IconData icon, {
    bool isNumeric = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xff6b4b3f)),
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
            ? TextInputType.text // Permite el signo "-" en el teclado
            : isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa $label';
          }
          if (isEmail && !value.contains('@')) {
            return 'Ingresa un correo válido';
          }
          return null;
        },
      ),
    );
  }
}
