import 'package:campus_connect/core/forms/email_input.dart';
import 'package:campus_connect/core/forms/name_input.dart';
import 'package:campus_connect/core/forms/password_input.dart';
import 'package:campus_connect/features/auth/presentation/cubit/sign_up_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpFormCubit extends Cubit<SignUpFormState> {
  SignUpFormCubit() : super(const SignUpFormState());

  void nameChanged(String value) {
    final name = state.name.isPure
        ? NameInput.pure(value)
        : NameInput.dirty(value);

    emit(state.copyWith(name: name));
  }

  void nameUnfocused() {
    if (!state.name.isPure) return;
    emit(state.copyWith(name: NameInput.dirty(state.name.value)));
  }

  void emailChanged(String value) {
    final email = state.email.isPure
        ? EmailInput.pure(value)
        : EmailInput.dirty(value);
    emit(state.copyWith(email: email));
  }

  void emailUnfocused() {
    if (!state.email.isPure) return;
    emit(state.copyWith(email: EmailInput.dirty(state.email.value)));
  }

  void passwordChanged(String value) {
    final password = state.password.isPure
        ? PasswordInput.pure(value)
        : PasswordInput.dirty(value);
    emit(state.copyWith(password: password));
  }

  void passwordUnfocused() {
    if (!state.password.isPure) return;
    emit(state.copyWith(password: PasswordInput.dirty(state.password.value)));
  }

  bool validate() {
    final name = NameInput.dirty(state.name.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    emit(state.copyWith(name: name, email: email, password: password));
    return Formz.validate([name, email, password]);
  }
}
