import 'package:equatable/equatable.dart';

class PikuParameters extends Equatable {
  final bool isPersistenceEnabled;
  final String baseUrl;
  final String clientInstanceKey;
  final String inboxIdentifier;
  final String? userIdentifier;

  const PikuParameters(
      {required this.isPersistenceEnabled,
      required this.baseUrl,
      required this.inboxIdentifier,
      required this.clientInstanceKey,
      this.userIdentifier});

  @override
  List<Object?> get props => [
        isPersistenceEnabled,
        baseUrl,
        clientInstanceKey,
        inboxIdentifier,
        userIdentifier
      ];
}
