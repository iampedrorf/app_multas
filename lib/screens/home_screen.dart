import 'package:flutter/material.dart';
import '../widgets/card_homePage.dart';
import 'add_fine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6b4b3f),
        title: const Text(
          'Menú Principal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xfff5f5f5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Banner informativo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xffe0e0e0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Color(0xff6b4b3f)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¡Recuerda revisar las multas pendientes para evitar cargos adicionales!',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Título amigable
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Selecciona una opción para continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff6b4b3f),
                ),
              ),
            ),
            // Grid de opciones con bordes redondeados
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  CardWidget(
                    icon: Icons.add_circle_outline,
                    color: Color(0xff6b4b3f),
                    title: 'Agregar Multas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddFine()),
                      );
                    },
                  ),
                  CardWidget(
                    icon: Icons.search_outlined,
                    color: Color(0xff6b4b3f),
                    title: 'Consultar Multas',
                    onTap: () {
                      // Acción para la segunda pantalla
                    },
                  ),
                  CardWidget(
                    icon: Icons.search_outlined,
                    color: Color(0xff6b4b3f),
                    title: 'Otroooooo',
                    onTap: () {
                      // Acción para la segunda pantalla
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
