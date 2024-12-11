import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/fine.dart';
import 'add_fine_screen.dart';

class FineList extends StatefulWidget {
  const FineList({super.key});

  @override
  State<FineList> createState() => _FineListState();
}

class _FineListState extends State<FineList> {
  final TextEditingController _plateController = TextEditingController();
  late List<FineModel> fines;
  late List<FineModel> filteredFines;

  @override
  void initState() {
    super.initState();
    fines = [];
    filteredFines = [];
    _fetchFines(); // Cargar multas cuando se inicie la pantalla
    _plateController.addListener(_filterFines);
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _fetchFines() async {
    try {
      List<FineModel> fetchedFines =
          await getFines(context); // Traer las multas actualizadas
      setState(() {
        fines = fetchedFines;
        filteredFines = List.from(fines); // Filtrar las multas
      });
    } catch (e) {
      print("Error al obtener multas: $e");
    }
  }

  void _filterFines() {
    String query = _plateController.text.trim().toUpperCase();
    setState(() {
      filteredFines = fines
          .where((fine) => fine.plate.toUpperCase().contains(query))
          .toList();
    });
  }

  void _clearFilter() {
    _plateController.clear();
  }

  void _editFine(int index) async {
    final fineToEdit = fines[index];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFine(existingFine: fineToEdit),
      ),
    );

    if (result == true) {
      _fetchFines(); // Recargar la lista después de actualizar
    }
  }

  Future<void> deleteFine(
      BuildContext context, String fineId, int index) async {
    var url = Uri.parse("$api/api/fines/$fineId");

    if (await InternetConnectionChecker().hasConnection) {
      try {
        var response = await http.delete(url).timeout(
          Duration(seconds: 60),
          onTimeout: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Color(0xfffd687b),
                content: Text("Red inestable. Por favor, intente más tarde"),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1, milliseconds: 500),
              ),
            );
            return http.Response('{}', 408);
          },
        );

        print('Respuesta de delete: ${response.body}');
        if (response.statusCode == 200) {
          // El recurso fue eliminado con éxito
          print('Multa eliminada correctamente');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("Multa eliminada con éxito."),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );

          // Aquí se elimina la multa de la lista
          setState(() {
            fines.removeAt(index); // Elimina de la lista original
            filteredFines.removeAt(index); // Elimina de la lista filtrada
          });
        } else {
          // Manejo de otros códigos de error (401, 404, 500, etc.)
          // ...
        }
      } catch (e) {
        print('Error al eliminar multa: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xfffd687b),
            content: Text("Error al intentar eliminar la multa."),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Si no hay conexión a internet
      print('Sin conexión a internet');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xfffd687b),
          content: Text("Sin conexión a internet. Intente nuevamente."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6b4b3f),
        title: const Text(
          'Consultar Multa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _plateController,
                    decoration: const InputDecoration(
                      hintText: "Ingrese las siglas de la placa",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _clearFilter,
                  icon: const Icon(Icons.clear),
                  color: Colors.black,
                  tooltip: 'Limpiar',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredFines.isEmpty
                  ? Center(
                      child: Text(
                        "No se encontraron multas.",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredFines.length,
                      itemBuilder: (context, index) {
                        final fine = filteredFines[index];
                        return Dismissible(
                          key: Key(fine.plate),
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Color(0xffA9C9A1),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16.0),
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                          secondaryBackground: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Color(0xffB24C47),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _editFine(index);
                              return false;
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              deleteFine(context, fine.id, index);
                              return false;
                            }
                            return null;
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_car,
                                          color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Placa: ${fine.plate}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city,
                                              color: Colors.orange),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${fine.city}, ${fine.state}",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.speed,
                                              color: Colors.red),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Velocidad: ${fine.speed} km/h",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.traffic,
                                              color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Límite: ${fine.limit} km/h",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
