import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import "package:vetic_assignment/di/service_locator.dart";
import "package:vetic_assignment/routes/app_routes.dart";
import "package:vetic_assignment/services/connectivity_service.dart";
import "package:vetic_assignment/services/database_service.dart";

/*
  Note:
  I have not used any AI code generation tools while developing this project.
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup dependency injection
  setupLocator();

  /// Initialize database and connectivity services
  await getIt<DatabaseService>().initGetStorage();
  await getIt<ConnectivityService>().startListening();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Vetic Assignment",
      theme: ThemeData(
        colorScheme: const .light(primary: Colors.black),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const .dark(primary: Colors.black),
        useMaterial3: true,
      ),
      getPages: AppRoutes().routes,
      builder: (BuildContext context, Widget? child) {
        /// Dismiss keyboard on tap outside
        return KeyboardDismisser(child: child);
      },
    );
  }
}
