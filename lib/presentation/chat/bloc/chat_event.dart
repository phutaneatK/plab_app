import 'package:equatable/equatable.dart';
import 'package:plab_api/domain/entities/chat_message_entity.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConnectChat extends ChatEvent {}

class DisconnectChat extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ReceiveMessage extends ChatEvent {
  final ChatMessageEntity message;

  ReceiveMessage(this.message);

  @override
  List<Object?> get props => [message];
}
