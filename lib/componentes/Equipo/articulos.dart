import 'package:flutter/material.dart';
import 'package:proyecto/theme/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto/componentes/Equipo/equipos1.dart';
import 'package:proyecto/componentes/Equipo/imagenes.dart';

class Articulos extends StatefulWidget {
  @override
  _ArticulosState createState() => _ArticulosState();
}

class _ArticulosState extends State<Articulos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#181a1f"),
      appBar: AppBar(title: const Text("Articulos")),
      body: Center(
        child: Column(children: [
          SizedBox(height: 20),
          Divider(
            height: 10,
          ),
          Ink(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              leading: Icon(Icons.devices_other),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Equipos", style: GoogleFonts.lato(fontSize: 19)),
                    Text(
                      "Detalle de Equipos",
                      style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
                    )
                  ]),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Equipos()));
              },
            ),
          ),
          Divider(
            height: 10,
          ),
          Ink(
            color: Theme.of(context)
                .primaryColor, // Un tono ligeramente diferente para el segundo elemento
            child: ListTile(
              leading: Icon(Icons.device_hub),
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Insumos", style: GoogleFonts.lato(fontSize: 19)),
                    Text(
                      "Detalle de Insumos",
                      style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
                    )
                  ]),
              trailing: Icon(Icons.arrow_forward_ios, size: 15),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Text("holaaa")));
              },
            ),
          ),
          Divider(
            height: 10,
          ),
          Ink(
              color: Theme.of(context).primaryColor,
              child: ListTile(
                leading: Icon(Icons.construction),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Herramientas",
                          style: GoogleFonts.lato(fontSize: 19)),
                      Text(
                        "Detalle de Herramientas",
                        style:
                            GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
                      )
                    ]),
                trailing: Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageUploadDownloadScreen()));
                },
              )),
          Divider(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
