import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safwatx/screens/home_screen.dart';
import 'package:safwatx/utils/appColors.dart';
import 'providers/network_provider.dart';
import 'package:local_notifier/local_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await localNotifier.setup(
    appName: 'SafwatX',
    // The parameter shortcutPolicy only works on Windows
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize data when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delayed initialization after the build phase
      Future.microtask(() {
        final provider = Provider.of<NetworkProvider>(context, listen: false);
        provider.initializeData(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<NetworkProvider>(context,   );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZiadCut',
       theme: provider.mode,
      darkTheme: myTheme(Brightness.dark),
      home: NetworkScreen(),
    );
  }
}
