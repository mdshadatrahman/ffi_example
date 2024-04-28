import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bundle = await rootBundle.load('assets/librust_core.so');
  final docDir = await getApplicationDocumentsDirectory();
  final libPath = join(docDir.path, 'librust_core.so');
  final libFile = await File(libPath).writeAsBytes(bundle.buffer.asUint8List());
  if (!libFile.existsSync()) {
    await libFile.create(recursive: true);
  }
  await libFile.writeAsBytes(bundle.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              final docDir = await getApplicationDocumentsDirectory();
              final libPath = join(docDir.path, 'librust_core.so');
              final dylib = DynamicLibrary.open(libPath);

              final printfunc = dylib.lookupFunction<Void Function(), void Function()>('print_helloworld');
              printfunc();
            },
            child: const Text('Press me'),
          ),
        ),
      ),
    );
  }
}
