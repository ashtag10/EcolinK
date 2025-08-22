/// Classe utilitaire pour encapsuler les données de résultat
/// Évaluez le résultat en utilisant une instruction switch :
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
/// Crée un [Result] réussi, complété avec la [value] spécifiée.
/// Crée un [Result] d'erreur, complété avec l'[error] spécifié.
/// Sous-classe de Result pour les valeurs
/// Valeur retournée dans le résultat
/// Sous-classe de Result pour les erreurs
/// Erreur retournée dans le résultat
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Valeur retournée dans le résultat
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Erreur retournée dans le résultat
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
