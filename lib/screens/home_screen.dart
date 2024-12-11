import 'package:flutter/material.dart';
import '../widgets/card_homePage.dart';
import 'add_fine_screen.dart';
import 'fine_list.dart';
import 'map_screen.dart';

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
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Banner informativo
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xff6b4b3f), // Color de fondo del container
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '¡Recuerda revisar las multas pendientes para evitar cargos adicionales!',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  // Imagen en el lado derecho
                  Image.asset(
                    'assets/multaimage.png', // Ruta de tu imagen
                    width: 90, // Ajusta el tamaño según lo necesites
                    height: 90,
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
                  fontSize: 20,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FineList()),
                      );
                    },
                  ),
                  CardWidget(
                    icon: Icons.map_outlined,
                    color: Color(0xff6b4b3f),
                    title: 'Mapa',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()),
                      );
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
