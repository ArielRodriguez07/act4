import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const Details({Key? key, required this.products}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final GlobalKey<AnimatedListState> _listKey;
  late List<Map<String, dynamic>> _localProducts;

  @override
  void initState() {
    super.initState();
    _localProducts = List<Map<String, dynamic>>.from(widget.products);
    _listKey = GlobalKey<AnimatedListState>();
  }

  void _removeProduct(int index) {
    final removedItem = _localProducts[index];
    _localProducts.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(removedItem, animation),
      duration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildRemovedItem(Map<String, dynamic> product, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.0, 0.0),
        ).animate(animation),
        child: ListTile(
          leading: const Icon(Icons.videogame_asset, color: Colors.grey),
          title: Text(product["inventarioID"] ?? ""),
          subtitle: Text("Videojuego: ${product["videojuegoID"] ?? ""}, Stock: ${product["cantidadStock"]?.toString() ?? ""}"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _localProducts);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF8B0000), // Rojo oscuro para BlondGames
          centerTitle: true,
          title: const Text("Tabla de Inventario"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, _localProducts),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        body: AnimatedList(
          key: _listKey,
          initialItemCount: _localProducts.length,
          padding: const EdgeInsets.all(4.0),
          itemBuilder: (context, index, animation) {
            final product = _localProducts[index];
            return SizeTransition(
              sizeFactor: animation,
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(width: 1.0, color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const Icon(Icons.videogame_asset, color: Color(0xFFDC143C)), // Carmesí
                  title: Text(
                    "ID Inventario: ${product["inventarioID"] ?? ""}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID Videojuego: ${product["videojuegoID"] ?? ""}"),
                      Text("Cantidad en Stock: ${product["cantidadStock"]?.toString() ?? ""}"),
                      Text("Ubicación: ${product["ubicacionAlmacen"] ?? ""}"),
                      Text("Última Actualización: ${product["fechaUltimaActualizacion"] != null ? "${(product["fechaUltimaActualizacion"] as DateTime).day}/${(product["fechaUltimaActualizacion"] as DateTime).month}/${(product["fechaUltimaActualizacion"] as DateTime).year}" : ""}"),
                      Text("Costo Unitario: \$${product["costoUnitario"]?.toStringAsFixed(2) ?? ""}"),
                      Text("Proveedor: ${product["proveedor"] ?? ""}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                    onPressed: () => _removeProduct(index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}