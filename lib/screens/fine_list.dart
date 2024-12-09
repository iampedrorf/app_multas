import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FineList extends StatefulWidget {
  const FineList({super.key});

  @override
  State<FineList> createState() => _FineListState();
}

class _FineListState extends State<FineList> {
  final TextEditingController _plateController = TextEditingController();
  late List<Map<String, dynamic>> fines;
  late List<Map<String, dynamic>> filteredFines;

  final String apiUrl = 'http://localhost:3000/api/fines';

  @override
  void initState() {
    super.initState();
    fines = [];
    filteredFines = [];
    _fetchFines();
    _plateController.addListener(_filterFines);
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _fetchFines() async {
    final url = Uri.parse("http://localhost:3000/api/fines");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          fines = data
              .map((fine) => {
                    "id": fine["_id"],
                    "plate": fine["plate"],
                    "city": fine["city"],
                    "state": fine["state"],
                    "speed": fine["speed"],
                    "limit": fine["limit"],
                  })
              .toList();
          filteredFines =
              List.from(fines); // Inicialmente igual al listado completo
        });
      } else {
        throw Exception('Error al obtener las multas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las multas: $e');
    }
  }

  void _filterFines() {
    String query = _plateController.text.trim().toUpperCase();
    setState(() {
      filteredFines =
          fines.where((fine) => fine["plate"]!.contains(query)).toList();
    });
  }

  void _clearFilter() {
    _plateController.clear();
  }

  void _editFine(int index) async {
    
  }

  Future<void> _deleteFine(String id) async {
    final url = Uri.parse("http://localhost:3000/api/fines/$id");

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Multa eliminada exitosamente!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        await _fetchFines();
      } else {
        throw Exception('Error al eliminar la multa: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error al eliminar la multa: $e',
            style: TextStyle(color: Colors.white),
          ),
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
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredFines.length,
                      itemBuilder: (context, index) {
                        final fine = filteredFines[index];
                        return Dismissible(
                          key: Key(fine["plate"]),
                          background: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 16.0),
                              child:
                                  const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                          secondaryBackground: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final String fineId = fines[index]["id"];

                            if (direction == DismissDirection.startToEnd) {
                              _editFine;
                              return false;
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              _deleteFine(fineId);
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
                                        "Placa: ${fine["plate"]}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
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
                                            "${fine["city"]}, ${fine["state"]}",
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
                                            "Velocidad: ${fine["speed"]} km/h",
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
                                            "Límite: ${fine["limit"]} km/h",
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
