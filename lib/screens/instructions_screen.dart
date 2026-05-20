import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instrucciones')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('¿Cómo jugar al Buscaminas?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('1. El objetivo del juego es despejar todo el campo sin detonar ninguna mina.'),
            SizedBox(height: 10),
            Text('2. Toca una casilla para revelarla. Si es una mina, ¡pierdes!'),
            SizedBox(height: 10),
            Text('3. Si la casilla está segura, mostrará un número que indica cuántas minas hay en las 8 casillas a su alrededor.'),
            SizedBox(height: 10),
            Text('4. Usa esos números para deducir dónde están las minas.'),
            SizedBox(height: 10),
            Text('5. Si crees saber dónde hay una mina, haz clic derecho (o mantén presionado) para colocar una bandera 🚩.'),
            SizedBox(height: 10),
            Text('6. ¡Ganas cuando revelas todas las casillas que no tienen minas!'),
          ],
        ),
      ),
    );
  }
}