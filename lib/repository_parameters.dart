import 'piku_callbacks.dart';
import 'piku_parameters.dart';

/// Represent all needed parameters necessary for [pikuRepositoryProvider] to successfully provide an instance
/// of [PikuRepository].
class RepositoryParameters {
  /// See [PikuParameters]
  PikuParameters params;

  /// See [PikuCallbacks]
  PikuCallbacks callbacks;

  RepositoryParameters({required this.params, required this.callbacks});
}
