import 'package:app_proyecto_multas/models/fine.dart';
import 'package:app_proyecto_multas/repository/permisos.dart';
import 'package:app_proyecto_multas/screens/home_screen.dart';
import 'package:flutter/material.dart';

var api = "http://multa-infra.ddns.net";
final List<FineModel> finesList = [];
Permisos _permisos = Permisos();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _fetchFinesAndNavigate();
    _permisos.permisoUbicacionYGuardar();
  }

  Future<void> _fetchFinesAndNavigate() async {
    try {
      // Llamar a getFines
      List<FineModel> fetchedFines = await getFines(context);
      // Actualizar finesList global
      setState(() {
        finesList.clear();
        finesList.addAll(fetchedFines);
      });
      print("Multas obtenidas: ${finesList.length}");
    } catch (e) {
      print("Error al obtener las multas: $e");
    } finally {
      // Navegar al siguiente screen
      Future.delayed(Duration(seconds: 5), _navigateToNextScreen);
    }
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/multa.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 2),
            const Text(
              'Multas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
