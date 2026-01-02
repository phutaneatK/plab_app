import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/usecases/get_pm_history.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_event.dart';
import 'package:plab_app/presentation/pm25/blocs/pm25_state.dart';
import 'package:plab_app/utlis.dart';

class Pm25Bloc extends Bloc<Pm25Event, Pm25State> {
  final GetPmHistory getPmHistory;

  Pm25Bloc(this.getPmHistory) : super(Pm25Initial()) {
    on<loadPm25History>((event, emit) async {
      emit(Pm25Loading());

      log('Pm25Bloc: loadPm25History ~ ');

      final res = await getPmHistory.execute();
      res.fold(
        (failure) => emit(
          Pm25Error(failure.message ?? 'เกิดข้อผิดพลาด ไม่สามารถดึงข้อมูลได้'),
        ),
        (results) {
          log("Pm25Bloc: Loaded ${results.length} records");
          return emit(Pm25HasHasData(results));
        },
      );
    });
  }
}
