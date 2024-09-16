import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState({
    //valores por defecto a agregar
    @Default('') String username,
    @Default('')String password,
     @Default(false)bool fetching,
  }) = _SignInState;

}
