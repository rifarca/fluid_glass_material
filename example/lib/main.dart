import 'package:flutter/material.dart';
import 'package:fluid_glass_material/fluid_glass_material.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  double intensity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fluid Glass Material")),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 30,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text("Item $i"),
                ).fluidGlass(type: FluidGlassType.thin),
              );
            },
          ),

          // Navbar glass
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              alignment: Alignment.center,
              child: const Text("Glass Navbar", style: TextStyle(fontSize: 18)),
            ).fluidGlass(type: FluidGlassType.regular),
          ),
        ],
      ),
    );
  }
}
