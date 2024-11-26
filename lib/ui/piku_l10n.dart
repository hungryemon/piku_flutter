import 'package:flutter_chat_ui/flutter_chat_ui.dart';

/// Base chat l10n containing all required variables to provide localized Piku chat
class PikuL10n extends ChatL10n {
  /// Accessibility label (hint) for the attachment button
  final String attachmentButtonAccessibilityLabel;

  /// Placeholder when there are no messages
  final String emptyChatPlaceholder;

  /// Accessibility label (hint) for the tap action on file message
  final String fileButtonAccessibilityLabel;

  /// Placeholder for the text field
  final String inputPlaceholder;

  /// Placeholder for the text field
  final String onlineText;

  /// Placeholder for the text field
  final String offlineText;

  /// Placeholder for the text field
  final String typingText;

  /// Accessibility label (hint) for the send button
  final String sendButtonAccessibilityLabel;

  /// Message when agent resolves conversation
  final String conversationResolvedMessage;

  /// Label for the unread messages header.
  final String unreadMessagesLabel;

  final String isTyping;

  /// Word 'others', currently part of the typing indicator.
  final String others;

  /// Word 'and', currently part of the typing indicator.
  final String and;

  /// Creates a new Piku l10n
  const PikuL10n({
    this.attachmentButtonAccessibilityLabel = "",
    this.emptyChatPlaceholder = "",
    this.fileButtonAccessibilityLabel = "",
    this.onlineText = "Typically replies in a few hours",
    this.offlineText = "We're away at the moment",
    this.typingText = "typing...",
    this.inputPlaceholder = "Type your message",
    this.sendButtonAccessibilityLabel = "Send Message",
    this.conversationResolvedMessage =
        "Your ticket has been marked as resolved",
    this.and = '',
    this.isTyping = '',
    this.others = '',
    this.unreadMessagesLabel = '',
  }) : super(
            attachmentButtonAccessibilityLabel:
                attachmentButtonAccessibilityLabel,
            emptyChatPlaceholder: emptyChatPlaceholder,
            fileButtonAccessibilityLabel: fileButtonAccessibilityLabel,
            inputPlaceholder: inputPlaceholder,
            sendButtonAccessibilityLabel: sendButtonAccessibilityLabel,
            and: and,
            isTyping: isTyping,
            others: others,
            unreadMessagesLabel: unreadMessagesLabel);
}
