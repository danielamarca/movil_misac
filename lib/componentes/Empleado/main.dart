import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto/componentes/Empleado/empleados.dart';

class MainEmpleado extends StatefulWidget {
  @override
  _MainEmpleadoState createState() => _MainEmpleadoState();
}

class _MainEmpleadoState extends State<MainEmpleado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Empleados"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Divider(
                height: 10,
              ),
              Ink(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Empleados",
                            style: GoogleFonts.lato(fontSize: 19)),
                        Text(
                          "Detalle de Empleados",
                          style: GoogleFonts.lato(
                              fontSize: 13, color: Colors.cyan),
                        )
                      ]),
                  trailing: Icon(Icons.arrow_forward_ios, size: 15),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Empleados()));
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
                  leading: Icon(Icons.engineering),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Técnicos", style: GoogleFonts.lato(fontSize: 19)),
                        Text(
                          "Detalle de Técnicos",
                          style: GoogleFonts.lato(
                              fontSize: 13, color: Colors.cyan),
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
            ],
          ),
        ));
  }
}
