import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/sign_in_controller.dart';
import '../controller/state/sign_in_state.dart';
import 'widgets/submit_button.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      //debe retornar la instancia de una clase que implemente change notifier (sign in controller)
      create: (_) => SignInController(
        const SignInState(),
        authenticationRepository: context.read(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(
                  context,
                  listen: true,
                );
                return AbsorbPointer(
                  //si fetchinh es true
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        //se actualizan los erroes del campo de texto en tiempo real
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUsernameChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'username',
                        ),
                        validator: (text) {
                          //null aware por si es un texto vacio
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return 'invalid username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        //se actualizan los erroes del campo de texto en tiempo real
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                        validator: (text) {
                          //null aware por si es un texto vacio
                          text = text?.trim() ?? '';
                          if (text.length < 4) {
                            return 'invalid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const SubmitButton()
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
