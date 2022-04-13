// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatsLoadedCWProxy {
  ChatsLoaded chatStateEnum(ChatStateEnum chatStateEnum);

  ChatsLoaded errorMessage(String errorMessage);

  ChatsLoaded messages(List<MessageModel> messages);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatsLoaded(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatsLoaded(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatsLoaded call({
    ChatStateEnum? chatStateEnum,
    String? errorMessage,
    List<MessageModel>? messages,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChatsLoaded.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChatsLoaded.copyWith.fieldName(...)`
class _$ChatsLoadedCWProxyImpl implements _$ChatsLoadedCWProxy {
  final ChatsLoaded _value;

  const _$ChatsLoadedCWProxyImpl(this._value);

  @override
  ChatsLoaded chatStateEnum(ChatStateEnum chatStateEnum) =>
      this(chatStateEnum: chatStateEnum);

  @override
  ChatsLoaded errorMessage(String errorMessage) =>
      this(errorMessage: errorMessage);

  @override
  ChatsLoaded messages(List<MessageModel> messages) => this(messages: messages);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChatsLoaded(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChatsLoaded(...).copyWith(id: 12, name: "My name")
  /// ````
  ChatsLoaded call({
    Object? chatStateEnum = const $CopyWithPlaceholder(),
    Object? errorMessage = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
  }) {
    return ChatsLoaded(
      chatStateEnum:
          chatStateEnum == const $CopyWithPlaceholder() || chatStateEnum == null
              ? _value.chatStateEnum
              // ignore: cast_nullable_to_non_nullable
              : chatStateEnum as ChatStateEnum,
      errorMessage:
          errorMessage == const $CopyWithPlaceholder() || errorMessage == null
              ? _value.errorMessage
              // ignore: cast_nullable_to_non_nullable
              : errorMessage as String,
      messages: messages == const $CopyWithPlaceholder() || messages == null
          ? _value.messages
          // ignore: cast_nullable_to_non_nullable
          : messages as List<MessageModel>,
    );
  }
}

extension $ChatsLoadedCopyWith on ChatsLoaded {
  /// Returns a callable class that can be used as follows: `instanceOfclass ChatsLoaded extends ChatState.name.copyWith(...)` or like so:`instanceOfclass ChatsLoaded extends ChatState.name.copyWith.fieldName(...)`.
  _$ChatsLoadedCWProxy get copyWith => _$ChatsLoadedCWProxyImpl(this);
}
