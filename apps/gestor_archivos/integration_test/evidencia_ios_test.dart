import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_archivos/main.dart' as app;
import 'package:integration_test/integration_test.dart';

Future<void> captura(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
  String nombre,
) async {
  await tester.pump(const Duration(milliseconds: 800));
  await binding.takeScreenshot(nombre);
  // La captura nativa de iOS se completa de forma asíncrona; esperar evita
  // que dos capturas se solapen y que el PNG no corresponda a la pantalla.
  await Future<void>.delayed(const Duration(milliseconds: 500));
}

Future<void> volver(WidgetTester tester) async {
  final boton = find.byType(BackButton);
  if (boton.evaluate().isNotEmpty) {
    await tester.tap(boton.first);
  } else {
    Navigator.of(tester.element(find.byType(Scaffold).first)).pop();
  }
  await tester.pumpAndSettle();
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Recorrido de evidencia del gestor', (tester) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    }
    await app.main();
    await tester.pumpAndSettle();
    await captura(tester, binding, '01-inicio-guinda');

    // Cambiar al tema Azul ESCOM.
    await tester.tap(find.byKey(const Key('btn-tema')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Azul ESCOM').last);
    await tester.pump();
    await tester.tap(find.text('Listo'));
    await tester.pumpAndSettle();
    await captura(tester, binding, '02-tema-azul');

    // Explorar los archivos de ejemplo.
    await tester.tap(find.byKey(const Key('entrada-Ejemplos')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '03-explorador');

    // Visor JSON.
    await tester.tap(find.byKey(const Key('entrada-datos.json')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '04-visor-json');
    await volver(tester);

    // Visor XML.
    await tester.tap(find.byKey(const Key('entrada-configuracion.xml')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '05-visor-xml');
    await volver(tester);

    // Visor de imagen.
    await tester.tap(find.byKey(const Key('entrada-paisaje_escom.png')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '06-visor-imagen');
    await tester.tap(find.byKey(const Key('imagen-girar')));
    await tester.pump(const Duration(milliseconds: 400));
    await captura(tester, binding, '07-imagen-girada');
    await volver(tester);

    // Archivo sin visor interno.
    await tester.tap(find.byKey(const Key('entrada-muestra.xyz')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '08-formato-no-soportado');
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // Recientes y modo oscuro automático.
    await tester.tap(find.byKey(const Key('nav-recientes')));
    await tester.pumpAndSettle();
    await captura(tester, binding, '09-recientes');
    tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    await captura(tester, binding, '10-modo-oscuro');
    tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pumpAndSettle();
  });
}
