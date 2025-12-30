import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/usecases/get_nasa_history.dart';
import 'nasa_history_event.dart';
import 'nasa_history_state.dart';

class NasaHistoryBloc extends Bloc<NasaHistoryEvent, NasaHistoryState> {
  NasaHistoryBloc(GetNasaHistory getNasaHistory) : super(NasaHistoryInitial()) {
    on<LoadNasaHistory>((event, emit) async {

      emit(NasaHistoryLoading());

      if (event.reloadFail) {
        emit(NasaHistoryError('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง'));
        return;
      }

      final res = await getNasaHistory.execute(query: event.query);

      res.fold(
        (failure) {
          emit(NasaHistoryError('เกิดข้อผิดพลาด ไม่สามารถดึงข้อมูลได้ กรุณาลองใหม่อีกครั้ง'));
        },
        (result) {
          // if (event.count != null && event.count! > 0) {
          //   final limitedResult = result.take(event.count!).toList();
          //   emit(NasaHistoryHasData(limitedResult));
          //   return;
          // }

          if (result.isEmpty) {
            emit(NasaHistoryError('ไม่พบข้อมูล'));
          } else {
            emit(NasaHistoryHasData(result));
          }
        },
      );
    });
  }
}
