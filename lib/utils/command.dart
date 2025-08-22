import 'dart:async';

import 'package:flutter/foundation.dart';

import 'result.dart';

typedef CommandAction0<T> = Future<Result<T>> Function();
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

/// Facilite l'interaction avec un ViewModel.
///
/// Encapsule une action,
/// expose ses états d'exécution et d'erreur,
/// et garantit qu'elle ne peut pas être relancée avant d'être terminée.
///
/// Utilisez [Command0] pour les actions sans arguments.
/// Utilisez [Command1] pour les actions avec un argument.
///
/// Les actions doivent retourner un [Result].
///
/// Consommez le résultat de l'action en écoutant les changements,
/// puis appelez [clearResult] lorsque l'état est consommé.
abstract class Command<T> extends ChangeNotifier {
  Command();

  bool _running = false;

  /// Vrai lorsque l'action est en cours d'exécution.
  bool get running => _running;

  Result<T>? _result;

  /// vrai si l'action s'est terminée avec une erreur
  bool get error => _result is Error;

  /// vrai si l'action s'est terminée avec succès
  bool get completed => _result is Ok;

  /// Obtenir le dernier résultat de l'action
  Result? get result => _result;

  /// Effacer le dernier résultat de l'action
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Implémentation interne de l'exécution
  Future<void> _execute(CommandAction0<T> action) async {
    // S'assurer que l'action ne peut pas être lancée plusieurs fois.
    // Par exemple, éviter plusieurs appuis sur le bouton
    if (_running) return;

    // Notifier les écouteurs.
    // Par exemple, le bouton affiche l'état de chargement
    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// [Command] sans arguments.
/// Prend un [CommandAction0] comme action.
class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Exécute l'action.
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// [Command] avec un argument.
/// Prend un [CommandAction1] comme action.
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Exécute l'action avec l'argument.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
