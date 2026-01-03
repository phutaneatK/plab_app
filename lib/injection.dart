import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:plab_app/core/config/app_config.dart';

// NASA imports
import 'package:plab_api/data/datasources/nasa_remote_datasource.dart';
import 'package:plab_api/data/repositories/nasa_repository_impl.dart';
import 'package:plab_api/domain/repositories/nasa_repository.dart';
import 'package:plab_api/domain/usecases/get_nasa_history.dart';
import 'package:plab_app/presentation/nasa/bloc/nasa_history_bloc.dart';
import 'package:plab_app/presentation/nasa/cubit/nasa_search_query_cubit.dart';

// Chat imports
import 'package:plab_api/data/datasources/chat_remote_datasource.dart';
import 'package:plab_api/data/repositories/chat_repository_impl.dart';
import 'package:plab_api/domain/repositories/chat_repository.dart';
import 'package:plab_api/domain/usecases/get_chat_history.dart';
import 'package:plab_api/domain/usecases/get_chat_messages_stream.dart';
import 'package:plab_api/domain/usecases/send_chat_message.dart';
import 'package:plab_app/presentation/chat/bloc/chat_bloc.dart';

// PM2.5 imports
import 'package:plab_api/data/datasources/pm_remote_datasource.dart';
import 'package:plab_api/domain/repositories/pm_repositoty.dart';
import 'package:plab_api/domain/usecases/get_pm_history.dart';
import 'package:plab_api/data/repositories/pm_repository_impl.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_bloc.dart';

final getIt = GetIt.instance;

void initGetIt() {
  // ==================== CONFIG ====================
  // อ่าน environment variables ครั้งเดียวตอนเริ่มต้น
  final config = AppConfig.fromEnv();
  getIt.registerSingleton<AppConfig>(config);

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // ==================== NASA ====================
  // Data sources
  getIt.registerLazySingleton<NasaRemoteDatasource>(
    () => NasaRemoteDatasourceImp(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<NasaRepository>(() => NasaRepoImpl(getIt()));

  // Use cases
  getIt.registerLazySingleton<GetNasaHistory>(() => GetNasaHistory(getIt()));

  // Blocs
  getIt.registerFactory<NasaHistoryBloc>(() => NasaHistoryBloc(getIt()));

  // Cubits
  // ใช้ LazySingleton เพราะต้องการให้ state เดียวกันทั่วทั้ง app
  getIt.registerLazySingleton<NasaSearchQueryCubit>(
    () => NasaSearchQueryCubit(),
  );

  // ==================== CHAT ====================
  // Data sources
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiKey: getIt<AppConfig>().geminiApiKey),
  );

  // Repositories
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton<GetChatMessagesStream>(
    () => GetChatMessagesStream(getIt()),
  );

  getIt.registerLazySingleton<SendChatMessage>(() => SendChatMessage(getIt()));

  getIt.registerLazySingleton<GetChatHistory>(() => GetChatHistory(getIt()));

  // Blocs
  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      getChatMessagesStream: getIt(),
      sendChatMessage: getIt(),
      getChatHistory: getIt(),
      chatRepository: getIt(),
    ),
  );

  // ==================== PM2.5 ====================

  // Data sources
  getIt.registerLazySingleton<PMRemoteDatasource>(
    () => PMRemoteDatasourceImpl(token: getIt<AppConfig>().pmApiKey),
  );

  // Repositories
  getIt.registerLazySingleton<PMRepository>(() => PMRepositoryImpl(getIt()));

  // Use cases
  getIt.registerLazySingleton<GetPmHistory>(() => GetPmHistory(getIt()));

  // Blocs
  getIt.registerFactory<Pm25Bloc>(() => Pm25Bloc(getIt()));
}
