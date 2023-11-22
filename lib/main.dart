import 'package:flutter/material.dart';
import 'package:practice/constants/routes.dart';
import 'package:practice/services/auth/auth_service.dart';
import 'package:practice/views/loginview.dart';
import 'package:practice/views/notes/create_update_note_view.dart';
import 'package:practice/views/notes/notesview.dart';
import 'package:practice/views/registerview.dart';
import 'package:practice/views/verifyemail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const Homepage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmail(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNotesView(),
    },
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return VerifyEmail();
              }
            } else {
              return const LoginView();
            }

          //   print(user);
          //  if(user==null){
          //   return LoginView();
          //  }
          //   if (user?.emailVerified ?? false) {
          //   return const Text('Done');

          //   } else {
          //     return const VerifyEmail();
          //   }
          // return const LoginView();

          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
