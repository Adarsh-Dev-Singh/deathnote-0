//login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}
//register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUsedAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic Exceptions
class UserNotLoggedInAuthException implements Exception {}
class GenericAuthException implements Exception {}
