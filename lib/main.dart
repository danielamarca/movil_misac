import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/global.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto/theme/theme.dart';
import 'package:proyecto/componentes/Equipo/equipos.dart';
import 'package:proyecto/componentes/Servicio/servicio.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LogginProvider(),
    child: const Proyecto(),
  ));
}

class Proyecto extends StatelessWidget {
  const Proyecto({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto de Grado',
      theme: ThemeData(
        // Tema Claro
        brightness: Brightness.light,
        primaryColor: Color(0xFFE3B23C),
        scaffoldBackgroundColor: Color(0xFFF0EDE5),
        colorScheme: ColorScheme.light(
          primary: Color(0xFFE3B23C),
          secondary: Color(0xFFE3B23C), // Sustituye el antiguo accentColor
          error: Color(0xFFBA1B1B), // Rojo para errores
          // Define otros colores del esquema si lo deseas
        ),
        // Aquí puedes definir colores personalizados adicionales
      ),
      darkTheme: ThemeData(
        // Tema Oscuro
        brightness: Brightness.dark,
        primaryColor: Color(0xFF081A2B),
        scaffoldBackgroundColor: Color(0xFF2A2C2B),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFE3B23C),
          secondary: Color(0xFFE3B23C), // Sustituye el antiguo accentColor
          error: Color(0xFFCF6679), // Rojo oscuro para errores
          // Define otros colores del esquema si lo deseas
        ),
        // Aquí puedes definir colores personalizados adicionales
      ),
      home: const Login(titulo: 'proyecto'),
    );
  }
}

class Login extends StatefulWidget {
  final String titulo;
  const Login({super.key, required this.titulo});
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  String _mensajeInicio = '';
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    // Agrega un listener para detectar cambios en el MediaQuery
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showImage = MediaQuery.of(context).viewInsets.bottom == 0;
      });
    });
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final provider = Provider.of<LogginProvider>(context, listen: false);
    int isLoggedIn = await provider.login(
        _usuarioController.text, _contrasenaController.text);
    switch (isLoggedIn) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainHome(user: provider.user!.username)),
        );
        break;
      case 1:
        setState(() {
          _mensajeInicio = "Usuario o contraseña incorrecta";
        });
        break;
      case 2:
        setState(() {
          _mensajeInicio = "Error de conexión con el servidor...!";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    if (_showImage && keyboardOpen) {
      _showImage = false;
    } else if (!_showImage && !keyboardOpen) {
      _showImage = true;
    }

    return Scaffold(
        backgroundColor:
            HexColor.fromHex("#181a1f"), // Establece el color de fondo aquí

        body: Stack(
          children: [
            DarkRadialBackground(
                color: HexColor.fromHex("#181a1f"), position: "topLeft"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    if (_showImage)
                      Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.2,
                              colors: <Color>[Colors.black, Colors.transparent],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.asset("./assets/logo.png",
                              width: 200, height: 200),
                        ),
                      ),
                    Text(
                      'Ingreso',
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style:
                            GoogleFonts.lato(color: HexColor.fromHex("676979")),
                        children: const <TextSpan>[
                          TextSpan(
                              text: "Ingrese usuario y contraseña",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Usuario".toUpperCase(),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: HexColor.fromHex("FFFFFF"))),
                    TextFormField(
                      controller: _usuarioController,
                      onTap: () {},
                      style: GoogleFonts.lato(
                          color: HexColor.fromHex("FFFFFF"),
                          fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    Text("Contraseña".toUpperCase(),
                        style: GoogleFonts.lato(
                            fontSize: 15, color: HexColor.fromHex("FFFFFF"))),
                    TextFormField(
                      controller: _contrasenaController,
                      onTap: () {},
                      style: GoogleFonts.lato(
                          color: HexColor.fromHex("FFFFFF"),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xFFE3B23C)),
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: const BorderSide(width: 1.0)))),
                            onPressed: _handleLogin,
                            child: Text("Ingresar",
                                style: GoogleFonts.lato(
                                    fontSize: 20, color: Colors.white)))),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              _mensajeInicio,
                              style: GoogleFonts.lato(
                                  color: Colors.redAccent, fontSize: 17),
                            ))),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class MainHome extends StatefulWidget {
  final String user;
  const MainHome({super.key, required this.user});
  @override
  State<MainHome> createState() => _MainHome();
}

class _MainHome extends State<MainHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          HexColor.fromHex("#181a1f"), // Establece el color de fondo aquí

      appBar: AppBar(
        title: const Text("Menu Principal"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(widget.user.toUpperCase(),
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFFE3B23C)))),
              accountName: Text("Bienvenido ${widget.user}",
                  style: GoogleFonts.lato(fontSize: 22)),
              accountEmail:
                  Text("email:"), // Puedes dejarlo vacío si no lo necesitas
              decoration: BoxDecoration(
                color: Color(0xFFE3B23C),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'Inicio',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Perfil',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Configuraciones',
                  style: GoogleFonts.lato(fontSize: 17)),
              onTap: () {
                // Navega a la pantalla de configuraciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: Text(
                'Cerrar Sesión',
                style: GoogleFonts.lato(fontSize: 17),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Login(titulo: "Inicio")),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: ContentHome(),
      ),
    );
  }
}

class ContentHome extends StatefulWidget {
  const ContentHome({super.key});
  @override
  State<StatefulWidget> createState() => _ContentHome();
}

class _ContentHome extends State<ContentHome> {
  @override
  Widget build(BuildContext context) {
    return (Column(
      children: [
        SizedBox(height: 20),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Color de fondo claro para el primer elemento
          child: ListTile(
            leading: Icon(Icons.task),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Servicios y Tareas", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de servicios y tareas",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Servicio()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Un tono ligeramente diferente para el segundo elemento
          child: ListTile(
            leading: Icon(Icons.shopping_bag),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Ventas", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de ventas",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {},
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context)
              .primaryColor, // Alterna los colores para cada elemento
          child: ListTile(
            leading: Icon(Icons.add_box_sharp),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Productos", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de  productos",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder:(context)=>Equipos()));
            },
          ),
        ),
        Divider(
          height: 1,
        ),
        Ink(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
            ),
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Clientes", style: GoogleFonts.lato(fontSize: 19)),
              Text(
                "Lista de clientes",
                style: GoogleFonts.lato(fontSize: 13, color: Colors.cyan),
              )
            ]),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            onTap: () {},
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    ));
  }
}

class Servicios extends StatefulWidget {
  @override
  _ServiciosState createState() => _ServiciosState();
}

class _ServiciosState extends State<Servicios> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Navegar hacia atrás
        ),
      ),
      body: Center(
        child: Text('Página $_selectedIndex'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, // Mejor distribución
          children: <Widget>[
            _buildTabItem(
              index: 0,
              icon: Icon(
                Icons.home,
                size: 33,
              ),
              label: 'Inicio',
            ),
            Spacer(), // Mejor manejo del espacio para el botón central

            _buildTabItem(
              index: 1,
              icon: Icon(
                Icons.business,
                size: 33,
              ),
              label: 'Negocios',
            ),
            Spacer(), // Mejor manejo del espacio para el botón central
            Spacer(), // Mejor manejo del espacio para el botón central
            Spacer(), // Mejor manejo del espacio para el botón central
            _buildTabItem(
              index: 2,
              icon: Icon(
                Icons.school,
                size: 33,
              ),
              label: 'Escuela',
            ),
            Spacer(), // Mejor manejo del espacio para el botón central

            _buildTabItem(
              index: 3,
              icon: Icon(
                Icons.person,
                size: 33,
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
      floatingActionButton: _buildGradientButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGradientButton() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 60, // Tamaño del botón, ajustar según sea necesario
          height: 60, // Tamaño del botón, ajustar según sea necesario
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 231, 193, 39),
                Color.fromARGB(255, 175, 142, 8),
                Color.fromARGB(255, 7, 51, 103),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              // Agregar sombra si se desea
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Acción para el botón central
          },
          backgroundColor: Colors.transparent, // Botón transparente
          elevation: 0, // Quitar sombra
        ),
      ],
    );
  }
  Widget _buildTabItem({
    required int index,
    required Icon icon,
    String? label,
  }) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: icon,
      color: isSelected ? Color.fromARGB(255, 227, 205, 107) : Colors.white,
      onPressed: () => _onItemTapped(index),
    );
  }
}
