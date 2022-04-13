import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadFirstChats extends ChatEvent {
  final String pofelId;
  const LoadFirstChats({required this.pofelId});

  @override
  List<Object> get props => [];
}

class ChatsUpdated extends ChatEvent {
  const ChatsUpdated();

  @override
  List<Object> get props => [];
}

class SendMessage extends ChatEvent {
  final String pofelId;
  final String message;
  const SendMessage({required this.message, required this.pofelId});

  @override
  List<Object> get props => [];
}
