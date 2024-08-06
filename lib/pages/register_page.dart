import 'package:flutter/material.dart';
import 'package:mini_mes/services/auth/auth_service.dart';
import 'package:mini_mes/components/my_button.dart';
import 'package:mini_mes/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final void Function()? onTap;



// register method
  void register(BuildContext context){
    // get auth service
    final _authService = AuthService();
    // if password natch -> create user
    if(_passwordController.text == _confirmPasswordController.text){
      try{
      _authService.signUpWithEmailPassword(
      _emailController.text, 
      _passwordController.text
      );
      } catch(e){
        showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ));
      }
    }
    // password dont match -> show error to user
    else{
      showDialog(
        context: context, 
        builder: (context) => const AlertDialog(
          title: Text("Password dont match"),
        ));
    }
  }

   RegisterPage({super.key, required this.onTap});


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
            "Let's create an account for you",
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
          
          const SizedBox(height: 10,),

           MyTextField(
            hintText: "Confirm password",
            obscureText: true,
            controller: _confirmPasswordController,
            ),

          const SizedBox(height: 25,),

          MyButton(
            text: "Register",
            onTap: () => register(context),
            ),
            const SizedBox(height: 25,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary
                ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Login now",
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
