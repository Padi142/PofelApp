import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/message_model.dart';

part "chat_state.g.dart";

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class ChatsLoaded extends ChatState {
  final List<MessageModel> messages;
  final ChatStateEnum chatStateEnum;

  const ChatsLoaded({required this.messages, required this.chatStateEnum});

  @override
  List<Object> get props => [messages];
}

enum ChatStateEnum {
  INITIAL,
  LOADED,
}
