import 'package:flutter/material.dart';
import 'package:mini_mes/services/auth/auth_service.dart';
import 'package:mini_mes/components/my_button.dart';
import 'package:mini_mes/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  void login(BuildContext context) async{
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(_emailController.text, _passwordController.text);
    }catch (e){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ));
    }
    // 
  }

   LoginPage({super.key, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          
          const SizedBox(height: 50,),
          
          Text(
            "Welcome back, you've been missed!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25,),

           MyTextField(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
            ),
          
          const SizedBox(height: 10,),

           MyTextField(
            hintText: "Password",
            obscureText: true,
            controller: _passwordController,
            ),

          const SizedBox(height: 25,),

          MyButton(
            text: "Login",
            onTap: () => login(context),
            ),
            const SizedBox(height: 25,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary
                ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Register now",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
