import 'package:equatable/equatable.dart';
import 'package:plab_api/domain/entities/pm_entity.dart';

abstract class Pm25State extends Equatable {
  @override
  List<Object?> get props => [];
}

class Pm25Initial extends Pm25State {}

class Pm25Loading extends Pm25State {}

class Pm25HasHasData extends Pm25State {
  final List<PmEntity> datas;

  Pm25HasHasData(this.datas);

  @override
  List<Object?> get props => [datas];
}

class Pm25Error extends Pm25State {
  final String message;

  Pm25Error(this.message);

  @override
  List<Object?> get props => [message];
}