import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:plab_api/data/datasources/nasa_remote_datasource.dart';
import 'package:plab_api/data/repositories/nasa_repository_imp.dart';
import 'package:plab_api/domain/repositories/nasa_repository.dart';
import 'package:plab_api/domain/usecases/get_nasa_history.dart';
import 'package:plab_app/presentation/nasa_history/bloc/nasa_history_bloc.dart';
import 'package:plab_app/presentation/nasa_history/cubit/nasa_search_query_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  getIt.registerLazySingleton<NasaRemoteDatasource>(
    () => NasaRemoteDatasourceImp(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<NasaRepository>(
    () => NasaRepoImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<GetNasaHistory>(
    () => GetNasaHistory(getIt()),
  );

  // Blocs
  getIt.registerFactory<NasaHistoryBloc>(
    () => NasaHistoryBloc(getIt()),
  );

  // Cubits
  // ใช้ LazySingleton เพราะต้องการให้ state เดียวกันทั่วทั้ง app
  getIt.registerLazySingleton<NasaSearchQueryCubit>(
    () => NasaSearchQueryCubit(),
  );
}
