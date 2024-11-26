import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

const PIKU_COLOR_PRIMARY = Color(0xFFFFAB00);
const PIKU_BG_COLOR = Color(0xfff4f6fb);
const PIKU_AVATAR_COLORS = [PIKU_COLOR_PRIMARY];

/// Default Piku chat theme which extends [ChatTheme]
@immutable
class PikuChatTheme extends ChatTheme {
  /// Creates a Piku chat theme. Use this constructor if you want to
  /// override only a couple of variables.
  const PikuChatTheme({
    super.attachmentButtonIcon,
    super.backgroundColor = PIKU_BG_COLOR,
    super.dateDividerTextStyle = const TextStyle(
      color: Colors.black26,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    super.deliveredIcon,
    super.documentIcon,
    super.emptyChatPlaceholderTextStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.errorColor = Colors.red,
    super.errorIcon,
    super.inputBackgroundColor = Colors.white,
    super.inputBorderRadius = const BorderRadius.all(
      Radius.circular(10),
    ),
    super.inputTextColor = Colors.black87,
    super.inputTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.messageBorderRadius = 20.0,
    super.primaryColor = PIKU_COLOR_PRIMARY,
    super.receivedMessageBodyTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.receivedMessageCaptionTextStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    super.receivedMessageDocumentIconColor = PIKU_COLOR_PRIMARY,
    super.receivedMessageLinkDescriptionTextStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    super.receivedMessageLinkTitleTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    super.secondaryColor = Colors.white,
    super.seenIcon,
    super.sendButtonIcon,
    super.sendingIcon,
    super.sentMessageBodyTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    super.sentMessageCaptionTextStyle = const TextStyle(
      color: Colors.white54,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    super.sentMessageDocumentIconColor = Colors.white54,
    super.sentMessageLinkDescriptionTextStyle = const TextStyle(
      color: Colors.white54,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    super.sentMessageLinkTitleTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    super.userAvatarNameColors = PIKU_AVATAR_COLORS,
    super.userAvatarTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    super.userNameTextStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    EdgeInsets padding4 = const EdgeInsets.all(4),
    EdgeInsets padding8 = const EdgeInsets.all(8),
    EdgeInsets padding12 = const EdgeInsets.all(12),
    EdgeInsets paddingHorSym8 = const EdgeInsets.symmetric(horizontal: 8),
    super.inputSurfaceTintColor = const Color(0xCEF4F6FB),
    super.systemMessageTheme = const SystemMessageTheme(
      margin: EdgeInsets.only(
        bottom: 24,
        top: 8,
        left: 8,
        right: 8,
      ),
      textStyle: TextStyle(
        color: neutral2,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      ),
    ),
    super.typingIndicatorTheme = const TypingIndicatorTheme(
      animatedCirclesColor: neutral1,
      animatedCircleSize: 5.0,
      bubbleBorder: BorderRadius.all(Radius.circular(27.0)),
      bubbleColor: neutral7,
      countAvatarColor: primary,
      countTextColor: secondary,
      multipleUserTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: neutral2,
      ),
    ),
    super.unreadHeaderTheme = const UnreadHeaderTheme(
      color: secondary,
      textStyle: TextStyle(
        color: neutral2,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.333,
      ),
    ),
  }) : super(
          attachmentButtonMargin: null,
          userAvatarImageBackgroundColor: Colors.transparent,
          // Add the required parameters with default values
          dateDividerMargin: paddingHorSym8,
          inputElevation: 2.0,
          inputMargin: padding8,
          inputPadding: padding12,
          inputTextDecoration: const InputDecoration(),
          messageInsetsHorizontal: 8.0,
          messageInsetsVertical: 4.0,
          messageMaxWidth: 240.0,
          receivedEmojiMessageTextStyle: const TextStyle(
            fontSize: 28,
          ),
          sendButtonMargin: padding8,
          sentEmojiMessageTextStyle: const TextStyle(
            fontSize: 28,
          ),
          statusIconPadding: padding4,
        );
}
