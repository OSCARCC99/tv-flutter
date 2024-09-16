import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../global/controllers/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    //inicializar la vista
    WidgetsBinding.instance.addPersistentFrameCallback(
      (_) {
        _init();
      },
    );
  }

  Future<void> _init() async {
    final ConnectvityRepository connectvityRepository = context.read();
    final AuthenticationRepository authenticationRepository = context.read();
    final hasInternet = await connectvityRepository.hasInternet;
    final AccountRepository accountRepository = context.read();
    final SessionController sessionController = context.read();

    print('Si tiene internet boludo $hasInternet');
/*
    if(!hasInternet){
      //return Routes.offline;
    }

    final isSignedIn = await authenticationRepository.isSignedIn;

    if(!isSignedIn){
      return Routes.signIn;
    }

    final user = await accountRepository.getUserData();

    if(user!= null){
      sessionController.setUser(user);
      return Routes.home;
    } 
    Routes.signIn;
    }();

    if(mounted) {
      _goTo(routeName);
    }
    */
    //si hay conexion a internet carg auna vista
    if (hasInternet) {
      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final user = await accountRepository.getUserData();
        if (mounted) {
          if (user != null) {
            //home
            _goTo(Routes.home);
          } else {
            //sign in
            _goTo(Routes.signIn);
          }
        }
        //verifica si el widget sigue activo
      } else if (mounted) {
        _goTo(Routes.signIn);
      }
    }
    //si no hay conexion carga otra vista
    else {}
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
