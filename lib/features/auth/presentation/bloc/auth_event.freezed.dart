// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthCheckRequested value)?  authCheckRequested,TResult Function( LoginSubmitted value)?  loginSubmitted,TResult Function( SignUpSubmitted value)?  signUpSubmitted,TResult Function( GoogleSignInSubmitted value)?  googleSignInSubmitted,TResult Function( AppleSignInSubmitted value)?  appleSignInSubmitted,TResult Function( SendEmailVerificationSubmitted value)?  sendEmailVerificationSubmitted,TResult Function( CheckEmailVerifiedSubmitted value)?  checkEmailVerifiedSubmitted,TResult Function( SendPasswordResetSubmitted value)?  sendPasswordResetSubmitted,TResult Function( LogoutSubmitted value)?  logoutSubmitted,TResult Function( DeleteAccountSubmitted value)?  deleteAccountSubmitted,TResult Function( AuthStateChanged value)?  authStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested(_that);case LoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that);case SignUpSubmitted() when signUpSubmitted != null:
return signUpSubmitted(_that);case GoogleSignInSubmitted() when googleSignInSubmitted != null:
return googleSignInSubmitted(_that);case AppleSignInSubmitted() when appleSignInSubmitted != null:
return appleSignInSubmitted(_that);case SendEmailVerificationSubmitted() when sendEmailVerificationSubmitted != null:
return sendEmailVerificationSubmitted(_that);case CheckEmailVerifiedSubmitted() when checkEmailVerifiedSubmitted != null:
return checkEmailVerifiedSubmitted(_that);case SendPasswordResetSubmitted() when sendPasswordResetSubmitted != null:
return sendPasswordResetSubmitted(_that);case LogoutSubmitted() when logoutSubmitted != null:
return logoutSubmitted(_that);case DeleteAccountSubmitted() when deleteAccountSubmitted != null:
return deleteAccountSubmitted(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthCheckRequested value)  authCheckRequested,required TResult Function( LoginSubmitted value)  loginSubmitted,required TResult Function( SignUpSubmitted value)  signUpSubmitted,required TResult Function( GoogleSignInSubmitted value)  googleSignInSubmitted,required TResult Function( AppleSignInSubmitted value)  appleSignInSubmitted,required TResult Function( SendEmailVerificationSubmitted value)  sendEmailVerificationSubmitted,required TResult Function( CheckEmailVerifiedSubmitted value)  checkEmailVerifiedSubmitted,required TResult Function( SendPasswordResetSubmitted value)  sendPasswordResetSubmitted,required TResult Function( LogoutSubmitted value)  logoutSubmitted,required TResult Function( DeleteAccountSubmitted value)  deleteAccountSubmitted,required TResult Function( AuthStateChanged value)  authStateChanged,}){
final _that = this;
switch (_that) {
case AuthCheckRequested():
return authCheckRequested(_that);case LoginSubmitted():
return loginSubmitted(_that);case SignUpSubmitted():
return signUpSubmitted(_that);case GoogleSignInSubmitted():
return googleSignInSubmitted(_that);case AppleSignInSubmitted():
return appleSignInSubmitted(_that);case SendEmailVerificationSubmitted():
return sendEmailVerificationSubmitted(_that);case CheckEmailVerifiedSubmitted():
return checkEmailVerifiedSubmitted(_that);case SendPasswordResetSubmitted():
return sendPasswordResetSubmitted(_that);case LogoutSubmitted():
return logoutSubmitted(_that);case DeleteAccountSubmitted():
return deleteAccountSubmitted(_that);case AuthStateChanged():
return authStateChanged(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthCheckRequested value)?  authCheckRequested,TResult? Function( LoginSubmitted value)?  loginSubmitted,TResult? Function( SignUpSubmitted value)?  signUpSubmitted,TResult? Function( GoogleSignInSubmitted value)?  googleSignInSubmitted,TResult? Function( AppleSignInSubmitted value)?  appleSignInSubmitted,TResult? Function( SendEmailVerificationSubmitted value)?  sendEmailVerificationSubmitted,TResult? Function( CheckEmailVerifiedSubmitted value)?  checkEmailVerifiedSubmitted,TResult? Function( SendPasswordResetSubmitted value)?  sendPasswordResetSubmitted,TResult? Function( LogoutSubmitted value)?  logoutSubmitted,TResult? Function( DeleteAccountSubmitted value)?  deleteAccountSubmitted,TResult? Function( AuthStateChanged value)?  authStateChanged,}){
final _that = this;
switch (_that) {
case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested(_that);case LoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that);case SignUpSubmitted() when signUpSubmitted != null:
return signUpSubmitted(_that);case GoogleSignInSubmitted() when googleSignInSubmitted != null:
return googleSignInSubmitted(_that);case AppleSignInSubmitted() when appleSignInSubmitted != null:
return appleSignInSubmitted(_that);case SendEmailVerificationSubmitted() when sendEmailVerificationSubmitted != null:
return sendEmailVerificationSubmitted(_that);case CheckEmailVerifiedSubmitted() when checkEmailVerifiedSubmitted != null:
return checkEmailVerifiedSubmitted(_that);case SendPasswordResetSubmitted() when sendPasswordResetSubmitted != null:
return sendPasswordResetSubmitted(_that);case LogoutSubmitted() when logoutSubmitted != null:
return logoutSubmitted(_that);case DeleteAccountSubmitted() when deleteAccountSubmitted != null:
return deleteAccountSubmitted(_that);case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  authCheckRequested,TResult Function( String email,  String password)?  loginSubmitted,TResult Function( String username,  String email,  String password)?  signUpSubmitted,TResult Function()?  googleSignInSubmitted,TResult Function()?  appleSignInSubmitted,TResult Function()?  sendEmailVerificationSubmitted,TResult Function()?  checkEmailVerifiedSubmitted,TResult Function( String email)?  sendPasswordResetSubmitted,TResult Function()?  logoutSubmitted,TResult Function()?  deleteAccountSubmitted,TResult Function( UserEntity? user)?  authStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested();case LoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that.email,_that.password);case SignUpSubmitted() when signUpSubmitted != null:
return signUpSubmitted(_that.username,_that.email,_that.password);case GoogleSignInSubmitted() when googleSignInSubmitted != null:
return googleSignInSubmitted();case AppleSignInSubmitted() when appleSignInSubmitted != null:
return appleSignInSubmitted();case SendEmailVerificationSubmitted() when sendEmailVerificationSubmitted != null:
return sendEmailVerificationSubmitted();case CheckEmailVerifiedSubmitted() when checkEmailVerifiedSubmitted != null:
return checkEmailVerifiedSubmitted();case SendPasswordResetSubmitted() when sendPasswordResetSubmitted != null:
return sendPasswordResetSubmitted(_that.email);case LogoutSubmitted() when logoutSubmitted != null:
return logoutSubmitted();case DeleteAccountSubmitted() when deleteAccountSubmitted != null:
return deleteAccountSubmitted();case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.user);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  authCheckRequested,required TResult Function( String email,  String password)  loginSubmitted,required TResult Function( String username,  String email,  String password)  signUpSubmitted,required TResult Function()  googleSignInSubmitted,required TResult Function()  appleSignInSubmitted,required TResult Function()  sendEmailVerificationSubmitted,required TResult Function()  checkEmailVerifiedSubmitted,required TResult Function( String email)  sendPasswordResetSubmitted,required TResult Function()  logoutSubmitted,required TResult Function()  deleteAccountSubmitted,required TResult Function( UserEntity? user)  authStateChanged,}) {final _that = this;
switch (_that) {
case AuthCheckRequested():
return authCheckRequested();case LoginSubmitted():
return loginSubmitted(_that.email,_that.password);case SignUpSubmitted():
return signUpSubmitted(_that.username,_that.email,_that.password);case GoogleSignInSubmitted():
return googleSignInSubmitted();case AppleSignInSubmitted():
return appleSignInSubmitted();case SendEmailVerificationSubmitted():
return sendEmailVerificationSubmitted();case CheckEmailVerifiedSubmitted():
return checkEmailVerifiedSubmitted();case SendPasswordResetSubmitted():
return sendPasswordResetSubmitted(_that.email);case LogoutSubmitted():
return logoutSubmitted();case DeleteAccountSubmitted():
return deleteAccountSubmitted();case AuthStateChanged():
return authStateChanged(_that.user);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  authCheckRequested,TResult? Function( String email,  String password)?  loginSubmitted,TResult? Function( String username,  String email,  String password)?  signUpSubmitted,TResult? Function()?  googleSignInSubmitted,TResult? Function()?  appleSignInSubmitted,TResult? Function()?  sendEmailVerificationSubmitted,TResult? Function()?  checkEmailVerifiedSubmitted,TResult? Function( String email)?  sendPasswordResetSubmitted,TResult? Function()?  logoutSubmitted,TResult? Function()?  deleteAccountSubmitted,TResult? Function( UserEntity? user)?  authStateChanged,}) {final _that = this;
switch (_that) {
case AuthCheckRequested() when authCheckRequested != null:
return authCheckRequested();case LoginSubmitted() when loginSubmitted != null:
return loginSubmitted(_that.email,_that.password);case SignUpSubmitted() when signUpSubmitted != null:
return signUpSubmitted(_that.username,_that.email,_that.password);case GoogleSignInSubmitted() when googleSignInSubmitted != null:
return googleSignInSubmitted();case AppleSignInSubmitted() when appleSignInSubmitted != null:
return appleSignInSubmitted();case SendEmailVerificationSubmitted() when sendEmailVerificationSubmitted != null:
return sendEmailVerificationSubmitted();case CheckEmailVerifiedSubmitted() when checkEmailVerifiedSubmitted != null:
return checkEmailVerifiedSubmitted();case SendPasswordResetSubmitted() when sendPasswordResetSubmitted != null:
return sendPasswordResetSubmitted(_that.email);case LogoutSubmitted() when logoutSubmitted != null:
return logoutSubmitted();case DeleteAccountSubmitted() when deleteAccountSubmitted != null:
return deleteAccountSubmitted();case AuthStateChanged() when authStateChanged != null:
return authStateChanged(_that.user);case _:
  return null;

}
}

}

/// @nodoc


class AuthCheckRequested implements AuthEvent {
  const AuthCheckRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthCheckRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.authCheckRequested()';
}


}




/// @nodoc


class LoginSubmitted implements AuthEvent {
  const LoginSubmitted({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginSubmittedCopyWith<LoginSubmitted> get copyWith => _$LoginSubmittedCopyWithImpl<LoginSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginSubmitted&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginSubmitted(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $LoginSubmittedCopyWith(LoginSubmitted value, $Res Function(LoginSubmitted) _then) = _$LoginSubmittedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$LoginSubmittedCopyWithImpl<$Res>
    implements $LoginSubmittedCopyWith<$Res> {
  _$LoginSubmittedCopyWithImpl(this._self, this._then);

  final LoginSubmitted _self;
  final $Res Function(LoginSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(LoginSubmitted(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignUpSubmitted implements AuthEvent {
  const SignUpSubmitted({required this.username, required this.email, required this.password});
  

 final  String username;
 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpSubmittedCopyWith<SignUpSubmitted> get copyWith => _$SignUpSubmittedCopyWithImpl<SignUpSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpSubmitted&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,email,password);

@override
String toString() {
  return 'AuthEvent.signUpSubmitted(username: $username, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $SignUpSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignUpSubmittedCopyWith(SignUpSubmitted value, $Res Function(SignUpSubmitted) _then) = _$SignUpSubmittedCopyWithImpl;
@useResult
$Res call({
 String username, String email, String password
});




}
/// @nodoc
class _$SignUpSubmittedCopyWithImpl<$Res>
    implements $SignUpSubmittedCopyWith<$Res> {
  _$SignUpSubmittedCopyWithImpl(this._self, this._then);

  final SignUpSubmitted _self;
  final $Res Function(SignUpSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,Object? email = null,Object? password = null,}) {
  return _then(SignUpSubmitted(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GoogleSignInSubmitted implements AuthEvent {
  const GoogleSignInSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignInSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleSignInSubmitted()';
}


}




/// @nodoc


class AppleSignInSubmitted implements AuthEvent {
  const AppleSignInSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppleSignInSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.appleSignInSubmitted()';
}


}




/// @nodoc


class SendEmailVerificationSubmitted implements AuthEvent {
  const SendEmailVerificationSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendEmailVerificationSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.sendEmailVerificationSubmitted()';
}


}




/// @nodoc


class CheckEmailVerifiedSubmitted implements AuthEvent {
  const CheckEmailVerifiedSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckEmailVerifiedSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkEmailVerifiedSubmitted()';
}


}




/// @nodoc


class SendPasswordResetSubmitted implements AuthEvent {
  const SendPasswordResetSubmitted({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendPasswordResetSubmittedCopyWith<SendPasswordResetSubmitted> get copyWith => _$SendPasswordResetSubmittedCopyWithImpl<SendPasswordResetSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendPasswordResetSubmitted&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.sendPasswordResetSubmitted(email: $email)';
}


}

/// @nodoc
abstract mixin class $SendPasswordResetSubmittedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SendPasswordResetSubmittedCopyWith(SendPasswordResetSubmitted value, $Res Function(SendPasswordResetSubmitted) _then) = _$SendPasswordResetSubmittedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$SendPasswordResetSubmittedCopyWithImpl<$Res>
    implements $SendPasswordResetSubmittedCopyWith<$Res> {
  _$SendPasswordResetSubmittedCopyWithImpl(this._self, this._then);

  final SendPasswordResetSubmitted _self;
  final $Res Function(SendPasswordResetSubmitted) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(SendPasswordResetSubmitted(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LogoutSubmitted implements AuthEvent {
  const LogoutSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogoutSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutSubmitted()';
}


}




/// @nodoc


class DeleteAccountSubmitted implements AuthEvent {
  const DeleteAccountSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteAccountSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.deleteAccountSubmitted()';
}


}




/// @nodoc


class AuthStateChanged implements AuthEvent {
  const AuthStateChanged(this.user);
  

 final  UserEntity? user;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateChangedCopyWith<AuthStateChanged> get copyWith => _$AuthStateChangedCopyWithImpl<AuthStateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateChanged&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthEvent.authStateChanged(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthStateChangedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthStateChangedCopyWith(AuthStateChanged value, $Res Function(AuthStateChanged) _then) = _$AuthStateChangedCopyWithImpl;
@useResult
$Res call({
 UserEntity? user
});




}
/// @nodoc
class _$AuthStateChangedCopyWithImpl<$Res>
    implements $AuthStateChangedCopyWith<$Res> {
  _$AuthStateChangedCopyWithImpl(this._self, this._then);

  final AuthStateChanged _self;
  final $Res Function(AuthStateChanged) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(AuthStateChanged(
freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity?,
  ));
}


}

// dart format on
