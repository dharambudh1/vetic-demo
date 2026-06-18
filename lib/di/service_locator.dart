// ignore_for_file: cascade_invocations

import "package:get_it/get_it.dart";
import "package:vetic_assignment/data_flow/product_flow.dart";
import "package:vetic_assignment/services/api_service.dart";
import "package:vetic_assignment/services/connectivity_service.dart";
import "package:vetic_assignment/services/database_service.dart";
import "package:vetic_assignment/services/favourite_service.dart";
import "package:vetic_assignment/services/navigation_service.dart";

/// Service locator instance
final GetIt getIt = GetIt.instance;

/// Setup service locator
void setupLocator() {
  getIt.registerLazySingleton<APIService>(APIService.new);
  getIt.registerLazySingleton<DatabaseService>(DatabaseService.new);
  getIt.registerLazySingleton<FavouriteService>(FavouriteService.new);
  getIt.registerLazySingleton<NavigationService>(NavigationService.new);
  getIt.registerLazySingleton<ProductFlow>(ProductFlow.new);
  getIt.registerLazySingleton<ConnectivityService>(ConnectivityService.new);

  return;
}
