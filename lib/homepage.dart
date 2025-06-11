import 'package:flutter/material.dart';
import 'package:myapp/details.dart'; // Asegúrate de que este archivo exista y contenga la pantalla que muestra la lista de inventario

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _inventarioIDController = TextEditingController();
  final TextEditingController _videojuegoIDController = TextEditingController();
  final TextEditingController _cantidadStockController = TextEditingController();
  final TextEditingController _ubicacionAlmacenController = TextEditingController();
  final TextEditingController _fechaUltimaActualizacionController = TextEditingController();
  final TextEditingController _costoUnitarioController = TextEditingController();
  final TextEditingController _proveedorController = TextEditingController();

  final List<Map<String, dynamic>> _inventoryItems = [];

  @override
  void dispose() {
    _inventarioIDController.dispose();
    _videojuegoIDController.dispose();
    _cantidadStockController.dispose();
    _ubicacionAlmacenController.dispose();
    _fechaUltimaActualizacionController.dispose();
    _costoUnitarioController.dispose();
    _proveedorController.dispose();
    super.dispose();
  }

  void _saveAndNavigate(BuildContext context) {
    final String inventarioID = _inventarioIDController.text.trim();
    final String videojuegoID = _videojuegoIDController.text.trim();
    final int? cantidadStock = int.tryParse(_cantidadStockController.text.trim());
    final String ubicacionAlmacen = _ubicacionAlmacenController.text.trim();
    final double? costoUnitario = double.tryParse(_costoUnitarioController.text.trim());
    final String proveedor = _proveedorController.text.trim();

    DateTime? selectedDate;
    try {
      final parts = _fechaUltimaActualizacionController.text.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        selectedDate = DateTime(year, month, day);
      }
    } catch (e) {
      selectedDate = null;
      print('Error al parsear la fecha: $e');
    }

    if (inventarioID.isNotEmpty &&
        videojuegoID.isNotEmpty &&
        cantidadStock != null &&
        ubicacionAlmacen.isNotEmpty &&
        selectedDate != null &&
        costoUnitario != null &&
        proveedor.isNotEmpty) {
      setState(() {
        _inventoryItems.add({
          "inventarioID": inventarioID,
          "videojuegoID": videojuegoID,
          "cantidadStock": cantidadStock,
          "ubicacionAlmacen": ubicacionAlmacen,
          "fechaUltimaActualizacion": selectedDate,
          "costoUnitario": costoUnitario,
          "proveedor": proveedor,
        });
        _inventarioIDController.clear();
        _videojuegoIDController.clear();
        _cantidadStockController.clear();
        _ubicacionAlmacenController.clear();
        _fechaUltimaActualizacionController.clear();
        _costoUnitarioController.clear();
        _proveedorController.clear();
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(products: _inventoryItems),
        ),
      ).then((updatedProducts) {
        if (updatedProducts != null && updatedProducts is List<Map<String, dynamic>>) {
          setState(() {
            _inventoryItems
              ..clear()
              ..addAll(updatedProducts);
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, llena todos los campos obligatorios, asegúrate que el stock y el costo sean números y la fecha sea válida.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: const Text(
          "Formulario de Inventario - BlondGames",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B0000), // Rojo oscuro
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () { /* Manejar búsqueda */ },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () { /* Manejar configuración */ },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF8B0000)),
              accountName: const Text("Ariel Rodriguez"),
              accountEmail: const Text("a.22308051280706@cbtis128.edu.mx"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(
                        'https://raw.githubusercontent.com/ArielRodriguez07/images/refs/heads/main/channels4_profile.jpg'), // Imagen de BlondGames
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(products: _inventoryItems),
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.videogame_asset, color: Color(0xFFDC143C)), // Carmesí
                title: Text("Tabla de Inventario"),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            MyTextField(
              myController: _inventarioIDController,
              fieldName: "ID de Inventario",
              myIcon: Icons.qr_code,
              prefixIconColor: const Color(0xFFDC143C),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _videojuegoIDController,
              fieldName: "ID de Videojuego",
              myIcon: Icons.gamepad,
              prefixIconColor: const Color(0xFFDC143C),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _cantidadStockController,
              fieldName: "Cantidad en Stock",
              myIcon: Icons.category,
              prefixIconColor: const Color(0xFFDC143C),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _ubicacionAlmacenController,
              fieldName: "Ubicación en Almacén",
              myIcon: Icons.warehouse,
              prefixIconColor: const Color(0xFFDC143C),
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              onTap: () async {
                DateTime initialDateForPicker;
                try {
                  final parts = _fechaUltimaActualizacionController.text.split('/');
                  initialDateForPicker = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
                } catch (e) {
                  initialDateForPicker = DateTime.now();
                }

                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialDateForPicker,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF8B0000), // Rojo oscuro
                          onPrimary: Colors.white,
                          onSurface: Colors.black87,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF8B0000), // Rojo oscuro
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _fechaUltimaActualizacionController.text = "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              child: AbsorbPointer(
                child: MyTextField(
                  myController: _fechaUltimaActualizacionController,
                  fieldName: "Fecha Última Actualización (DD/MM/AAAA)",
                  myIcon: Icons.calendar_today,
                  prefixIconColor: const Color(0xFFDC143C),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _costoUnitarioController,
              fieldName: "Costo Unitario",
              myIcon: Icons.attach_money,
              prefixIconColor: const Color(0xFFDC143C),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 15.0),
            MyTextField(
              myController: _proveedorController,
              fieldName: "Proveedor",
              myIcon: Icons.local_shipping,
              prefixIconColor: const Color(0xFFDC143C),
            ),
            const SizedBox(height: 30.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color(0xFF8B0000), // Rojo oscuro
              ),
              onPressed: () => _saveAndNavigate(context),
              child: Text(
                "Agregar a Inventario".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.fieldName,
    required this.myController,
    this.myIcon = Icons.verified_user_outlined,
    this.prefixIconColor = Colors.blueAccent,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController myController;
  final String fieldName;
  final IconData myIcon;
  final Color prefixIconColor;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: fieldName,
        prefixIcon: Icon(myIcon, color: prefixIconColor),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDC143C)), // Carmesí para el borde enfocado
        ),
        labelStyle: const TextStyle(color: Color(0xFF8B0000)), // Rojo oscuro para el texto de la etiqueta
      ),
    );
  }
}